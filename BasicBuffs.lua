------------------------------
--      Are you local?      --
------------------------------

local display = nil

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

local function stop() end
function BasicBuffs:OnEnable()
	if display then return end

	display = CreateFrame("Frame", "BasicBuffsFrame", UIParent)
	display:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",})
	display:SetFrameStrata("BACKGROUND")
	display:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	display:SetBackdropColor(0,1,0)
	display:SetWidth(280)
	display:SetHeight(225)
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
	TemporaryEnchantFrame.SetPoint = stop
end

function BasicBuffs:SavePosition()
	if not display then return end

	local s = display:GetEffectiveScale()
	db.x = display:GetLeft() * s
	db.y = display:GetTop() * s
end

function BasicBuffs:Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cFF33FF99BasicBuffs|r: " .. msg)
end

------------------------------
--     Slash Commands       --
------------------------------

local function slashCMD(msg)
	if string.lower(msg) == "lock" then
		if not db.lock then
			display:SetBackdropColor(0,1,0,0)
			display:EnableMouse(false)
			display:SetMovable(false)
			db.lock = true
			BasicBuffs:Print("Locked")
		else
			display:SetBackdropColor(0,1,0,1)
			display:EnableMouse(true)
			display:SetMovable(true)
			db.lock = nil
			BasicBuffs:Print("Unlocked")
		end
	elseif msg == "" then
		BasicBuffs:Print("Commands:")
		BasicBuffs:Print("/bb lock")
	end
end

_G["SlashCmdList"]["BASICBUFFS"] = slashCMD
_G["SLASH_BASICBUFFS1"] = "/bb"
_G["SLASH_BASICBUFFS2"] = "/basicbuffs"
