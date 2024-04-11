--########### armor and Debuff Frame
--########### By Atreyyo @ Vanillagaming.org

libdebuff = nil

aDF = CreateFrame('Button', "aDF", UIParent); -- Event Frame
aDF.Options = CreateFrame("Frame",nil,UIParent) -- Options frame

--register events 
aDF:RegisterEvent("ADDON_LOADED")
aDF:RegisterEvent("UNIT_AURA")
aDF:RegisterEvent("PLAYER_TARGET_CHANGED")

-- tables 
aDF_frames = {} -- we will put all debuff frames in here
aDF_guiframes = {} -- we wil put all gui frames here
gui_Options = gui_Options or {} -- checklist options
gui_Optionsxy = gui_Optionsxy or 1
gui_chantbl = {
   "Say",
   "Yell",
   "Party",
   "Raid",
   "Raid_Warning"
 }

local last_target_change_time = GetTime()
local last_debuffs = {}

-- translation table for debuff check on target

aDFSpells = {
	["Sunder Armor"] = "Sunder Armor",
	["Armor Shatter"] = "Armor Shatter",
	["Faerie Fire"] = "Faerie Fire",
	["Nightfall"] = "Spell Vulnerability",
	["Flame Buffet"] = "Flame Buffet",
	["Scorch"] = "Fire Vulnerability",
	["Ignite"] = "Ignite",
	["Curse of Recklessness"] = "Curse of Recklessness",
	["Curse of the Elements"] = "Curse of the Elements",
	["Curse of Shadows"] = "Curse of Shadow",
	["Shadow Bolt"] = "Shadow Vulnerability",
	["Shadow Weaving"] = "Shadow Weaving",
	["Expose Armor"] = "Expose Armor",
}
	--["Vampiric Embrace"] = "Vampiric Embrace",
	--["Crystal Yield"] = "Crystal Yield",
	--["Mage T3 6/9 Bonus"] = "Elemental Vulnerability",
-- table with names and textures 

aDFDebuffs = {
	["Sunder Armor"] = "Interface\\Icons\\Ability_Warrior_Sunder",
	["Armor Shatter"] = "Interface\\Icons\\INV_Axe_12",
	["Faerie Fire"] = "Interface\\Icons\\Spell_Nature_FaerieFire",
	["Nightfall"] = "Interface\\Icons\\Spell_Holy_ElunesGrace",
	["Flame Buffet"] = "Interface\\Icons\\Spell_Fire_Fireball",
	["Scorch"] = "Interface\\Icons\\Spell_Fire_SoulBurn",
	["Ignite"] = "Interface\\Icons\\Spell_Fire_Incinerate",
	["Curse of Recklessness"] = "Interface\\Icons\\Spell_Shadow_UnholyStrength",
	["Curse of the Elements"] = "Interface\\Icons\\Spell_Shadow_ChillTouch",
	["Curse of Shadows"] = "Interface\\Icons\\Spell_Shadow_CurseOfAchimonde",
	["Shadow Bolt"] = "Interface\\Icons\\Spell_Shadow_ShadowBolt",
	["Shadow Weaving"] = "Interface\\Icons\\Spell_Shadow_BlackPlague",
	["Expose Armor"] = "Interface\\Icons\\Ability_Warrior_Riposte",
}
	--["Vampiric Embrace"] = "Interface\\Icons\\Spell_Shadow_UnsummonBuilding",
	--["Crystal Yield"] = "Interface\\Icons\\INV_Misc_Gem_Amethyst_01",
	--["Elemental Vulnerability"] = "Interface\\Icons\\Spell_Holy_Dizzy",

for k,v in pairs(aDFDebuffs) do
	last_debuffs[k] = 0
end


aDFArmorVals = {}



