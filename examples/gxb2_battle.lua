-- require("preload")

-- local teams = require("teams")

-- local M = 5
-- local N = #teams
-- local SEEDS = get_seeds(M)
-- local win_rates = "attacker,defender,win_rate\n"
-- local log = "M = " .. M .. "\n\n"

-- for i = 1, N do
--     for j = 1, N do
--         if i ~= j then
--             print(repeat_char("=", 30))
--             local msg = teams[i].name .. " vs " .. teams[j].name
--             local PARAMS = PvP_params(teams[i], teams[j])
--             local report = fight(PARAMS, SEEDS, true, msg)
--             win_rates = win_rates .. teams[i].id .. "," .. teams[j].id .. ","
--             win_rates = win_rates .. report.wins .. "\n"
--             log = log .. msg .. "\n" .. get_report(report)
--             print(repeat_char("=", 30) .. "\n")
--         end
--     end
--     save(win_rates, date .. "[win_rates].csv")
--     save(log, date .. "[log].log")
--     win_rates = ""
--     log = ""
-- end
