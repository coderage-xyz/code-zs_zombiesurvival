GM.ZSInventory = {}

INVCAT_WEAPONS = 1
INVCAT_TRINKETS = 2
INVCAT_COMPONENTS = 3
INVCAT_CONSUMABLES = 4

local meta = FindMetaTable("Player")
function meta:GetInventoryItems()
	return GAMEMODE.ZSInventory
end

function meta:HasInventoryItem(item)
	return GAMEMODE.ZSInventory[item] and GAMEMODE.ZSInventory[item] > 0
end

net.Receive("zs_inventoryitem", function()
	local item = net.ReadString()
	local count = net.ReadInt(5)
	local prevcount = GAMEMODE.ZSInventory[item] or 0

	GAMEMODE.ZSInventory[item] = count

	if GAMEMODE.InventoryMenu and GAMEMODE.InventoryMenu:IsValid() then
		if count > prevcount then
			GAMEMODE:InventoryAddGridItem(item, GAMEMODE:GetInventoryItemType(item))
		else
			GAMEMODE:InventoryRemoveGridItem(item)
		end
	end

	if MySelf and MySelf:IsValid() then
		MySelf:ApplyTrinkets()
	end
end)

net.Receive("zs_wipeinventory", function()
	GAMEMODE.ZSInventory = {}

	if GAMEMODE.InventoryMenu and GAMEMODE.InventoryMenu:IsValid() then
		GAMEMODE:InventoryWipeGrid()
	end

	MySelf:ApplyTrinkets()
end)

local function TryCraftWithComponent(me)
	net.Start("zs_trycraft")
		net.WriteString(me.Item)
		net.WriteString(me.WeaponCraft)
	net.SendToServer()
end

function GM:UpdateSelectedItemName()
	if GAMEMODE.HumanMenuPanel then
		if GAMEMODE.InventoryMenu.SelInv then
			GAMEMODE.HumanMenuPanel.SelectedItemLabel:SetText(GAMEMODE.ZSInventoryItemData[GAMEMODE.InventoryMenu.SelInv] and GAMEMODE.ZSInventoryItemData[GAMEMODE.InventoryMenu.SelInv].PrintName or weapons.Get(GAMEMODE.InventoryMenu.SelInv).PrintName)
		else
			GAMEMODE.HumanMenuPanel.SelectedItemLabel:SetText("NONE")
		end
	end
end