local armor_candidates = {

    {80, "Untalented Expose Armor r1c1"},
    {100, "Improved Expose Armor r1c1t1"},
    {120, "Improved Expose Armor r1c1t2"},
    {160, "Untalented Expose Armor r1c2"},
    {200, "Improved Expose Armor r1c2t1"},
    {240, "Improved Expose Armor r1c2t2"},
    {240, "Untalented Expose Armor r1c3"},
    {300, "Improved Expose Armor r1c3t1"},
    {360, "Improved Expose Armor r1c3t2"},
    {320, "Untalented Expose Armor r1c4"},
    {400, "Improved Expose Armor r1c4t1"},
    {480, "Improved Expose Armor r1c4t2"},
    {400, "Untalented Expose Armor r1c5"},
    {500, "Improved Expose Armor r1c5t1"},
    {600, "Improved Expose Armor r1c5t2"},
    {145, "Untalented Expose Armor r2c1"},
    {182, "Improved Expose Armor r2c1t1"},
    {181, "Improved Exposed Armor r2c1t1"},
    {218, "Improved Expose Armor r2c1t2"},
    {217, "Improved Exposed Armor r2c1t2"},
    {290, "Untalented Expose Armor r2c2"},
    {363, "Improved Expose Armor r2c2t1"},
    {362, "Improved Exposed Armor r2c2t1"},
    {435, "Improved Expose Armor r2c2t2"},
    {435, "Untalented Expose Armor r2c3"},
    {544, "Improved Expose Armor r2c3t1"},
    {543, "Improved Exposed Armor r2c3t1"},
    {653, "Improved Expose Armor r2c3t2"},
    {652, "Improved Exposed Armor r2c3t2"},
    {580, "Untalented Expose Armor r2c4"},
    {725, "Improved Expose Armor r2c4t1"},
    {870, "Improved Expose Armor r2c4t2"},
    {725, "Untalented Expose Armor r2c5"},
    {907, "Improved Expose Armor r2c5t1"},
    {906, "Improved Exposed Armor r2c5t1"},
    {1088, "Improved Expose Armor r2c5t2"},
    {1087, "Improved Exposed Armor r2c5t2"},
    {210, "Untalented Expose Armor r3c1"},
    {263, "Improved Expose Armor r3c1t1"},
    {262, "Improved Exposed Armor r3c1t1"},
    {315, "Improved Expose Armor r3c1t2"},
    {420, "Untalented Expose Armor r3c2"},
    {525, "Improved Expose Armor r3c2t1"},
    {630, "Improved Expose Armor r3c2t2"},
    {630, "Untalented Expose Armor r3c3"},
    {788, "Improved Expose Armor r3c3t1"},
    {787, "Improved Exposed Armor r3c3t1"},
    {945, "Improved Expose Armor r3c3t2"},
    {840, "Untalented Expose Armor r3c4"},
    {1050, "Improved Expose Armor r3c4t1"},
    {1260, "Improved Expose Armor r3c4t2"},
    {1050, "Untalented Expose Armor r3c5"},
    {1313, "Improved Expose Armor r3c5t1"},
    {1312, "Improved Exposed Armor r3c5t1"},
    {1575, "Improved Expose Armor r3c5t2"},
    {275, "Untalented Expose Armor r4c1"},
    {344, "Improved Expose Armor r4c1t1"},
    {343, "Improved Exposed Armor r4c1t1"},
    {413, "Improved Expose Armor r4c1t2"},
    {412, "Improved Exposed Armor r4c1t2"},
    {550, "Untalented Expose Armor r4c2"},
    {688, "Improved Expose Armor r4c2t1"},
    {687, "Improved Exposed Armor r4c2t1"},
    {825, "Improved Expose Armor r4c2t2"},
    {825, "Untalented Expose Armor r4c3"},
    {1032, "Improved Expose Armor r4c3t1"},
    {1031, "Improved Exposed Armor r4c3t1"},
    {1238, "Improved Expose Armor r4c3t2"},
    {1237, "Improved Exposed Armor r4c3t2"},
    {1100, "Untalented Expose Armor r4c4"},
    {1375, "Improved Expose Armor r4c4t1"},
    {1650, "Improved Expose Armor r4c4t2"},
    {1375, "Untalented Expose Armor r4c5"},
    {1719, "Improved Expose Armor r4c5t1"},
    {1718, "Improved Exposed Armor r4c5t1"},
    {2063, "Improved Expose Armor r4c5t2"},
    {2062, "Improved Exposed Armor r4c5t2"},
    {340, "Untalented Expose Armor r5c1"},
    {425, "Improved Expose Armor r5c1t1"},
    {510, "Improved Expose Armor r5c1t2"},
    {680, "Untalented Expose Armor r5c2"},
    {850, "Improved Expose Armor r5c2t1"},
    {1020, "Improved Expose Armor r5c2t2"},
    {1020, "Untalented Expose Armor r5c3"},
    {1275, "Improved Expose Armor r5c3t1"},
    {1530, "Improved Expose Armor r5c3t2"},
    {1360, "Untalented Expose Armor r5c4"},
    {1700, "Improved Expose Armor r5c4t1"},
    {2040, "Improved Expose Armor r5c4t2"},
    {1700, "Untalented Expose Armor"}, -- r5c5
    {2125, "Improved Expose Armor r5c5t1"},
    {2550, "Improved Expose Armor"}, -- r5c5t2


    {90, "Sunder Armor x1"}, -- r1 x1
    {180, "Sunder Armor"},    -- r2 x1, or r1 x2
    {270,   "Sunder Armor"},    -- r3 x1, or r1 x3
	{540,   "Sunder Armor"},    -- r3 x2, or r2 x3
	{810,   "Sunder Armor x3"}, -- r3 x3
	{360,   "Sunder Armor"},    -- r4 x1, or r1 x4 or r2 x2
	{720,   "Sunder Armor"},    -- r4 x2, or r2 x4
	{1080,  "Sunder Armor"},    -- r4 x3, or r3 x4
	{1440,  "Sunder Armor x4"}, -- r4 x4
	{450,   "Sunder Armor"},    -- r5 x1, or r1 x5
	{900,   "Sunder Armor"},    -- r5 x2, or r2 x5
	{1350,  "Sunder Armor"},    -- r5 x3, or r3 x5
	{1800,  "Sunder Armor"},    -- r5 x4, or r4 x5
	{2250,  "Sunder Armor x5"}, -- r5 x5



	{505,   "Faerie Fire"},
	{395,   "Faerie Fire R3"},
	{285,   "Faerie Fire R2"},
	{175,   "Faerie Fire R1"},

	{640,   "Curse of Recklessness"},
	{465,   "Curse of Recklessness R3"},
	{290,   "Curse of Recklessness R2"},
	{140,   "Curse of Recklessness R1"},
	{600,   "Annihilator x3"}, -- or rivenspike
	{400,   "Annihilator x2"}, -- or rivenspike
	{200,   "Annihilator x1"}, -- or rivenspike
	{50,   "Torch of Holy Flame"},
}

