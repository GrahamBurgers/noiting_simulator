--[[
    Duration: Length in frames that the attack normally lasts for.
    Tempomod: For each level of tempo, every Nth frame is doubled.
    Run: Function that runs each frame during the attack.
      Percent: Percent of the attack's completion.
]]--

return {
    ["Dote"] = {
        duration = 480, tempomod = 5,
        run = function(percent)

        end
    }
}