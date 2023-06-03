DEFINE_BASECLASS("DPanel")

local PANEL = {}

function PANEL:Init()
	BaseClass.Init(self)

	self.label = EasyLabel(self, "Options", "ZSScoreBoardTitle", color_white)
	self.label:Dock(TOP)
	self.label:SetContentAlignment(5)

	self.list = vgui.Create("DPanelList", self)
	self.list:EnableVerticalScrollbar()
	self.list:EnableHorizontal(false)
	self.list:Dock(FILL)
	self.list:SetPadding(8)
	self.list:SetSpacing(4)

	gamemode.Call("AddExtraOptions", self.list, self)

	local check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Always display nail health")
	check:SetConVar("zs_alwaysshownails")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Always third person knockdown camera")
	check:SetConVar("zs_thirdpersonknockdown")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Always volunteer to start as a zombie")
	check:SetConVar("zs_alwaysvolunteer")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Always quick buy from arsenal and remantler")
	check:SetConVar("zs_alwaysquickbuy")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Automatic suicide when changing classes")
	check:SetConVar("zs_suicideonchange")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Disable automatic redeeming (next round)")
	check:SetConVar("zs_noredeem")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Disable pressing use to deposit ammo in deployables")
	check:SetConVar("zs_nousetodeposit")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Disable use to prop pickup (only pickup items)")
	check:SetConVar("zs_nopickupprops")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Disable iron sights view model translation")
	check:SetConVar("zs_noironsights")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Disable crosshair rotate")
	check:SetConVar("zs_nocrosshairrotate")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Disable ironsight scopes")
	check:SetConVar("zs_disablescopes")
	check:SizeToContents()
	self.list:AddItem(check)

	-- check = vgui.Create("DCheckBoxLabel", self)
	-- check:SetText("Display experience")
	-- check:SetConVar("zs_drawxp")
	-- check:SizeToContents()
	-- self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Don't show point floaters")
	check:SetConVar("zs_nofloatingscore")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Don't hide arsenal and resupply packs")
	check:SetConVar("zs_hidepacks")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Don't hide friends via transparency")
	check:SetConVar("zs_showfriends")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Draw crosshair in ironsights.")
	check:SetConVar("zs_ironsightscrosshair")
	check:SizeToContents()
	self.list:AddItem(check)

	-- check = vgui.Create("DCheckBoxLabel", self)
	-- check:SetText("Enable ambient music")
	-- check:SetConVar("zs_beats")
	-- check:SizeToContents()
	-- self.list:AddItem(check)

	-- check = vgui.Create("DCheckBoxLabel", self)
	-- check:SetText("Enable last human music")
	-- check:SetConVar("zs_playmusic")
	-- check:SizeToContents()
	-- self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Enable post processing")
	check:SetConVar("zs_postprocessing")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Enable film grain")
	check:SetConVar("zs_filmgrain")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Enable Color Mod")
	check:SetConVar("zs_colormod")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Enable pain flashes")
	check:SetConVar("zs_drawpainflash")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Enable font effects")
	check:SetConVar("zs_fonteffects")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Enable human health auras")
	check:SetConVar("zs_auras")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Enable damage indicators")
	check:SetConVar("zs_damagefloaters")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Enable movement view roll")
	check:SetConVar("zs_movementviewroll")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Enable message beacon visibility")
	check:SetConVar("zs_messagebeaconshow")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Film Mode (disable most of the HUD)")
	check:SetConVar("zs_filmmode")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Hide view models")
	check:SetConVar("zs_hideviewmodels")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Prevent being picked as a boss zombie")
	check:SetConVar("zs_nobosspick")
	check:SizeToContents()
	self.list:AddItem(check)

	check = vgui.Create("DCheckBoxLabel", self)
	check:SetText("Show damage indicators through walls")
	check:SetConVar("zs_damagefloaterswalls")
	check:SizeToContents()
	self.list:AddItem(check)

	self.list:AddItem(EasyLabel(self, "Weapon HUD display style", "DefaultFontSmall", color_white))
	local dropdown = vgui.Create("DComboBox", self)
	dropdown:SetMouseInputEnabled(true)
	dropdown:AddChoice("Display in 3D")
	dropdown:AddChoice("Display in 2D")
	dropdown:AddChoice("Display both")
	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_weaponhudmode", value == "Display both" and 2 or value == "Display in 2D" and 1 or 0)
	end
	dropdown:SetText(GAMEMODE.WeaponHUDMode == 2 and "Display both" or GAMEMODE.WeaponHUDMode == 1 and "Display in 2D" or "Display in 3D")
	dropdown:SetTextColor(color_black)
	self.list:AddItem(dropdown)

	self.list:AddItem(EasyLabel(self, "Health target display style", "DefaultFontSmall", color_white))
	dropdown = vgui.Create("DComboBox", self)
	dropdown:SetMouseInputEnabled(true)
	dropdown:AddChoice("% of health")
	dropdown:AddChoice("Health amount")
	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_healthtargetdisplay", value == "Health amount" and 1 or 0)
	end
	dropdown:SetText(GAMEMODE.HealthTargetDisplay == 1 and "Health amount" or "% of health")
	dropdown:SetTextColor(color_black)
	self.list:AddItem(dropdown)

	self.list:AddItem(EasyLabel(self, "Prop rotation snap angle", "DefaultFontSmall", color_white))
	dropdown = vgui.Create("DComboBox", self)
	dropdown:SetMouseInputEnabled(true)
	dropdown:AddChoice("No snap")
	dropdown:AddChoice("15 degrees")
	dropdown:AddChoice("30 degrees")
	dropdown:AddChoice("45 degrees")
	dropdown.OnSelect = function(me, index, value, data)
		RunConsoleCommand("zs_proprotationsnap", value == "15 degrees" and 15 or value == "30 degrees" and 30 or value == "45 degrees" and 45 or 0)
	end
	dropdown:SetText(GAMEMODE.PropRotationSnap == 15 and "15 degrees"
		or GAMEMODE.PropRotationSnap == 30 and "30 degrees"
		or GAMEMODE.PropRotationSnap == 45 and "45 degrees"
		or "No snap")
	dropdown:SetTextColor(color_black)
	self.list:AddItem(dropdown)

	-- self.list:AddItem(EasyLabel(self, "Human ambient beat set", "DefaultFontSmall", color_white))
	-- dropdown = vgui.Create("DComboBox", self)
	-- dropdown:SetMouseInputEnabled(true)
	-- for setname in pairs(GAMEMODE.Beats) do
	-- 	if setname ~= GAMEMODE.BeatSetHumanDefualt then
	-- 		dropdown:AddChoice(setname)
	-- 	end
	-- end
	-- dropdown:AddChoice("none")
	-- dropdown:AddChoice("default")
	-- dropdown.OnSelect = function(me, index, value, data)
	-- 	RunConsoleCommand("zs_beatset_human", value)
	-- end
	-- dropdown:SetText(GAMEMODE.BeatSetHuman == GAMEMODE.BeatSetHumanDefault and "default" or GAMEMODE.BeatSetHuman)
	-- dropdown:SetTextColor(color_black)
	-- self.list:AddItem(dropdown)

	-- self.list:AddItem(EasyLabel(self, "Zombie ambient beat set", "DefaultFontSmall", color_white))
	-- dropdown = vgui.Create("DComboBox", self)
	-- dropdown:SetMouseInputEnabled(true)
	-- for setname in pairs(GAMEMODE.Beats) do
	-- 	if setname ~= GAMEMODE.BeatSetZombieDefualt then
	-- 		dropdown:AddChoice(setname)
	-- 	end
	-- end
	-- dropdown:AddChoice("none")
	-- dropdown:AddChoice("default")
	-- dropdown.OnSelect = function(me, index, value, data)
	-- 	RunConsoleCommand("zs_beatset_zombie", value)
	-- end
	-- dropdown:SetText(GAMEMODE.BeatSetZombie == GAMEMODE.BeatSetZombieDefault and "default" or GAMEMODE.BeatSetZombie)
	-- dropdown:SetTextColor(color_black)
	-- self.list:AddItem(dropdown)

	local slider = vgui.Create("DNumSlider", self)
	slider:SetDecimals(0)
	slider:SetMinMax(2, 8)
	slider:SetConVar("zs_crosshairlines")
	slider:SetText("Crosshair lines")
	slider:SizeToContents()
	self.list:AddItem(slider)

	slider = vgui.Create("DNumSlider", self)
	slider:SetDecimals(0)
	slider:SetMinMax(0, 90)
	slider:SetConVar("zs_crosshairoffset")
	slider:SetText("Crosshair offset")
	slider:SizeToContents()
	self.list:AddItem(slider)

	slider = vgui.Create("DNumSlider", self)
	slider:SetDecimals(1)
	slider:SetMinMax(0.5, 2)
	slider:SetConVar("zs_crosshairthickness")
	slider:SetText("Crosshair thickness")
	slider:SizeToContents()
	self.list:AddItem(slider)

	slider = vgui.Create("DNumSlider", self)
	slider:SetDecimals(1)
	slider:SetMinMax(0.5, 2)
	slider:SetConVar("zs_dmgnumberscale")
	slider:SetText("Damage number size")
	slider:SizeToContents()
	self.list:AddItem(slider)

	slider = vgui.Create("DNumSlider", self)
	slider:SetDecimals(1)
	slider:SetMinMax(0, 1)
	slider:SetConVar("zs_dmgnumberspeed")
	slider:SetText("Damage number speed")
	slider:SizeToContents()
	self.list:AddItem(slider)

	slider = vgui.Create("DNumSlider", self)
	slider:SetDecimals(1)
	slider:SetMinMax(0.2, 1.5)
	slider:SetConVar("zs_dmgnumberlife")
	slider:SetText("Damage number lifetime")
	slider:SizeToContents()
	self.list:AddItem(slider)

	slider = vgui.Create("DNumSlider", self)
	slider:SetDecimals(1)
	slider:SetMinMax(0, 255)
	slider:SetConVar("zs_filmgrainopacity")
	slider:SetText("Film grain")
	slider:SizeToContents()
	self.list:AddItem(slider)

	slider = vgui.Create("DNumSlider", self)
	slider:SetDecimals(1)
	slider:SetMinMax(0.7, 1.6)
	slider:SetConVar("zs_interfacesize")
	slider:SetText("Interface/HUD scale")
	slider:SizeToContents()
	self.list:AddItem(slider)

	slider = vgui.Create("DNumSlider", self)
	slider:SetDecimals(2)
	slider:SetMinMax(0, 1)
	slider:SetConVar("zs_ironsightzoom")
	slider:SetText("Ironsight zoom scale")
	slider:SizeToContents()
	self.list:AddItem(slider)

	-- slider = vgui.Create("DNumSlider", self)
	-- slider:SetDecimals(0)
	-- slider:SetMinMax(0, 100)
	-- slider:SetConVar("zs_beatsvolume")
	-- slider:SetText("Music volume")
	-- slider:SizeToContents()
	-- self.list:AddItem(slider)

	slider = vgui.Create("DNumSlider", self)
	slider:SetDecimals(1)
	slider:SetMinMax(0.1, 4)
	slider:SetConVar("zs_proprotationsens")
	slider:SetText("Prop rotation sensitivity")
	slider:SizeToContents()
	self.list:AddItem(slider)

	slider = vgui.Create("DNumSlider", self)
	slider:SetDecimals(0)
	slider:SetMinMax(0, GAMEMODE.TransparencyRadiusMax)
	slider:SetConVar("zs_transparencyradius")
	slider:SetText("Transparency radius")
	slider:SizeToContents()
	self.list:AddItem(slider)

	slider = vgui.Create("DNumSlider", self)
	slider:SetDecimals(0)
	slider:SetMinMax(0, GAMEMODE.TransparencyRadiusMax)
	slider:SetConVar("zs_transparencyradius3p")
	slider:SetText("Transparency radius in third person")
	slider:SizeToContents()
	self.list:AddItem(slider)

	self.list:AddItem(EasyLabel(self, "Crosshair primary color"))
	local colpicker = vgui.Create("DColorMixer", self)
	colpicker:SetAlphaBar(true)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_crosshair_colr")
	colpicker:SetConVarG("zs_crosshair_colg")
	colpicker:SetConVarB("zs_crosshair_colb")
	colpicker:SetConVarA("zs_crosshair_cola")
	colpicker:SetTall(72)
	self.list:AddItem(colpicker)

	self.list:AddItem(EasyLabel(self, "Crosshair secondary color"))
	colpicker = vgui.Create("DColorMixer", self)
	colpicker:SetAlphaBar(true)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_crosshair_colr2")
	colpicker:SetConVarG("zs_crosshair_colg2")
	colpicker:SetConVarB("zs_crosshair_colb2")
	colpicker:SetConVarA("zs_crosshair_cola2")
	colpicker:SetTall(72)
	self.list:AddItem(colpicker)

	self.list:AddItem(EasyLabel(self, "Health aura color - Full health"))
	colpicker = vgui.Create("DColorMixer", self)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_auracolor_full_r")
	colpicker:SetConVarG("zs_auracolor_full_g")
	colpicker:SetConVarB("zs_auracolor_full_b")
	colpicker:SetTall(72)
	self.list:AddItem(colpicker)

	self.list:AddItem(EasyLabel(self, "Health aura color - No health"))
	colpicker = vgui.Create("DColorMixer", self)
	colpicker:SetAlphaBar(false)
	colpicker:SetPalette(false)
	colpicker:SetConVarR("zs_auracolor_empty_r")
	colpicker:SetConVarG("zs_auracolor_empty_g")
	colpicker:SetConVarB("zs_auracolor_empty_b")
	colpicker:SetTall(72)
	self.list:AddItem(colpicker)
end

vgui.Register("ZSOptions", PANEL, "DPanel")