for _, tpl in ipairs(armor_candidates) do
    local armor = tpl[1]
    local announcement = tpl[2]

    --[[
    -- prints everything in a tie, but some are too unlikely to be useful
    if aDFArmorVals[armor] == nil then
        aDFArmorVals[armor] = announcement
    else
        aDFArmorVals[armor] = aDFArmorVals[armor] .. '/' .. announcement
    end
    ]]

    -- assume the candidates are ordered from least to most likely, so last one wins ties
    aDFArmorVals[armor] = announcement
end

aDFAttackpowerVals = {
	[145]   = "Demo Shout", -- Tthe game reduces ap by an amount slightly different from what it should, I don't know why.
	[146]   = "Demo Shout", 
	[147]   = "Demo Shout",
	[203]  = "Improved Demo Shout",
	[204]  = "Improved Demo Shout",
	[205]  = "Improved Demo Shout",
	[137]  = "Demo Roar",
	[138]  = "Demo Roar",
	[139]  = "Demo Roar",
	[192]  = "Improved Demo Roar",
	[193]  = "Improved Demo Roar",
	[194]  = "Improved Demo Roar",
}

function aDF_Default()
	if guiOptions == nil then
		guiOptions = {}
		for k,v in pairs(aDFDebuffs) do
			if guiOptions[k] == nil then
				guiOptions[k] = 1
			end
		end
	end
end

-- the main frame

