
local f = CreateFrame("Frame", "BasicBuffsFrame", UIParent)

local bg = f:CreateTexture()
bg:SetAllPoints(f)
bg:SetColorTexture(0, 1, 0, 0.3)
bg:Show()

local SetPoint = f.SetPoint
local ClearAllPoints = f.ClearAllPoints
ClearAllPoints(BuffFrame)
SetPoint(BuffFrame, "TOPRIGHT", f, "TOPRIGHT")
hooksecurefunc(BuffFrame, "SetPoint", function(frame)
	ClearAllPoints(frame)
	SetPoint(frame, "TOPRIGHT", f, "TOPRIGHT")
end)

local header = f:CreateFontString(nil, "OVERLAY", "TextStatusBarText")
header:SetAllPoints(f)
header:SetText("BasicBuffs")
header:Show()

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
	local a, _, b, c, d = frame:GetPoint()
	BasicBuffsOptions[1] = a
	BasicBuffsOptions[2] = b
	BasicBuffsOptions[3] = c
	BasicBuffsOptions[4] = d
end)

f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(display)
	if not BasicBuffsOptions then
		BasicBuffsOptions = {"CENTER", "CENTER", 0, 0, false}
	end

	display:ClearAllPoints()
	display:SetPoint(BasicBuffsOptions[1], UIParent, BasicBuffsOptions[2], BasicBuffsOptions[3], BasicBuffsOptions[4])

	if BasicBuffsOptions[5] then
		bg:Hide()
		header:Hide()
		display:EnableMouse(false)
		display:SetMovable(false)
	end

	display:UnregisterEvent("PLAYER_LOGIN")
	display:SetScript("OnEvent", nil)
end)

SlashCmdList.BASICBUFFS = function()
	if not BasicBuffsOptions then return end

	if not BasicBuffsOptions[5] then
		bg:Hide()
		header:Hide()
		f:EnableMouse(false)
		f:SetMovable(false)
		BasicBuffsOptions[5] = true
		print("|cFF33FF99BasicBuffs|r:", _G.LOCKED)
	else
		bg:Show()
		header:Show()
		f:EnableMouse(true)
		f:SetMovable(true)
		BasicBuffsOptions[5] = false
		print("|cFF33FF99BasicBuffs|r:", _G.UNLOCK)
	end
end
SLASH_BASICBUFFS1 = "/basicbuffs"

