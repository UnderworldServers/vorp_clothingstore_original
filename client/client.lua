StoreBlips, StorePeds, initComplete = {}, {}, false
Pedheading, DressHeading = 0.0, 0.0
local inShop = false

Citizen.CreateThread(function()
	Wait(10000)
	local pedModel, modelLoaded = GetHashKey("S_M_M_Tailor_01"), LoadModel(pedModel)
	BlipManager(true)	-- Initialize Store Objects/Blips
	
	while true do
		local delayThread, playerPed = 500, PlayerPedId()
		if initComplete and not inShop then
			local playerCoords = GetEntityCoords(playerPed)
			for k,v in pairs(Config.Stores) do
				if #(playerCoords - vector3(v.EnterStore[1], v.EnterStore[2], v.EnterStore[3])) < v.EnterStore[4] then
					delayThread = 5
					DrawTxt(Locales["PressToOpen"], 0.5, 0.9, 0.7, 0.7, 255, 255, 255, 255, true, true);
					if IsControlJustPressed(2, 0xD9D0E1C0) then
						inShop = true
						TriggerServerEvent("vorp_clothingstore:getPlayerCloths");
						MoveToCoords(k)
					end
					break
				end
			end
		elseif inShop then
			delayThread = 2
			if IsControlJustPressed(0, 0x8FD015D8) then
				cameraIndex = cameraIndex + 1;
				if (cameraIndex > 4) then
					cameraIndex = 0;
				end

				SwapCameras(cameraIndex);
			end
			if IsControlJustPressed(0, 0xD27782E3) then
				cameraIndex = cameraIndex - 1;
				if (cameraIndex < 0) then
					cameraIndex = 4;
				end

				SwapCameras(cameraIndex);
			end
			if IsControlJustPressed(0, 0x7065027D)
				DressHeading = DressHeading + 1.0;
				SetEntityHeading(playerPed, DressHeading);
			end
			if IsControlPressed(0, 0xB4E465B4)
				DressHeading = DressHeading - 1.0;
				SetEntityHeading(playerPed, DressHeading);
			end
		end
		Citizen.Wait(delayThread)
	end
end)


RegisterNetEvent('vorp_clothingstore:LoadYourCloths')
AddEventHandler('vorp_clothingstore:LoadYourCloths', function(comps, skin)
	LoadYourCloths()
end)

RegisterNetEvent('vorp_clothingstore:LoadYourOutfits')
AddEventHandler('vorp_clothingstore:LoadYourOutfits', function(result)
	LoadYourOutfits()
end)

RegisterNetEvent('vorp_clothingstore:startBuyCloths')
AddEventHandler('vorp_clothingstore:startBuyCloths', function(result)
	startBuyCloths()
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		BlipManager(false)
		PedManager(false)
		
	end
end)