local function ItemPanelDoClick(self)
	local item = self.Item
	if not item then return end

	local sweptable = self.Category == INVCAT_WEAPONS and weapons.Get(item) or GAMEMODE.ZSInventoryItemData[item]
	local viewer = GAMEMODE.m_InvViewer
	local screenscale = BetterScreenScale()

	if not self.On then
		for _, v in pairs(self:GetParent():GetChildren()) do
			v.On = false
		end
		self.On = true

		GAMEMODE.InventoryMenu.SelInv = item
		GAMEMODE:DoAltSelectedItemUpdate()
	end

	GAMEMODE:CreateInventoryInfoViewer()

	viewer = GAMEMODE.m_InvViewer
	viewer.m_Title:SetText(sweptable.PrintName)
	viewer.m_Title:PerformLayout()

	local desctext = sweptable.Description or ""
	if self.Category == INVCAT_WEAPONS then
		viewer.ModelPanel:SetModel(sweptable.WorldModel)
		if sweptable.WorldModel ~= "" then
			local mins, maxs = viewer.ModelPanel.Entity:GetRenderBounds()
			viewer.ModelPanel:SetCamPos(mins:Distance(maxs) * Vector(1.15, 0.75, 0.5))
			viewer.ModelPanel:SetLookAt((mins + maxs) / 2)
		end
		viewer.m_VBG:SetVisible(true)

		viewer.m_Desc:MoveBelow(viewer.m_VBG, 8)
		viewer.m_Desc:SetFont("ZSBodyTextFont")

		local canammo = false
		if sweptable.Primary then
			local ammotype = sweptable.Primary.Ammo
			if GAMEMODE.AmmoToPurchaseNames[ammotype] then
				canammo = true
			end
		end

		if canammo and GAMEMODE.AmmoNames[string.lower(sweptable.Primary.Ammo)] then
			viewer.m_AmmoType:SetText(GAMEMODE.AmmoNames[string.lower(sweptable.Primary.Ammo)])
			viewer.m_AmmoType:PerformLayout()
		else
			viewer.m_AmmoType:SetText("")
		end
	else
		viewer.ModelPanel:SetModel("")
		viewer.m_VBG:SetVisible(false)

		viewer.m_Desc:MoveBelow(viewer.m_Title, 20)
		viewer.m_Desc:SetFont("ZSBodyTextFontBig")

		viewer.m_AmmoType:SetText("")
	end
	viewer.m_Desc:SetText(desctext)

	local pointShopItemCategory
	for _, pointShopItem in pairs(GAMEMODE.Items) do
		if pointShopItem.SWEP == item then
			pointShopItemCategory = pointShopItem.Category
			break
		end
	end
	GAMEMODE:ViewerStatBarUpdate(viewer, not pointShopItemCategory or (pointShopItemCategory and pointShopItemCategory ~= ITEMCAT_GUNS and pointShopItemCategory ~= ITEMCAT_MELEE), sweptable)

	for i = 1, 3 do
		local crab, cral = viewer.m_CraftBtns[i][1], viewer.m_CraftBtns[i][2]

		crab:SetVisible(false)
		cral:SetVisible(false)
	end

	local assembles = {}
	for k,v in pairs(GAMEMODE.Assemblies) do
		if v[1] == item then
			assembles[v[2]] = k
		end
	end

	local count = 0
	for k,v in pairs(assembles) do
		count = count + 1

		local crab, cral = viewer.m_CraftBtns[count][1], viewer.m_CraftBtns[count][2]
		local iitype = GAMEMODE:GetInventoryItemType(k) ~= -1

		crab.Item = item
		crab.WeaponCraft = k
		crab.DoClick = TryCraftWithComponent
		crab:SetPos(viewer:GetWide() / 2 - crab:GetWide() / 2, (viewer:GetTall() - 33 * screenscale) - (count - 1) * 33 * screenscale)
		crab:SetVisible(true)

		cral:SetText((iitype and GAMEMODE.ZSInventoryItemData[k] or weapons.Get(k)).PrintName)
		cral:SetPos(crab:GetWide() / 2 - cral:GetWide() / 2, (crab:GetTall() * 0.5 - cral:GetTall() * 0.5))
		cral:SetContentAlignment(5)
		cral:SetVisible(true)
	end

	if count > 0 then
		viewer.m_CraftWith:SetPos(viewer:GetWide() / 2 - viewer.m_CraftWith:GetWide() / 2, (viewer:GetTall() - 33 * screenscale) - 33 * count * screenscale)
		viewer.m_CraftWith:SetContentAlignment(5)
		viewer.m_CraftWith:SetVisible(true)
	else
		viewer.m_CraftWith:SetVisible(false)
	end

	GAMEMODE:UpdateSelectedItemName()
end

local categorycolors = {
	[INVCAT_WEAPONS] = {COLOR_GREEN, COLOR_DARKGREEN},
	[INVCAT_TRINKETS] = {COLOR_RED, COLOR_DARKRED},
	[INVCAT_COMPONENTS] = {COLOR_BLUE, COLOR_DARKBLUE},
	[INVCAT_CONSUMABLES] = {COLOR_YELLOW, COLOR_DARKYELLOW}
}
local colBG = Color(10, 10, 10, 252)
local colBGH = Color(200, 200, 200, 5)
local function ItemPanelPaint(self, w, h)
	draw.RoundedBox(2, 0, 0, w, h, (self.Depressed or self.On) and categorycolors[self.Category][1] or categorycolors[self.Category][2])
	draw.RoundedBox(2, 2, 2, w - 4, h - 4, colBG)
	if self.On or self.Hovered then
		draw.RoundedBox(2, 2, 2, w - 4, h - 4, colBGH)
	end

	return true