function aDF:Init()
	aDF.Drag = { }
	function aDF.Drag:StartMoving()
		if ( IsShiftKeyDown() ) then
			this:StartMoving()
		end
	end
	
	function aDF.Drag:StopMovingOrSizing()
		this:StopMovingOrSizing()
		local x, y = this:GetCenter()
		local ux, uy = UIParent:GetCenter()
		aDF_x, aDF_y = floor(x - ux + 0.5), floor(y - uy + 0.5)
	end
	
	local backdrop = {
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			tile="false",
			tileSize="8",
			edgeSize="8",
			insets={
				left="2",
				right="2",
				top="2",
				bottom="2"
			}
	}
	
	self:SetFrameStrata("BACKGROUND")
	self:SetWidth((24+gui_Optionsxy)*7) -- Set these to whatever height/width is needed 
	self:SetHeight(24+gui_Optionsxy) -- for your Texture
	self:SetPoint("CENTER",aDF_x,aDF_y)
	self:SetMovable(1)
	self:EnableMouse(1)
	self:RegisterForDrag("LeftButton")
	self:SetBackdrop(backdrop) --border around the frame
	self:SetBackdropColor(0,0,0,1)
	self:SetScript("OnDragStart", aDF.Drag.StartMoving)
	self:SetScript("OnDragStop", aDF.Drag.StopMovingOrSizing)
	self:SetScript("OnMouseDown", function()
		if (arg1 == "RightButton") then
			if aDF_target ~= nil then
				if UnitAffectingCombat(aDF_target) and UnitCanAttack("player", aDF_target) then	
					SendChatMessage(UnitName(aDF_target).." has ".. UnitResistance(aDF_target,0).." armor", gui_chan) 
				end
			end
		end
	end)
	
	-- Armor text
	self.armor = self:CreateFontString(nil, "OVERLAY")
    self.armor:SetPoint("CENTER", self, "CENTER", 0, 0)
    self.armor:SetFont("Fonts\\FRIZQT__.TTF", 24+gui_Optionsxy)
	self.armor:SetShadowOffset(2,-2)
    self.armor:SetText("aDF")

	-- Resistance text
	self.res = self:CreateFontString(nil, "OVERLAY")
    self.res:SetPoint("CENTER", self, "CENTER", 0, 20+gui_Optionsxy)
    self.res:SetFont("Fonts\\FRIZQT__.TTF", 14+gui_Optionsxy)
	self.res:SetShadowOffset(2,-2)
    self.res:SetText("Resistance")
	
	-- for the debuff check function
	aDF_tooltip = CreateFrame("GAMETOOLTIP", "buffScan")
	aDF_tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	aDF_tooltipTextL = aDF_tooltip:CreateFontString()
	aDF_tooltipTextR = aDF_tooltip:CreateFontString()
	aDF_tooltip:AddFontStrings(aDF_tooltipTextL,aDF_tooltipTextR)
	--R = tip:CreateFontString()
	--
	
	f_ =  0
	for name,texture in pairs(aDFDebuffs) do
		aDFsize = 24+gui_Optionsxy
		aDF_frames[name] = aDF_frames[name] or aDF.Create_frame(name)
		local frame = aDF_frames[name]
		frame:SetWidth(aDFsize)
		frame:SetHeight(aDFsize)
		frame:SetPoint("BOTTOMLEFT",aDFsize*f_,-aDFsize)
		frame.icon:SetTexture(texture)
		frame:SetFrameLevel(2)
		frame:Show()
		frame:SetScript("OnEnter", function() 
			GameTooltip:SetOwner(frame, "ANCHOR_BOTTOMRIGHT");
			GameTooltip:SetText(this:GetName(), 255, 255, 0, 1, 1);
			GameTooltip:Show()
			end)
		frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
		frame:SetScript("OnMouseDown", function()
			if (arg1 == "RightButton") then
				tdb=this:GetName()
				if aDF_target ~= nil then
					if UnitAffectingCombat(aDF_target) and UnitCanAttack("player", aDF_target) and guiOptions[tdb] ~= nil then
						if not aDF:GetDebuff(aDF_target,aDFSpells[tdb]) then
							SendChatMessage("["..tdb.."] is not active on "..UnitName(aDF_target), gui_chan)
						else
							if aDF:GetDebuff(aDF_target,aDFSpells[tdb],1) == 1 then
								s_ = "stack"
							elseif aDF:GetDebuff(aDF_target,aDFSpells[tdb],1) > 1 then
								s_ = "stacks"
							end
							if aDF:GetDebuff(aDF_target,aDFSpells[tdb],1) >= 1 and aDF:GetDebuff(aDF_target,aDFSpells[tdb],1) < 5 and tdb ~= "Armor Shatter" then
								SendChatMessage(UnitName(aDF_target).." has "..aDF:GetDebuff(aDF_target,aDFSpells[tdb],1).." ["..tdb.."] "..s_, gui_chan)
							end
							if tdb == "Armor Shatter" and aDF:GetDebuff(aDF_target,aDFSpells[tdb],1) >= 1 and aDF:GetDebuff(aDF_target,aDFSpells[tdb],1) < 3 then
								SendChatMessage(UnitName(aDF_target).." has "..aDF:GetDebuff(aDF_target,aDFSpells[tdb],1).." ["..tdb.."] "..s_, gui_chan)
							end
						end
					end
				end
			end
		end)
		f_ = f_+1
	end
end

-- creates the debuff frames on load

