
local f = CreateFrame("Frame")

f:RegisterEvent("LOADING_SCREEN_DISABLED")
f:SetScript("OnEvent", function(frame, event)
	frame:UnregisterEvent(event)
	frame:SetScript("OnEvent", nil)

	print("|cFF33FF99BasicBuffs|r:", "This addon is no longer needed on Retail WoW, use 'Edit Mode' instead.")
end)
