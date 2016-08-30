
local f = CreateFrame("Frame", "BasicBuffsFrame", UIParent)
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(display)
	if not BasicBuffsStorage then
		BasicBuffsStorage = {}
	end

	display:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
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
	local bg = display:CreateTexture()
	bg:SetAllPoints(display)
	bg:SetColorTexture(0, 1, 0, 0.3)

	if BasicBuffsStorage.x and BasicBuffsStorage.y then
		local s = display:GetEffectiveScale()
		display:ClearAllPoints()
		display:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", BasicBuffsStorage.x / s, BasicBuffsStorage.y / s)
	end

	if BasicBuffsStorage.lock then
		bg:Hide()
		display:EnableMouse(false)
		display:SetMovable(false)
	end

	local setBuff = BuffFrame.SetPoint
	BuffFrame:ClearAllPoints()
	setBuff(BuffFrame, "TOPRIGHT", display, "TOPRIGHT")
	hooksecurefunc(BuffFrame, "SetPoint", function(frame)
		frame:ClearAllPoints()
		setBuff(frame, "TOPRIGHT", display, "TOPRIGHT")
	end)

	SlashCmdList.BASICBUFFS = function(msg)
		if msg:lower() == "lock" then
			if not BasicBuffsStorage.lock then
				bg:Hide()
				display:EnableMouse(false)
				display:SetMovable(false)
				BasicBuffsStorage.lock = true
				print("|cFF33FF99BasicBuffs|r:", _G.LOCKED)
			else
				bg:Show()
				display:EnableMouse(true)
				display:SetMovable(true)
				BasicBuffsStorage.lock = nil
				print("|cFF33FF99BasicBuffs|r:", _G.UNLOCK)
			end
		else
			print("|cFF33FF99BasicBuffs|r: Commands:")
			print("|cFF33FF99BasicBuffs|r: /bb lock")
		end
	end
	SLASH_BASICBUFFS1 = "/bb"
	SLASH_BASICBUFFS2 = "/basicbuffs"
	display:UnregisterEvent("PLAYER_LOGIN")
	display:SetScript("OnEvent", nil)
end)

