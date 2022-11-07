QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

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

--NEW QBCORE İçin
--local function GeneratePlate()
-- 	local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
-- 	local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
-- 	if result then
-- 		return GeneratePlate()
-- 	else
-- 		return plate:upper()
-- 	end
-- end

-- QBCore.Functions.CreateCallback("ra1der:givecar:check", function(source, cb, args)
-- 	local Player = QBCore.Functions.GetPlayer(tonumber(args.input))
-- 	if Player == nil then
-- 		cb(false) 
-- 	else
-- 		TriggerClientEvent('spawnVehicle:client', tonumber(args.input), args.input2, GeneratePlate(), true)
-- 		cb(true)
-- 	end
-- end)

-- RegisterServerEvent("giveCar", function(vehicleProps, vehiclemodel, vehicle)
-- 	local pData = QBCore.Functions.GetPlayer(source)
-- 	MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
-- 		pData.PlayerData.license,
-- 		pData.PlayerData.citizenid,
-- 		vehiclemodel,
-- 		GetHashKey(vehiclemodel),
-- 		json.encode(vehicleProps),
-- 		vehicleProps.plate,
-- 		'',
-- 		0
-- 	}, function() 
-- 		TriggerClientEvent("QBCore:Notify", pData.PlayerData.source, vehicleProps.plate.." plakalı araç artık senin")
-- 	end)
-- end)