end

function GM:CreateInventoryInfoViewer()
	if self.m_InvViewer and self.m_InvViewer:IsValid() then
		self.m_InvViewer:SetVisible(true)
		return
	end

	local leftframe = self.InventoryMenu
	local viewer = vgui.Create("DFrame")

	local screenscale = BetterScreenScale()

	viewer:SetDeleteOnClose(false)
	viewer:SetTitle(" ")
	viewer:SetDraggable(false)
	if viewer.btnClose and viewer.btnClose:IsValid() then viewer.btnClose:SetVisible(false) end
	if viewer.btnMinim and viewer.btnMinim:IsValid() then viewer.btnMinim:SetVisible(false) end
	if viewer.btnMaxim and viewer.btnMaxim:IsValid() then viewer.btnMaxim:SetVisible(false) end

	viewer:SetSize(leftframe:GetWide() / 1.25, leftframe:GetTall())
	viewer:MoveRightOf(leftframe, 32)
	viewer:MoveAbove(leftframe, -leftframe:GetTall())
	self.m_InvViewer = viewer

	self:CreateItemViewerGenericElems(viewer)

	local craftbtns = {}
	for i = 1, 3 do
		local craftb = vgui.Create("DButton", viewer)
		craftb:SetText("")
		craftb:SetSize(viewer:GetWide() / 1.15, 27 * screenscale)
		craftb:SetVisible(false)

		local namelab = EasyLabel(craftb, "...", "ZSBodyTextFont", COLOR_WHITE)
		namelab:SetWide(craftb:GetWide())
		namelab:SetVisible(false)

		craftbtns[i] = {craftb, namelab}
	end
	viewer.m_CraftBtns = craftbtns

	local craftwith = EasyLabel(viewer, "Craft With...", "ZSBodyTextFontBig", COLOR_WHITE)
	craftwith:SetSize(viewer:GetWide() / 1.15, 27 * screenscale)
	craftwith:SetVisible(false)
	viewer.m_CraftWith = craftwith
end

local NumToRomanNumeral = {
	"I", "II", "III", "IV", "V", "VI"
}

function GM:InventoryAddGridItem(item, category)
	local screenscale = BetterScreenScale()
	local grid = self.InventoryMenu.Grid

	local itempan = vgui.Create("DButton")
	itempan:SetText("")
	itempan:SetSize(64 * screenscale, 64 * screenscale)
	itempan.Paint = ItemPanelPaint
	itempan.DoClick = ItemPanelDoClick
	itempan.Item = item
	itempan.Category = category

	grid:AddItem(itempan)
	grid:SortByMember("Category")

	local mdlframe = vgui.Create("DPanel", itempan)
	mdlframe:SetSize(60 * screenscale, 30 * screenscale)
	mdlframe:Center()
	mdlframe:SetMouseInputEnabled(false)
	mdlframe.Paint = function() end

	local trintier = EasyLabel(itempan, "", "ZSHUDFontSmaller", COLOR_WHITE)
	trintier:CenterHorizontal(0.8)
	trintier:CenterVertical(0.8)

	if category == INVCAT_TRINKETS then
		local tier = GAMEMODE.ZSInventoryItemData[item].Tier or 1
		trintier:SetText(NumToRomanNumeral[tier])
		trintier:SizeToContents()
		trintier:CenterHorizontal(0.8)
		trintier:CenterVertical(0.8)
	end

	local kitbl
	if category == INVCAT_TRINKETS then
		kitbl = killicon.Get("weapon_zs_trinket")
	elseif category == INVCAT_WEAPONS then
		kitbl = killicon.Get(item)
	else
		kitbl = killicon.Get("weapon_zs_craftables")
	end
	if kitbl then
		self:AttachKillicon(kitbl, itempan, mdlframe)
	end
end

