---@type Frame
local eventFrame = CreateFrame("FRAME")

eventFrame:RegisterEvent("TAXIMAP_CLOSED")
eventFrame:RegisterEvent("PLAYER_CONTROL_LOST")
eventFrame:RegisterEvent("PLAYER_CONTROL_GAINED")

local flightStarted = 0
local muting = false
eventFrame:SetScript("OnEvent", function(_, event, ...)
    if event == "TAXIMAP_CLOSED" then
        flightStarted = GetTimePreciseSec()
    end
    if event == "PLAYER_CONTROL_LOST" then
        if not C_Map.GetPlayerMapPosition(1550, "player") then
            return
        end
        if GetTimePreciseSec() - flightStarted < 1 then
            muting = true
            C_Timer.After(1, function()
                SetCVar("Sound_EnableSFX", false)
                OpenWorldMap(1550)
                WorldMapFrame:HandleUserActionMaximizeSelf()
            end)
        end
    end
    if event == "PLAYER_CONTROL_GAINED" then
        if muting then
            WorldMapFrame:HandleUserActionMinimizeSelf()
            C_Timer.After(0.1, function()
                WorldMapFrameCloseButton:GetScript("OnClick")(WorldMapFrameCloseButton)
            end)
            SetCVar("Sound_EnableSFX", true)
            muting = false
        end
    end
end)