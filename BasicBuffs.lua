
local f = CreateFrame("Frame", "BasicBuffsFrame", UIParent)

local bg = f:CreateTexture()
bg:SetAllPoints(f)
bg:SetColorTexture(0, 1, 0, 0.3)

local setBuff = BuffFrame.SetPoint
BuffFrame:ClearAllPoints()
setBuff(BuffFrame, "TOPRIGHT", f, "TOPRIGHT")
hooksecurefunc(BuffFrame, "SetPoint", function(frame)
	frame:ClearAllPoints()
	setBuff(frame, "TOPRIGHT", f, "TOPRIGHT")
end)

f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
f:SetWidth(280)
f:SetHeight(225)
f:Show()
f:EnableMouse(true)
f:RegisterForDrag("LeftButton")
f:SetMovable(true)
f:SetScript("OnDragStart", function(frame) frame:StartMoving() end)
f:SetScript("OnDragStop", function(frame)
	frame:StopMovingOrSizing()
	local s = frame:GetEffectiveScale()
	BasicBuffsStorage.x = frame:GetLeft() * s
	BasicBuffsStorage.y = frame:GetTop() * s
end)

f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(display)
	if not BasicBuffsStorage then
		BasicBuffsStorage = {}
	end

	if BasicBuffsStorage.x and BasicBuffsStorage.y then
		local s = display:GetEffectiveScale()
		display:ClearAllPoints()
		display:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", BasicBuffsStorage.x / s, BasicBuffsStorage.y / s)
	end

	if BasicBuffsStorage.lock then
		bg:Hide()
		display:EnableMouse(false)
		display:SetMovable(false)
	end

	display:UnregisterEvent("PLAYER_LOGIN")
	display:SetScript("OnEvent", nil)
end)

SlashCmdList.BASICBUFFS = function()
	if not BasicBuffsStorage then return end

	if not BasicBuffsStorage.lock then
		bg:Hide()
		f:EnableMouse(false)
		f:SetMovable(false)
		BasicBuffsStorage.lock = true
		print("|cFF33FF99BasicBuffs|r:", _G.LOCKED)
	else
		bg:Show()
		f:EnableMouse(true)
		f:SetMovable(true)
		BasicBuffsStorage.lock = nil
		print("|cFF33FF99BasicBuffs|r:", _G.UNLOCK)
	end
end
SLASH_BASICBUFFS1 = "/basicbuffs"