function aDF.Create_frame(name)
	local frame = CreateFrame('Button', name, aDF)
	frame:SetBackdrop({ bgFile=[[Interface/Tooltips/UI-Tooltip-Background]] })
	frame:SetBackdropColor(0,0,0,1)
	frame.icon = frame:CreateTexture(nil, 'ARTWORK')
	frame.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	frame.icon:SetPoint('TOPLEFT', 1, -1)
	frame.icon:SetPoint('BOTTOMRIGHT', -1, 1)
	frame.nr = frame:CreateFontString(nil, "OVERLAY")
	frame.nr:SetPoint("CENTER", frame, "CENTER", 0, 0)
	frame.nr:SetFont("Fonts\\FRIZQT__.TTF", 16+gui_Optionsxy)
	frame.nr:SetTextColor(255, 255, 0, 1)
	frame.nr:SetShadowOffset(2,-2)
	frame.nr:SetText("1")
	--DEFAULT_CHAT_FRAME:AddMessage("----- Adding new frame")
	return frame
end

-- creates gui checkboxes

function aDF.Create_guiframe(name)
	local frame = CreateFrame("CheckButton", name, aDF.Options, "UICheckButtonTemplate")
	frame:SetFrameStrata("LOW")
	frame:SetScript("OnClick", function () 
		if frame:GetChecked() == nil then 
			guiOptions[name] = nil
		elseif frame:GetChecked() == 1 then 
			guiOptions[name] = 1 
			table.sort(guiOptions)
		end
		aDF:Sort()
		aDF:Update()
		end)
	frame:SetScript("OnEnter", function() 
		GameTooltip:SetOwner(frame, "ANCHOR_RIGHT");
		GameTooltip:SetText(name, 255, 255, 0, 1, 1);
		GameTooltip:Show()
	end)
	frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
	frame:SetChecked(guiOptions[name])
	frame.Icon = frame:CreateTexture(nil, 'ARTWORK')
	frame.Icon:SetTexture(aDFDebuffs[name])
	frame.Icon:SetWidth(25)
	frame.Icon:SetHeight(25)
	frame.Icon:SetPoint("CENTER",-30,0)
	--DEFAULT_CHAT_FRAME:AddMessage("----- Adding new gui checkbox")
	return frame
end

-- update function for the text/debuff frames

function aDF:Update()
	if aDF_target ~= nil and UnitExists(aDF_target) and not UnitIsDead(aDF_target) then
		if aDF_target == 'targettarget' and GetTime() < (last_target_change_time + 1.3) then
			-- we won't allow updates for a while to allow targettarget to catch up
			-- adfprint('target changed too soon, delaying update')
			return
		end

        local apbase, apbuff, apdebuff = UnitAttackPower(aDF_target);
		local apcurr = apbase + apbuff + apdebuff;
		local armorcurr = UnitResistance(aDF_target,0)
