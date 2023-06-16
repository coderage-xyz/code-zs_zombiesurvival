INC_SERVER()

function SWEP:PlayRepairSound(hitent)
	hitent:EmitSound("npc/dog/dog_servo"..math.random(7, 8)..".wav", 70, math.random(100, 105))
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if CLIENT or not hitent:IsValid() then return end

	local owner = self:GetOwner()
	local repaired = false

	if hitent.HitByWrench and hitent:HitByWrench(self, owner, tr) then
		repaired = true
	end

	if hitent:IsNailed() then
		if owner:IsSkillActive(SKILL_BARRICADEEXPERT) then
			hitent.ReinforceEnd = CurTime() + 2
			hitent.ReinforceApplier = owner
		end

		local healstrength = self.HealStrength * GAMEMODE.NailHealthPerRepair * (owner.RepairRateMul or 1)
		local oldhealth = hitent:GetBarricadeHealth()
		if oldhealth <= 0 or oldhealth >= hitent:GetMaxBarricadeHealth() or hitent:GetBarricadeRepairs() <= 0.01 then return end

		hitent:SetBarricadeHealth(math.min(hitent:GetMaxBarricadeHealth(), hitent:GetBarricadeHealth() + math.min(hitent:GetBarricadeRepairs(), healstrength)))
		local healed = hitent:GetBarricadeHealth() - oldhealth
		hitent:SetBarricadeRepairs(math.max(hitent:GetBarricadeRepairs() - healed, 0))

		gamemode.Call("PlayerRepairedObject", owner, hitent, healed, self)

		repaired = true
	elseif hitent.GetObjectHealth then
		local oldhealth = hitent:GetObjectHealth()
		if oldhealth <= 0 or oldhealth >= hitent:GetMaxObjectHealth() or hitent.m_LastDamaged and CurTime() < hitent.m_LastDamaged + 4 then return end

		local healstrength = self.RepairStrength * (owner.RepairRateMul or 1) * (hitent.WrenchRepairMultiplier or 1)

		hitent:SetObjectHealth(math.min(hitent:GetMaxObjectHealth(), hitent:GetObjectHealth() + healstrength))
		local healed = hitent:GetObjectHealth() - oldhealth

		gamemode.Call("PlayerRepairedObject", owner, hitent, healed / 2, self)

		repaired = true
	end

	if repaired then
		self:PlayRepairSound(hitent)

		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
			effectdata:SetMagnitude(1)
		util.Effect("nailrepaired", effectdata, true, true)

		return true
	end
end
