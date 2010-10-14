
local f = CreateFrame("Frame", "BasicBuffsFrame", UIParent)
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(display)
	if type(BasicBuffsStorage) ~= "table" then
		BasicBuffsStorage = {}
	end

	display:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
	display:SetFrameStrata("BACKGROUND")
	display:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	display:SetBackdropColor(0,1,0)
	display:SetWidth(280)
	display:SetHeight(225)
	display:Show()
	display:EnableMouse(true)
	display:RegisterForDrag("LeftButton")
	display:SetMovable(true)
	display:SetScript("OnDragStart", function(frame) frame:StartMoving() end)
	display:SetScript("OnDragStop", function(frame)
		frame:StopMovingOrSizing()
		local s = frame:GetEffectiveScale()
		BasicBuffsStorage.x = frame:GetLeft() * s
		BasicBuffsStorage.y = frame:GetTop() * s
	end)

	if BasicBuffsStorage.x and BasicBuffsStorage.y then
		local s = display:GetEffectiveScale()
		display:ClearAllPoints()
		display:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", BasicBuffsStorage.x / s, BasicBuffsStorage.y / s)
	end

	if BasicBuffsStorage.lock then
		display:SetBackdropColor(0,1,0,0)
		display:EnableMouse(false)
		display:SetMovable(false)
	end

	BuffFrame:ClearAllPoints()
	BuffFrame:SetPoint("TOPRIGHT", display, "TOPRIGHT")
	BuffFrame.SetPoint = function() end

	_G["SlashCmdList"]["BASICBUFFS"] = function(msg)
		if string.lower(msg) == "lock" then
			if not BasicBuffsStorage.lock then
				BasicBuffsFrame:SetBackdropColor(0,1,0,0)
				BasicBuffsFrame:EnableMouse(false)
				BasicBuffsFrame:SetMovable(false)
				BasicBuffsStorage.lock = true
				print("|cFF33FF99BasicBuffs|r: ", "Locked")
			else
				BasicBuffsFrame:SetBackdropColor(0,1,0,1)
				BasicBuffsFrame:EnableMouse(true)
				BasicBuffsFrame:SetMovable(true)
				BasicBuffsStorage.lock = nil
				print("|cFF33FF99BasicBuffs|r: ", "Unlocked")
			end
		elseif msg == "" then
			print("|cFF33FF99BasicBuffs|r: ", "Commands:")
			print("|cFF33FF99BasicBuffs|r: ", "/bb lock")
		end
	end
	_G["SLASH_BASICBUFFS1"] = "/bb"
	_G["SLASH_BASICBUFFS2"] = "/basicbuffs"
	display:UnregisterEvent("PLAYER_LOGIN")
	display:SetScript("OnEvent", nil)
end)