--		aDF.armor:SetText(UnitResistance(aDF_target,0).." ["..math.floor(((UnitResistance(aDF_target,0) / (467.5 * UnitLevel("player") + UnitResistance(aDF_target,0) - 22167.5)) * 100),1).."%]")
		local mainSpeed, offSpeed = UnitAttackSpeed(aDF_target)
        mainSpeed = round(mainSpeed, 1)
        --offSpeed = round(offSpeed, 1)
		aDF.armor:SetText(armorcurr .. '-' .. tostring(mainSpeed) .. '-' .. tostring(apcurr))
		-- adfprint(string.format('aDF_target %s targetname %s armorcurr %s armorprev %s', aDF_target, UnitName(aDF_target), armorcurr, aDF_armorprev))
		local armormsg = ''
        local likelyreason = ""
		if armorcurr > aDF_armorprev then
			local armordiff = armorcurr - aDF_armorprev
			if aDF_armorprev ~= 0 and aDFArmorVals[armordiff] then
				likelyreason = "Likely dropped " .. aDFArmorVals[armordiff]
			end
			armormsg = "armor "..aDF_armorprev.." -> "..armorcurr.."."
			-- adfprint(armormsg)
		end
        if aDF_apprev ~= 0 and apcurr > aDF_apprev then
            local apdiff = apcurr - aDF_apprev
            local apmsg = UnitName(aDF_target) .. ' AP ' .. aDF_apprev .. ' -> ' .. apcurr .. '.'

			if aDFAttackpowerVals[apdiff] -- known debuffs
            and apdiff > 130 -- of a relevant size
            and not UnitIsPlayer(aDF_target) -- ignore players
            then
                apmsg = apmsg .. ' lost ' .. aDFAttackpowerVals[apdiff]
                SendChatMessage(apmsg, gui_chan)
            else
                -- other effects like Screech and that engineering trinket.
                adfprint(apmsg)
            end
		end
		aDF_armorprev = armorcurr
        aDF_apprev = apcurr

		if gui_Options["Resistances"] == 1 then
			aDF.res:SetText("|cffFF0000FR "..UnitResistance(aDF_target,2).." |cff00FF00NR "..UnitResistance(aDF_target,3).." |cff4AE8F5FrR "..UnitResistance(aDF_target,4).." |cff800080SR "..UnitResistance(aDF_target,5))
		else
			aDF.res:SetText("")
		end



	
		local active_debuffs = {}
		for id=1, 32 do
			local name, rank, texture, stacks, dtype, duration, timeleft = libdebuff:UnitDebuff(aDF_target, id)
			if name and texture then
				active_debuffs[name] = stacks
				--adfprint(string.format("active %s %s", name, stacks))
			end
		end


		local debuffmsg = ' '
		for i,v in pairs(guiOptions) do
			-- local stacks = aDF:GetDebuff(aDF_target,aDFSpells[i], 1)
			local stacks = active_debuffs[aDFSpells[i]] or 0
			--adfprint(string.format("spell %s stacks %s", aDFSpells[i], stacks))
			if stacks > 0 then
				aDF_frames[i]["icon"]:SetAlpha(1)
				if stacks > 1 then
					aDF_frames[i]["nr"]:SetText(stacks)
				end
			else
				aDF_frames[i]["icon"]:SetAlpha(0.3)
				aDF_frames[i]["nr"]:SetText("")
			end

			if stacks == 0 and last_debuffs[i] > 0 then
				if last_debuffs[i] > 1 then
					debuffmsg = debuffmsg .. last_debuffs[i] .. 'x ' .. i .. ' '
				else
					debuffmsg = debuffmsg .. ' ' .. i .. ' '
				end
				last_debuffs[i] = 0
			end
			if stacks > 0 then
				last_debuffs[i] = stacks
			end
		end

		if aDF_target == 'target' and armormsg ~= '' then
			-- targettarget does not trigger events when it changes. this means it's hard to tell apart units with the same name, so we don't allow notifications for it
			local announcemsg = UnitName(aDF_target).." "..armormsg
			if debuffmsg ~= ' ' then
				announcemsg = announcemsg .. ' lost ' .. debuffmsg
                SendChatMessage(announcemsg, gui_chan)
            elseif likelyreason ~= '' then
                announcemsg = announcemsg .. ' ' .. likelyreason
                SendChatMessage(announcemsg, gui_chan)
			end
		end

	else
		aDF.armor:SetText("")
		aDF.res:SetText("")
		for i,v in pairs(guiOptions) do
			aDF_frames[i]["icon"]:SetAlpha(0.3)
			aDF_frames[i]["nr"]:SetText("")
		end
	end
end

function aDF:UpdateCheck()
	if utimer == nil or (GetTime() - utimer > 0.8) and UnitIsPlayer("target") then
		utimer = GetTime()
		aDF:Update()
	end
end

-- Sort function to show/hide frames aswell as positioning them correctly

function aDF:Sort()
	for name,_ in pairs(aDFDebuffs) do
		if guiOptions[name] == nil then
			aDF_frames[name]:Hide()
		else
			aDF_frames[name]:Show()
		end
	end
	local aDFTempTable = {}
	for dbf,_ in pairs(guiOptions) do
		table.insert(aDFTempTable,dbf)
	end
	table.sort(aDFTempTable, function(a,b) return a<b end)
	for n, v in pairs(aDFTempTable) do
	--DEFAULT_CHAT_FRAME:AddMessage("Name: "..v)
		if n > 7 then
			y_=-((24+gui_Optionsxy)*2)
			x_=(n-1)-7
			aDF_frames[v]:SetPoint('BOTTOMLEFT',(24+gui_Optionsxy)*x_,y_)
		else
			y_=-(24+gui_Optionsxy)
			aDF_frames[v]:SetPoint('BOTTOMLEFT',(24+gui_Optionsxy)*(n-1),y_)
		end
	end
end

-- Options frame

