------------------------------
--      Are you local?      --
------------------------------

local display = nil
local _G = _G

local db
local defaults = {
	profile = {
		x = nil,
		y = nil,
		lock = nil,
	}
}

local BasicBuffs = LibStub("AceAddon-3.0"):NewAddon("BasicBuffs")

------------------------------
--      Initialization      --
------------------------------

function BasicBuffs:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("BasicBuffsDB", defaults)
	db = self.db.profile
end

------------------------------
--       Frame Setup        --
------------------------------

function BasicBuffs:OnEnable()
	if display then return end

	display = CreateFrame("Frame", "BasicBuffsFrame", UIParent)
	display:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",})
	display:SetFrameStrata("BACKGROUND")
	display:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	display:SetBackdropColor(0,1,0)
	display:SetWidth(500)
	display:SetHeight(100)
	display:Show()
	display:EnableMouse(true)
	display:RegisterForDrag("LeftButton")
	display:SetMovable(true)
	display:SetScript("OnDragStart", function() this:StartMoving() end)
	display:SetScript("OnDragStop", function()
		this:StopMovingOrSizing()
		self:SavePosition()
	end)

	local x = db.x
	local y = db.y
	if x and y then
		local s = display:GetEffectiveScale()
		display:ClearAllPoints()
		display:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	end

	if db.lock then
		display:SetBackdropColor(0,1,0,0)
		display:EnableMouse(false)
		display:SetMovable(false)
	end

	TemporaryEnchantFrame:ClearAllPoints()
	TemporaryEnchantFrame:SetPoint("TOPRIGHT", display, "TOPRIGHT")
	TemporaryEnchantFrame.SetPoint = function() end
end

function BasicBuffs:SavePosition()
	if not display then return end

	local s = display:GetEffectiveScale()
	db.x = display:GetLeft() * s
	db.y = display:GetTop() * s
end

------------------------------
--     Slash Commands       --
------------------------------

_G["SlashCmdList"]["BASICBUFFS"] = function(msg)
	if string.lower(msg) == "lock" then
		if not db.lock then
			display:SetBackdropColor(0,1,0,0)
			display:EnableMouse(false)
			display:SetMovable(false)
			db.lock = true
			ChatFrame1:AddMessage("BasicBuffs: Locked")
		else
			display:SetBackdropColor(0,1,0,1)
			display:EnableMouse(true)
			display:SetMovable(true)
			db.lock = nil
			ChatFrame1:AddMessage("BasicBuffs: Unlocked")
		end
	elseif msg == "" then
		ChatFrame1:AddMessage("BasicBuffs: Commands:")
		ChatFrame1:AddMessage("/bb lock")
	end
end
_G["SLASH_BASICBUFFS1"] = "/bb"