function GM:InventoryRemoveGridItem(item)
	local grid = self.InventoryMenu.Grid
	for k, v in pairs(grid:GetChildren()) do
		if v.Item == item then
			grid:RemoveItem(v)
			break
		end
	end
	grid:SortByMember("Category")

	if self.InventoryMenu.SelInv == item then
		if self.m_InvViewer and self.m_InvViewer:IsValid() and self.InventoryMenu.SelInv then
			self.m_InvViewer:SetVisible(false)
		end

		self.InventoryMenu.SelInv = nil
		self:DoAltSelectedItemUpdate()
	end
end

function GM:InventoryWipeGrid()
	local grid = self.InventoryMenu.Grid
	for k, v in pairs(grid:GetChildren()) do
		grid:RemoveItem(v)
	end

	if self.m_InvViewer and self.m_InvViewer:IsValid() then
		self.m_InvViewer:SetVisible(false)
	end

	self.InventoryMenu.SelInv = nil
	self:DoAltSelectedItemUpdate()
end

function GM:InventorySelectCurrentWeaponItem()
	if self.InventoryMenu then
		local weapon = LocalPlayer():GetActiveWeapon()
		if IsValid(weapon) then
			local weaponClass = weapon:GetClass()
			local children = self.InventoryMenu.Grid:GetChildren()
			local clicked = false
			for _, itempan in ipairs(children) do
				if itempan.Item == weaponClass then
					ItemPanelDoClick(itempan)
					clicked = true
					break
				end
			end
			if not clicked then
				if children[1] then
					ItemPanelDoClick(children[1])
				end
				clicked = true
			end
		end
	end
end

function GM:OpenInventory()
	if self.InventoryMenu and self.InventoryMenu:IsValid() then
		self.InventoryMenu:SetVisible(true)

		if self.m_InvViewer and self.m_InvViewer:IsValid() and self.InventoryMenu.SelInv then
			self.m_InvViewer:SetVisible(true)
		end

		self:InventorySelectCurrentWeaponItem()

		return
	end

	local screenscale = BetterScreenScale()
	local wid, hei = math.max(400, math.min(ScrW(), 400) * screenscale), math.min(ScrH(), 500) * screenscale

	local frame = vgui.Create("DFrame")
	frame:SetSize(wid, hei)
	frame:CenterHorizontal(0.385)
	frame:CenterVertical()
	frame:SetDeleteOnClose(false)
	frame:SetTitle("")
	frame:SetDraggable(false)

	if frame.btnClose and frame.btnClose:IsValid() then frame.btnClose:SetVisible(false) end
	if frame.btnMinim and frame.btnMinim:IsValid() then frame.btnMinim:SetVisible(false) end
	if frame.btnMaxim and frame.btnMaxim:IsValid() then frame.btnMaxim:SetVisible(false) end

	self.InventoryMenu = frame

	local topspace = vgui.Create("DPanel", frame)
	topspace:SetWide(wid - 16)

	local title = EasyLabel(topspace, "Inventory", "ZSHUDFontSmall", COLOR_WHITE)
	title:CenterHorizontal()

	local _, y = title:GetPos()
	topspace:SetTall(y + title:GetTall() + 2)
	topspace:AlignTop(8)
	topspace:CenterHorizontal()

	local invListPanel = vgui.Create("DScrollPanel", frame)
	invListPanel:Dock( FILL )
	local sbar = invListPanel:GetVBar()
	sbar.Enabled = true
	invListPanel:DockMargin(0, topspace:GetTall() + 8, 0, 0)
	invListPanel:InvalidateParent(true)

	local invgrid = vgui.Create("DGrid", invListPanel)
	invgrid:SetSize(invListPanel:GetWide() - sbar:GetWide(), invListPanel:GetTall())
	invgrid:SetCols(5)
	invgrid:SetColWide((70 + (invgrid:GetWide() - 70*5) / 4) * screenscale)
	invgrid:SetRowHeight(70 * screenscale)
	frame.Grid = invgrid

	for item, count in pairs(self.ZSInventory) do
		if count > 0 then
			for i = 1, count do
				self:InventoryAddGridItem(item, self:GetInventoryItemType(item))
			end
		end
	end

	invgrid:SortByMember("Category")

	self:InventorySelectCurrentWeaponItem()

	frame:MakePopup()
end