function aDF.Options:Gui()

	aDF.Options.Drag = { }
	function aDF.Options.Drag:StartMoving()
		this:StartMoving()
	end
	
	function aDF.Options.Drag:StopMovingOrSizing()
		this:StopMovingOrSizing()
	end

	local backdrop = {
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			tile="false",
			tileSize="4",
			edgeSize="8",
			insets={
				left="2",
				right="2",
				top="2",
				bottom="2"
			}
	}
	
	self:SetFrameStrata("BACKGROUND")
	self:SetWidth(400) -- Set these to whatever height/width is needed 
	self:SetHeight(450) -- for your Texture
	self:SetPoint("CENTER",0,0)
	self:SetMovable(1)
	self:EnableMouse(1)
	self:RegisterForDrag("LeftButton")
	self:SetScript("OnDragStart", aDF.Options.Drag.StartMoving)
	self:SetScript("OnDragStop", aDF.Options.Drag.StopMovingOrSizing)
	self:SetBackdrop(backdrop) --border around the frame
	self:SetBackdropColor(0,0,0,1);
	
	-- Options text
	
	self.text = self:CreateFontString(nil, "OVERLAY")
    self.text:SetPoint("CENTER", self, "CENTER", 0, 180)
    self.text:SetFont("Fonts\\FRIZQT__.TTF", 25)
	self.text:SetTextColor(255, 255, 0, 1)
	self.text:SetShadowOffset(2,-2)
    self.text:SetText("Options")
	
	-- mid line
	
	self.left = self:CreateTexture(nil, "BORDER")
	self.left:SetWidth(125)
	self.left:SetHeight(2)
	self.left:SetPoint("CENTER", -62, 160)
	self.left:SetTexture(1, 1, 0, 1)
	self.left:SetGradientAlpha("Horizontal", 0, 0, 0, 0, 102, 102, 102, 0.6)

	self.right = self:CreateTexture(nil, "BORDER")
	self.right:SetWidth(125)
	self.right:SetHeight(2)
	self.right:SetPoint("CENTER", 63, 160)
	self.right:SetTexture(1, 1, 0, 1)
	self.right:SetGradientAlpha("Horizontal", 255, 255, 0, 0.6, 0, 0, 0, 0)
	
	-- slider

	self.Slider = CreateFrame("Slider", "aDF Slider", self, 'OptionsSliderTemplate')
	self.Slider:SetWidth(200)
	self.Slider:SetHeight(20)
	self.Slider:SetPoint("CENTER", self, "CENTER", 0, 140)
	self.Slider:SetMinMaxValues(1, 10)
	self.Slider:SetValue(gui_Optionsxy)
	self.Slider:SetValueStep(1)
	getglobal(self.Slider:GetName() .. 'Low'):SetText('1')
	getglobal(self.Slider:GetName() .. 'High'):SetText('10')
	--getglobal(self.Slider:GetName() .. 'Text'):SetText('Frame size')
	self.Slider:SetScript("OnValueChanged", function() 
		gui_Optionsxy = this:GetValue()
		for _, frame in pairs(aDF_frames) do
			frame:SetWidth(24+gui_Optionsxy)
			frame:SetHeight(24+gui_Optionsxy)
			frame.nr:SetFont("Fonts\\FRIZQT__.TTF", 16+gui_Optionsxy)
		end
		aDF:SetWidth((24+gui_Optionsxy)*7)
		aDF:SetHeight(24+gui_Optionsxy)
		aDF.armor:SetFont("Fonts\\FRIZQT__.TTF", 24+gui_Optionsxy)
		aDF.res:SetFont("Fonts\\FRIZQT__.TTF", 14+gui_Optionsxy)
		aDF.res:SetPoint("CENTER", aDF, "CENTER", 0, 20+gui_Optionsxy)
		aDF:Sort()
	end)
	self.Slider:Show()
	
	-- checkboxes
	

	
	local temptable = {}
	for tempn,_ in pairs(aDFDebuffs) do
		table.insert(temptable,tempn)
	end
	table.sort(temptable, function(a,b) return a<b end)
	
	local x,y=130,-80
	for _,name in pairs(temptable) do
		y=y-40
		if y < -360 then y=-120; x=x+140 end
		--DEFAULT_CHAT_FRAME:AddMessage("Name of frame: "..name.." ypos: "..y)
		aDF_guiframes[name] = aDF_guiframes[name] or aDF.Create_guiframe(name)
		local frame = aDF_guiframes[name]
		frame:SetPoint("TOPLEFT",x,y)

	end	
	
	-- drop down menu
	
	self.dropdown = CreateFrame('Button', 'chandropdown', self, 'UIDropDownMenuTemplate')
	self.dropdown:SetPoint("BOTTOM",-60,20)
	InitializeDropdown = function() 
		local info = {}
		for k,v in pairs(gui_chantbl) do
			info = {}
			info.text = v
			info.value = v
			info.func = function()
				UIDropDownMenu_SetSelectedValue(chandropdown, this.value)
				gui_chan = UIDropDownMenu_GetText(chandropdown)
			end
			info.checked = nil
			UIDropDownMenu_AddButton(info, 1)
			if gui_chan == nil then
				UIDropDownMenu_SetSelectedValue(chandropdown, "Say")
			else
				UIDropDownMenu_SetSelectedValue(chandropdown, gui_chan)
			end
		end
	end
	UIDropDownMenu_Initialize(chandropdown, InitializeDropdown)
	
	-- done button
	
	self.dbutton = CreateFrame("Button",nil,self,"UIPanelButtonTemplate")
	self.dbutton:SetPoint("BOTTOM",0,10)
	self.dbutton:SetFrameStrata("LOW")
	self.dbutton:SetWidth(79)
	self.dbutton:SetHeight(18)
	self.dbutton:SetText("Done")
	self.dbutton:SetScript("OnClick", function() PlaySound("igMainMenuOptionCheckBoxOn"); aDF:Sort(); aDF:Update(); aDF.Options:Hide() end)
	self:Hide()
