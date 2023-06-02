local meta = FindMetaTable("Player")

function meta:AddInventoryItem(item)
	if not GAMEMODE:IsInventoryItem(item) then return false end

	self.ZSInventory[item] = self.ZSInventory[item] and self.ZSInventory[item] + 1 or 1

	if GAMEMODE:GetInventoryItemType(item) == INVCAT_TRINKETS then
		self:ApplyTrinkets()
	end

	net.Start("zs_inventoryitem")
		net.WriteString(item)
		net.WriteInt(self.ZSInventory[item], 5)
	net.Send(self)

	return true
end

function meta:TakeInventoryItem(item)
	if not self:HasInventoryItem(item) then return false end

	local setnil = self.ZSInventory[item] == 1
	self.ZSInventory[item] = self.ZSInventory[item] - 1

	if setnil then
		self.ZSInventory[item] = nil
	end

	if GAMEMODE:GetInventoryItemType(item) == INVCAT_TRINKETS then
		self:ApplyTrinkets()
	end

	net.Start("zs_inventoryitem")
		net.WriteString(item)
		net.WriteInt(self.ZSInventory[item] or 0, 5)
	net.Send(self)

	return true -- Return true aka item was taken
end

function meta:WipePlayerInventory()
	if not self.ZSInventory or table.Count(self.ZSInventory) == 0 then return end

	self.ZSInventory = {}
	self:ApplyTrinkets()

	net.Start("zs_wipeinventory")
	net.Send(self)
end

net.Receive("zs_trycraft", function(len, pl)
	local component = net:ReadString()
	local weapon = net:ReadString()

	pl:TryAssembleItem(component, weapon)
end)

function meta:TryAssembleItem(component, component2)
	local weapon = self:GetWeapon(component2)
	local isWeaponComponent = IsValid(weapon)
	local craftedItem

	if not self:HasInventoryItem(component) or not self:HasInventoryItem(component2) then
		self:CenterNotify(COLOR_RED, "You don't have the item to craft this with.")
		self:SendLua("surface.PlaySound(\"buttons/button10.wav\")")
		return
	end

	for assembly, reqs in pairs(GAMEMODE.Assemblies) do
		local reqcomp, reqcomp2 = reqs[1], reqs[2]
		if reqcomp == component and reqcomp2 == component2 then
			craftedItem = assembly
			break
		end
	end

	if not craftedItem then
		self:CenterNotify(COLOR_RED, "You can't make anything with these items.")
		self:SendLua("surface.PlaySound(\"buttons/button10.wav\")")
		return
	end

	if isWeaponComponent then
		if weapon.AmmoIfHas then
			self:GiveAmmo(1, weapon.Primary.Ammo)
		end
		self:GiveEmptyWeapon(craftedItem)
		self:SelectWeapon(craftedItem)
		self:UpdateAltSelectedWeapon()
		self:CenterNotify(COLOR_LIMEGREEN, translate.ClientGet(self, "crafting_successful"), color_white, "   ("..weapon.PrintName..")")
	else
		self:AddInventoryItem(craftedItem)
		self:CenterNotify(COLOR_LIMEGREEN, translate.ClientGet(self, "crafting_successful"), color_white, "   ("..GAMEMODE.ZSInventoryItemData[craftedItem].PrintName..")")
	end

	self:TakeInventoryItem(component)
	if isWeaponComponent then
		weapon:EmptyAll(true)
		if weapon.AmmoIfHas then
			self:RemoveAmmo(1, weapon.Primary.Ammo)
		end
		self:StripWeapon(component2)
	else
		self:TakeInventoryItem(component2)
	end

	self:SendLua("surface.PlaySound(\"buttons/lever"..math.random(5)..".wav\")")
	GAMEMODE.StatTracking:IncreaseElementKV(STATTRACK_TYPE_WEAPON, craftedItem, "Crafts", 1)
end

function meta:DropInventoryItemByType(itype)
	if GAMEMODE.ZombieEscape then return end
	if not self:HasInventoryItem(itype) then return end

	local ent = ents.Create("prop_invitem")
	if ent:IsValid() then
		ent:SetInventoryItemType(itype)
		ent:Spawn()
		ent.DroppedTime = CurTime()

		self:TakeInventoryItem(itype)
		self:UpdateAltSelectedWeapon()

		return ent
	end
end

function meta:DropAllInventoryItems()
	local vPos = self:GetPos()
	local vVel = self:GetVelocity()
	local zmax = self:OBBMaxs().z * 0.75
	for invitem, count in pairs(self:GetInventoryItems()) do
		for i = 1, count do
			local ent = self:DropInventoryItemByType(invitem)
			if ent and ent:IsValid() then
				ent:SetPos(vPos + Vector(math.Rand(-16, 16), math.Rand(-16, 16), math.Rand(2, zmax)))
				ent:SetAngles(VectorRand():Angle())
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:AddAngleVelocity(Vector(math.Rand(-720, 720), math.Rand(-720, 720), math.Rand(-720, 720)))
					phys:ApplyForceCenter(phys:GetMass() * (math.Rand(32, 328) * VectorRand():GetNormalized() + vVel))
				end
			end
		end
	end
end

function meta:GiveInventoryItemByType(itype, plyr)
	if GAMEMODE.ZombieEscape then return end
	if not self:HasInventoryItem(itype) then return end

	if GAMEMODE:GetInventoryItemType(itype) == INVCAT_TRINKETS and plyr:HasInventoryItem(itype) then
		self:CenterNotify(COLOR_RED, translate.ClientGet(self, "they_already_have_this_trinket"))
		return
	end

	self:TakeInventoryItem(itype)
	self:UpdateAltSelectedWeapon()

	net.Start("zs_invgiven")
		net.WriteString(itype)
		net.WriteEntity(self)
	net.Send(plyr)

	plyr:AddInventoryItem(itype)
end

function GM:IsInventoryItem(item)
	return self.ZSInventoryItemData[item] ~= nil or weapons.Get(item) ~= nil
end

function meta:GetInventoryItems()
	return self.ZSInventory
end

function meta:HasInventoryItem(item)
	return self.ZSInventory[item]
end

hook.Add("WeaponEquip", "ZS.Inventory.AddWeapon", function(weapon, ply)
	if not weapon.IsTrinket then
		ply:AddInventoryItem(weapon:GetClass())
	end
end)

hook.Add("PlayerDroppedWeapon", "ZS.Inventory.RemoveWeapon", function(owner, weapon)
	if not weapon.IsTrinket then
		owner:TakeInventoryItem(weapon:GetClass())
	end
end)
