StoreBlips, StorePeds, initComplete = {}, {}, false
Pedheading, DressHeading, cameraIndex = 0.0, 0.0, 0
inShop = false

MenuData = {}
TriggerEvent("menuapi:getData",function(call)
    MenuData = call
end)

Citizen.CreateThread(function()
	Wait(1000)
	--Wait(10000)
	local pedModel = GetHashKey("S_M_M_Tailor_01")
	LoadModel(pedModel)
	BlipManager(true)	-- Initialize Store Objects/Blips
	
	while true do
		local delayThread, playerPed = 500, PlayerPedId()
		if initComplete and not inShop then
			local playerCoords = GetEntityCoords(playerPed)
			for k,v in pairs(Config.Stores) do
				if #(playerCoords - vector3(v.EnterStore[1], v.EnterStore[2], v.EnterStore[3])) < v.EnterStore[4] then
					delayThread = 5
					DrawText(_("PressToOpen"), 0.5, 0.9, 0.7, 0.7, 255, 255, 255, 255, true, true);
					if IsControlJustPressed(2, 0xD9D0E1C0) then
						inShop = true
						TriggerServerEvent("vorpclothingstore:getPlayerCloths");
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
			if IsControlJustPressed(0, 0x7065027D) then
				DressHeading = DressHeading + 1.0;
				SetEntityHeading(playerPed, DressHeading);
			end
			if IsControlPressed(0, 0xB4E465B4) then
				DressHeading = DressHeading - 1.0;
				SetEntityHeading(playerPed, DressHeading);
			end
		end
		Citizen.Wait(delayThread)
	end
end)


RegisterNetEvent('vorpclothingstore:LoadYourCloths')
AddEventHandler('vorpclothingstore:LoadYourCloths', function(comps, skin)
	LoadYourCloths(comps, skin)
end)

RegisterNetEvent('vorpclothingstore:LoadYourOutfits')
AddEventHandler('vorpclothingstore:LoadYourOutfits', function(result)
	LoadYourOutfits()
end)

RegisterNetEvent('vorpclothingstore:startBuyCloths')
AddEventHandler('vorpclothingstore:startBuyCloths', function(result)
	startBuyCloths()
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		BlipManager(false)
		PedManager(false)
		MenuData.CloseAll()
		RenderScriptCams(false, true, 1000, true, true, 0);	-- Debug
		FreezeEntityPosition(PlayerPedId(), false);	-- Debug
		DoScreenFadeIn(1);	-- Debug
		TriggerEvent("vorp:setInstancePlayer", false);	-- Debug
		print("off")
	end
end)