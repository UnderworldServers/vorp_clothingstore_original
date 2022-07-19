local CamWardrove, CamUp, CamMid, CamBot, inShop
local outfits_db, MyOutfits, ClothesDB, SkinsDB = {}, {}, {}

local clothesPlayer = {
            { "Hat", 0 },
            { "Mask", 0 },
            { "EyeWear", 0 },
            { "NeckWear", 0 },
            { "NeckTies", 0 },
            { "Shirt", 0 },
            { "Suspender", 0 },
            { "Vest", 0 },
            { "Coat", 0 },
            { "Poncho", 0 },
            { "Cloak", 0 },
            { "Glove", 0 },
            { "RingRh", 0 },
            { "RingLh", 0 },
            { "Bracelet", 0 },
            { "Gunbelt", 0 },
            { "Belt", 0 },
            { "Buckle", 0 },
            { "Holster", 0 },
            { "Pant", 0 },
            { "Skirt", 0 },
            { "Chap", 0 },
            { "Boots", 0 },
            { "Spurs", 0 },
            { "Spats", 0 },
            { "Gauntlets", 0 },
            { "Loadouts", 0 },
            { "Accessories", 0 },
            { "Satchels", 0  },
            { "GunbeltAccs", 0 },
            { "CoatClosed", 0 }
};

function LoadModel(model)
	if IsIsModelValid(model) then
		while HasModelLoaded(model) do
			Delay(100)
		end
		PedManager(model)
	else
		Print("Error: Model is not valid! If you changed pedModel revert to original or verify correct name.")
		return false
	end
end

