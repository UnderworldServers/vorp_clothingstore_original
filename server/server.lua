local VORPcore = {}
TriggerEvent("getCore", function(core)
    VORPcore = core
end)

RegisterNetEvent('vorpclothingstore:getPlayerCloths')
AddEventHandler('vorpclothingstore:getPlayerCloths', function(result)
	local _source = source
	local Character = VORPcore.getUser(_source).getUsedCharacter
	local charIdentifier = Character.charIdentifier
	
	local comps = Character.comps
	local skin = Character.skin
	
	TriggerClientEvent('vorpclothingstore:LoadYourCloths', _source, comps, skin)
	local sid = nil; for _, v in pairs(GetPlayerIdentifiers(_source)) do; if string.find(v, 'steam') then; sid = v; break; end; end
	if sid then
		exports["ghmattimysql"]:execute("SELECT * FROM outfits WHERE `identifier` = ? AND `charidentifier` = ?", { sid, charIdentifier }, function(result)
			if result then
				TriggerClientEvent('vorpclothingstore:LoadYourOutfits', result)
			end
		end)
	else
		print("Error: SteamID not found for " .. _source)
	end
end)

RegisterNetEvent('vorpclothingstore:buyPlayerCloths')
AddEventHandler('vorpclothingstore:buyPlayerCloths', function(result)
	startBuyCloths()
end)

RegisterNetEvent('vorpclothingstore:setOutfit')
AddEventHandler('vorpclothingstore:setOutfit', function(result)
	startBuyCloths()
end)

RegisterNetEvent('vorpclothingstore:deleteOutfit')
AddEventHandler('vorpclothingstore:deleteOutfit', function(result)
	startBuyCloths()
end)