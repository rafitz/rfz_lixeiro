print(" ^2[ SCRIPT FEITO POR RAFITZ#6666 ] ^0 ")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
rfz = {}
Tunnel.bindInterface("rfz_lixeiro",rfz)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAR ITEMS
-----------------------------------------------------------------------------------------------------------------------------------------
function rfz.entregaritem()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.computeInvWeight(user_id) + 1 > vRP.getBackpack(user_id) then
			TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.",5000)
		else
			vRP.giveInventoryItem(user_id,Config.ItensReceber[math.random(#Config.ItensReceber)],math.random(Config.QuantidadeReceberAleatoria),true)
			vRP.upgradeStress(user_id,1)
		end	
	end
end