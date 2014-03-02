local _ENV = mkmodule('rating')
-- Will check for an unit and provide a rating from 1 to 5

-- Unit is unhappy, 5 for miserable
function unhappiness(unit)

	local happiness = unit.status.happiness

	if happiness == 0 then return 5 
	elseif happiness < 26 then return 4
	elseif happiness <  51 then return 3
	elseif happiness < 75 then return 2
	else return 1 end

end

-- Happiness, 5 for ecstatic
function happiness(unit)

	local happiness = unit.status.happiness

	if happiness > 150 then return 5 
	elseif happiness > 124 then return 4
	elseif happiness > 75 then return 3
	elseif happiness < 26 then return 2
	else return 1 end

end

return _ENV