end

-- function to check a unit for a certain debuff and/or number of stacks

function aDF:GetDebuff(name,buff,stacks)
	local a=1
	while UnitDebuff(name,a) do
		local debuffname, s = UnitDebuff(name,a)
		aDF_tooltip:SetOwner(UIParent, "ANCHOR_NONE");
		aDF_tooltip:ClearLines()
		aDF_tooltip:SetUnitDebuff(name,a)
		local aDFtext = aDF_tooltipTextL:GetText()
		-- adfprint(string.format("name %s stacks %s", debuffname, s))
		if string.find(aDFtext,buff) then
			if stacks == 1 then
				return s
			else
				return true
			end
		end
		a=a+1
	end
	if stacks == 1 then
		return 0
	else
		return false
	end
end

-- event function, will load the frames we need

function aDF:OnEvent()
	if event == "ADDON_LOADED" and arg1 == "aDF" then
		aDF_Default()
		aDF_target = nil
		aDF_armorprev = 30000
        aDF_apprev = 30000
		if gui_chan == nil then gui_chan = Say end
		aDF:Init() -- loads frame, see the function
		aDF.Options:Gui() -- loads options frame
		aDF:Sort() -- sorts the debuff frames and places them to eachother
		DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A aDF:|r Loaded",1,1,1)
		DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A aDF:|r type |cFFFFFF00 /adf show|r to show frame",1,1,1)
		DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A aDF:|r type |cFFFFFF00 /adf hide|r to hide frame",1,1,1)
		DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A aDF:|r type |cFFFFFF00 /adf options|r for options frame",1,1,1)

	end
	if event == "ADDON_LOADED" and arg1 == 'pfUI' then
		libdebuff = pfUI.api.libdebuff
        round = pfUI.api.round
	end

	if event == "UNIT_AURA" then
		aDF:Update()
	end
	if event == "PLAYER_TARGET_CHANGED" then
		aDF_target = nil
		last_target_change_time = GetTime()
		if UnitIsPlayer("target") then
			aDF_target = "targettarget"
		end
		if UnitCanAttack("player", "target") then
			aDF_target = "target"
		end

		aDF_armorprev = 30000
        aDF_apprev = 30000
		aDF:Update()


	end
end

-- update and onevent who will trigger the update and event functions

aDF:SetScript("OnEvent", aDF.OnEvent)
aDF:SetScript("OnUpdate", aDF.UpdateCheck)

-- slash commands

function aDF.slash(arg1,arg2,arg3)
	if arg1 == nil or arg1 == "" then
		DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A aDF:|r type |cFFFFFF00 /adf show|r to show frame",1,1,1)
		DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A aDF:|r type |cFFFFFF00 /adf hide|r to hide frame",1,1,1)
		DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A aDF:|r type |cFFFFFF00 /adf options|r for options frame",1,1,1)
		else
		if arg1 == "show" then
			aDF:Show()
		elseif arg1 == "hide" then
			aDF:Hide()
		elseif arg1 == "options" then
			aDF.Options:Show()
		else
			DEFAULT_CHAT_FRAME:AddMessage(arg1)
			DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A aDF:|r unknown command",1,0.3,0.3);
		end
	end
end

SlashCmdList['ADF_SLASH'] = aDF.slash
SLASH_ADF_SLASH1 = '/adf'
SLASH_ADF_SLASH2 = '/ADF'

-- debug

function adfprint(arg1)
	DEFAULT_CHAT_FRAME:AddMessage("|cffCC121D adf debug|r "..arg1)
end
