-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
rfz = Tunnel.getInterface("rfz_lixeiro")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local vehModel = 1917016601
local work = false
local selected = 0
local start = 0
local last = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAL PARA INICIAR O TRABALHO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    SetNuiFocus(false,false)
    while true do
        local Otimizacao = 1000
        if not work then
            local ped = PlayerPedId()
            local x,y,z = table.unpack(GetEntityCoords(ped))
			for k,v in pairs(Config.Lixoiniciar) do
				local distance = Vdist(GetEntityCoords(ped),v[1],v[2],v[3])
					if distance <= 1.2 then
						Otimizacao = 4
						DrawText3D(v[1],v[2],v[3],"~g~E~w~   INICIAR SERVIÇO")
						if IsControlJustPressed(0,38) then
							work = true                            
							start = 1
							last = 34                    
							selected = start
							CriandoBlip(Config.LixosRotasColetar,selected)
							TriggerEvent("Notify","importante","O serviço de <b>Lixeiro</b> foi iniciado,",7000)
						end
                    end
                end
            end
        Citizen.Wait(Otimizacao)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAIR DE SERVIÇO 
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if work then
			if IsControlJustPressed(0,168) then
				work = false 
				RemoveBlip(blips)
				TriggerEvent("Notify","aviso","Você finalizou o serviço.",8000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETA DO LIXEIRO 
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if work then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(Config.LixosRotasColetar[selected].x,Config.LixosRotasColetar[selected].y,Config.LixosRotasColetar[selected].z)
			local distance = GetDistanceBetweenCoords(Config.LixosRotasColetar[selected].x,Config.LixosRotasColetar[selected].y,cdz,x,y,z,true)
            if distance <= 1.2 then
                timeDistance = 4
				DrawText3D(Config.LixosRotasColetar[selected].x,Config.LixosRotasColetar[selected].y,Config.LixosRotasColetar[selected].z,"~g~E~w~   RECOLHER")
                if distance <= 1.2 then
                    timeDistance = 4 
                    if IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) and GetEntityModel(GetPlayersLastVehicle()) == vehModel then
                        TriggerEvent("progress",1000,"Colentando")
						TriggerEvent('cancelando',true)
						vRP._playAnim(false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
						Citizen.Wait(2000)
						vRP.removeObjects()
						TriggerEvent('cancelando',false)
						rfz.entregaritem()
						RemoveBlip(blips)
						selected = selected + 1
						if selected > last then
							selected = start
						end
                       CriandoBlip(Config.LixosRotasColetar,selected)
					end
				end			
            end
        end
        Citizen.Wait(timeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
	SetTextFont(4)
	SetTextCentre(1)
	SetTextEntry("STRING")
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z,0)
	DrawText(0.0,0.0)
	local factor = (string.len(text) / 450) + 0.01
	DrawRect(0.0,0.0125,factor,0.03,38,42,56,200)
	ClearDrawOrigin()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRIAR BLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function CriandoBlip(ConfigLixosRotasColetar,selected)
	blips = AddBlipForCoord(Config.LixosRotasColetar[selected].x,Config.LixosRotasColetar[selected].y,Config.LixosRotasColetar[selected].z)
	SetBlipSprite(blips,12)
	SetBlipColour(blips,77)
	SetBlipScale(blips,0.7)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Coleta de Componentes")
	EndTextCommandSetBlipName(blips)
end