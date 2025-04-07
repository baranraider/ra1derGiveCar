local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('spawnVehicle:client')
AddEventHandler('spawnVehicle:client', function(vehiclemodel, plate, type)
    local PlayerData = QBCore.Functions.GetPlayerData()
    local playerPed = PlayerPedId()
    local pCoords = GetEntityCoords(playerPed)
    pCoords = vector4(pCoords.x, pCoords.y, pCoords.z, GetEntityHeading(playerPed))

    QBCore.Functions.SpawnVehicle(vehiclemodel, function(vehicle)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

        local newPlate = plate
        local vehicleProps = QBCore.Functions.GetVehicleProperties(vehicle)
        vehicleProps.plate = newPlate
        SetVehicleNumberPlateText(vehicle, newPlate)

 
        QBCore.Functions.TriggerCallback('giveCarCallback', function(success)
            if success then
                QBCore.Functions.Notify("Araç başarıyla verildi!", "success")
            else
                QBCore.Functions.Notify("Araç verilirken bir hata oluştu veya yetkin yok!", "error")
                DeleteEntity(vehicle)
            end
        end, vehicleProps, vehiclemodel, type)
    end, pCoords, 1)
end)

RegisterNetEvent("ra1der:givecar", function()
	local keyboard = exports['qb-input']:ShowInput({
		header = "Bir oyuncuya araç verin",
		submitText = "Onayla",
		inputs = {
			{
				type = 'text',
				isRequired = true,
				text = "Oyuncu ID",
				name = 'input',
			},
			{
				type = 'text',
				isRequired = true,
				text = "Araç İsmi",
				name = 'input2',
			}
		}
	})
	if not IsModelValid(keyboard.input2) then 
		QBCore.Functions.Notify(keyboard.input2.. " İsimli Araç Bulunamadı", "error")
		return 
	end
	QBCore.Functions.TriggerCallback('ra1der:givecar:check', function(result)
		if result then 
			QBCore.Functions.Notify(keyboard.input.. " ID'li kişiye" ..keyboard.input2.. " İsimli Araç Verildi", "success", 5000)
		else 
			QBCore.Functions.Notify(keyboard.input.. " ID'li oyuncu bulunamadı", "error")
		end
	end, keyboard)
end)