function BlipManager(action)
	if action then
		for k,v in pairs(Config.Stores) do
			local blip = Citizen.Invoke(0x554D9D53F696D002, 1664425300, vector3(v.EnterStore))
			SetBlipSprite(blip, v.BlipIcon)
			SetBlipScale(blip, 0.2)
			Citizen.InvokeNative(0x9CB1A1623062F402, blip, v.name)
			StoreBlips[#StoreBlips + 1] = blip
		end
	else
		for k,v in pairs(StoreBlips) do
			RemoveBlip(v)
		end
	end
end

function PedManager(action)
	if action then
		for k,v in pairs(Config.Stores) do
			local ped = CreatePed(model, vector4(v.NPCStore), false, true, true, true)
			SetEntityNoCollisionEntity(PlayerPedId(), ped, false)
			SetEntityCanBeDamaged(ped, false)
			SetEntityInvincible(ped, true)
			SetBlockingOfNonTemporaryEvents(ped, true)
			Citizen.Wait(1000)
			FreezeEntityPosition(ped, true)
			StorePeds[k] = ped
		end
		initComplete = true
	else
		for k,v in pairs(StorePeds) do
			DeleteEntity(v)
		end
	end
end

function DrawText3D(text, x, y, fScale, fSize, r, g, b, a, tCentered, shadow)
	local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
	SetTextScale(fScale, fSize)
	SetTextColor(r, g, b, a)
	SetTextCentre(tCentered)
	DisplayText(str,_x,_y)
	if shadow then; SetTextDropshadow(1, 0, 0, 255); end
	SetTextFontForCurrentCommand(1)
	DisplayText(str, x, y)
end

function MoveToCoords(loc)
	inShop = loc
	local playerPed = PlayerPedId()
	local Pedx = Config.Stores[inShop].NPCStore[0]
	local Pedy = Config.Stores[inShop].NPCStore[1]
	local Pedz = Config.Stores[inShop].NPCStore[2]
	Pedheading = Config.Stores[inShop].NPCStore[3]
	local Doorx = Config.Stores[inShop].DoorRoom[0]
	local Doory = Config.Stores[inShop].DoorRoom[1]
	local Doorz = Config.Stores[inShop].DoorRoom[2]
	local Playerx = Config.Stores[inShop].StoreRoom[0]
	local Playery = Config.Stores[inShop].StoreRoom[1]
	local Playerz = Config.Stores[inShop].StoreRoom[2]
	local Playerheading = Config.Stores[inShop].StoreRoom[3]
	DressHeading = Playerheading;
	local CameraMainx = Config.Stores[inShop].Cameras[0][0]
	local CameraMainy = Config.Stores[inShop].Cameras[0][1]
	local CameraMainz = Config.Stores[inShop].Cameras[0][2]
	local CameraMainRotx = Config.Stores[inShop].Cameras[0][3]
	local CameraMainRoty = Config.Stores[inShop].Cameras[0][4]
	local CameraMainRotz = Config.Stores[inShop].Cameras[0][5]

	local CameraChestx = Config.Stores[inShop].Cameras[1][0]
	local CameraChesty = Config.Stores[inShop].Cameras[1][1]
	local CameraChestz = Config.Stores[inShop].Cameras[1][2]
	local CameraChestRotx = Config.Stores[inShop].Cameras[1][3]
	local CameraChestRoty = Config.Stores[inShop].Cameras[1][4]
	local CameraChestRotz = Config.Stores[inShop].Cameras[1][5]

	local CameraBeltx = Config.Stores[inShop].Cameras[2][0]
	local CameraBelty = Config.Stores[inShop].Cameras[2][1]
	local CameraBeltz = Config.Stores[inShop].Cameras[2][2]
	local CameraBeltRotx = Config.Stores[inShop].Cameras[2][3]
	local CameraBeltRoty = Config.Stores[inShop].Cameras[2][4]
	local CameraBeltRotz = Config.Stores[inShop].Cameras[2][5]

	local CameraBootsx = Config.Stores[inShop].Cameras[3][0]
	local CameraBootsy = Config.Stores[inShop].Cameras[3][1]
	local CameraBootsz = Config.Stores[inShop].Cameras[3][2]
	local CameraBootsRotx = Config.Stores[inShop].Cameras[3][3]
	local CameraBootsRoty = Config.Stores[inShop].Cameras[3][4]
	local CameraBootsRotz = Config.Stores[inShop].Cameras[3][5]

	TriggerEvent("vorp:setInstancePlayer", true);

	ClearPedTasksImmediately(StorePeds[inShop], 1, 1);
	FreezeEntityPosition(StorePeds[inShop], false);

	Citizen.Wait(1000);
	NetworkSetInSpectatorMode(true, playerPed);

	local PedWardrobe = CreatePed(pedModel, Doorx, Doory, Doorz, 0.0, false, true, true, true);
	Citizen.Invoke(0x283978A15512B2FE, PedWardrobe, true);
	SetModelAsNoLongerNeeded(pedModel);
	SetEntityAlpha(PedWardrobe, 0, true);
	Citizen.Wait(1000);
	TaskGoToEntity(StorePeds[inShop], PedWardrobe, 15000, 0.5, 1.1, 1.0, 1);
	Citizen.Wait(4000);
	TaskGoToEntity(playerPed, PedWardrobe, 10000, 0.5, 0.8, 1.0, 1);
	Citizen.Wait(6500);

	DoScreenFadeOut(1800);
	Citizen.Wait(2000);
	ClearPedTasksImmediately(playerPed, 1, 1);

	SetEntityCoords(playerPed, Playerx, Playery, Playerz, false, false, false, false);
	SetEntityHeading(playerPed, Playerheading);
	Citizen.Wait(100);
	FreezeEntityPosition(playerPed, true);
	SetEntityCoords(StorePeds[inShop], Pedx, Pedy, Pedz, false, false, false, false);
	SetEntityHeading(StorePeds[inShop], Pedheading);

	Citizen.Wait(2000);

	CamWardrove = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", CameraMainx, CameraMainy, CameraMainz, CameraMainRotx, CameraMainRoty, CameraMainRotz, 50.00, false, 0);
	CamUp = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", CameraChestx, CameraChesty, CameraChestz, CameraChestRotx, CameraChestRoty, CameraChestRotz, 50.00, false, 0);
	CamMid = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", CameraBeltx, CameraBelty, CameraBeltz, CameraBeltRotx, CameraBeltRoty, CameraBeltRotz, 50.00, false, 0);
	CamBot = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", CameraBootsx, CameraBootsy, CameraBootsz, CameraBootsRotx, CameraBootsRoty, CameraBootsRotz, 50.00, false, 0);

	SetCamActive(CamWardrove, true);
	RenderScriptCams(true, true, 500, true, true, 0);
	FreezeEntityPosition(StorePeds[inShop], true);
	Citizen.Wait(1000);
	DoScreenFadeIn(1000);
	DeletePed(PedWardrobe);
	NetworkSetInSpectatorMode(false, playerPed);
	model = SkinsDB["sex"].ToString();
	Menus.MainMenu.GetMenu().OpenMenu();
end

function SetOutfit(index)
	TriggerServerEvent("vorpclothingstore:setOutfit", MyOutfits.ElementAt(index).Value.Item2);
	for k,v in pairs(ClothesDB) do
		clothesPlayer[k] = v
	end
	startBuyCloths(false)
end

function LoadYourCloths(cloths, skins)
	ClothesDB, SkinsDB = json.decode(cloths), json.decode(skins)
	for k,v in pairs(ClothesDB) do
		clothesPlayer[k] = v
	end
end

function DeleteOutfit(index)
	TriggerServerEvent("vorpclothingstore:deleteOutfit", index);
	MyOutfits[index] = nil
end

function LoadYourOutfits()
	MyOutfits = nil
	for k,v in pairs(outfits_db) do
		MyOutfits[k] = {title = v.title, comps = v.comps}
	end
end

function SwapCameras(index)
	if index == 0 then
		SetCamActive(CamWardrove, true);
		SetCamActive(CamBot, false);
		SetCamActive(CamUp, false);
		RenderScriptCams(true, true, 200, true, true, 0);
	elseif index == 1 then
		SetCamActive(CamUp, true);
		SetCamActive(CamWardrove, false);
		SetCamActive(CamMid, false);
		RenderScriptCams(true, true, 200, true, true, 0);
	elseif index == 2 then
		SetCamActive(CamMid, true);
		SetCamActive(CamUp, false);
		SetCamActive(CamBot, false);
		RenderScriptCams(true, true, 200, true, true, 0);
	elseif index == 3 then
		SetCamActive(CamBot, true);
		SetCamActive(CamMid, false);
		SetCamActive(CamWardrove, false);
		RenderScriptCams(true, true, 200, true, true, 0);
	end
end

function FinishBuy(buy, cost)
	local saveOutfit, outfitName = false, ""
	if buy then
		TriggerEvent("vorpinputs:getInput", Locales["ButtonNewOutfit"], Locales["PlaceHolderNewOutfit"], function(result)
			if result ~= "" or result then
				outfitName = result
				saveOutfit = true
			end
			
			TriggerServerEvent("vorp_clothingstore:buyPlayerCloths", cost, json.encode(clothesPlayer), saveOutfit, outfitName);
		end)
	end
end

function startBuyCloths(state)
	if state then
		MenuData.CloseAll()
		ExecuteCommand("/rc")
	else
		TriggerServerEvent("vorpcharacter:getPlayerSkin");
	end
	local PedExitx = Config.Stores[inShop].ExitWardrobe[0]
	local PedExity = Config.Stores[inShop].ExitWardrobe[1]
	local PedExitz = Config.Stores[inShop].ExitWardrobe[2]
	local PedExitheading = Config.Stores[inShop].ExitWardrobe[3]

	DoScreenFadeOut(1000);
	await Delay(2000);

	SetCamActive(CamWardrove, false);
	RenderScriptCams(false, true, 1000, true, true, 0);
	await Delay(1000);
	DestroyCam(CamWardrove, true);
	FreezeEntityPosition(PlayerPedId(), false);

	SetEntityCoords(PlayerPedId(), PedExitx, PedExity, PedExitz, false, false, false, false);
	SetEntityHeading(PlayerPedId(), PedExitheading);


	TriggerEvent("vorp:setInstancePlayer", false);

	DoScreenFadeIn(1000);
	inShop = nil
end