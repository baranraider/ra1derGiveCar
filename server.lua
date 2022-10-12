QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('esx_givecarkeys:setVehicleOwnedPlayerId')
AddEventHandler('esx_givecarkeys:setVehicleOwnedPlayerId', function (playerId, vehicleProps, key)
	local src = source
		local zPlayer = QBCore.Functions.GetPlayer(playerId)
		exports.ghmattimysql:execute('UPDATE owned_vehicles SET citizenid = @citizenid WHERE plate = @plate', {
			['@citizenid'] = zPlayer.PlayerData.citizenid,
			['@plate'] = vehicleProps.plate
		}, function()
			TriggerEvent('DiscordBot:ToDiscord', 'aracdevret', vehicleProps.plate .." Plakalı Aracını Devretti", src, zPlayer.PlayerData.source)
			TriggerClientEvent("QBCore:Notify", zPlayer.PlayerData.source, vehicleProps.plate..' plakalı aracın anahtarını aldın!')
			TriggerClientEvent("tgiann-arackilit:plakaekle", zPlayer.PlayerData.source, vehicleProps.plate)
			TriggerClientEvent("tgiann-arackilit:plakaekle-xhotwire", zPlayer.PlayerData.source, vehicleProps.plate)
		end)
end)

QBCore.Commands.Add("givecar", "Bir oyuncunun datasına araç ver (only god", {}, true, function(source, args)
	TriggerClientEvent("ra1der:givecar", source)
end, "god")

QBCore.Functions.CreateCallback("ra1der:givecar:check", function(source, cb, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args.input))
	if Player == nil then
		cb(false) 
	else
		TriggerClientEvent('QBCore:Command:SpawnVehicle', tonumber(args.input), args.input2, true)
		cb(true)
	end
end)

RegisterServerEvent("giveSpawnVehicle", function(vehicleProps, vehicle)
	local xPlayer = QBCore.Functions.GetPlayer(source)
	exports.ghmattimysql:execute('INSERT INTO owned_vehicles (citizenid, plate, vehicle, carName) VALUES (@citizenid, @plate, @vehicle, @carName)', {
		['@citizenid']   = xPlayer.PlayerData.citizenid,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
		['@carName'] = vehicleProps.carName
	}, function()
		TriggerClientEvent("x-hotwire:give-keys", xPlayer.PlayerData.source, vehicle, vehicleProps.plate)
		TriggerClientEvent("QBCore:Notify", xPlayer.PlayerData.source, vehicleProps.plate.." plakalı araç artık senin")
	end)
end)

