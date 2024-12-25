-- server.lua
local collectedTrees = {}

-- โหลดข้อมูลเมื่อเซิร์ฟเวอร์เริ่มทำงาน
CreateThread(function()
    LoadCollectedTrees()
end)

-- บันทึกข้อมูลด้วย native
function SaveCollectedTrees()
    SaveResourceFile(GetCurrentResourceName(), "data.json", json.encode(collectedTrees), -1)
end

-- โหลดข้อมูลด้วย native
function LoadCollectedTrees()
    local fileContent = LoadResourceFile(GetCurrentResourceName(), "data.json")
    if fileContent then
        collectedTrees = json.decode(fileContent) or {}
    else
        collectedTrees = {}
        SaveCollectedTrees()
    end
end

-- Events
RegisterNetEvent('christmas:requestSync')
AddEventHandler('christmas:requestSync', function()
    local source = source
    TriggerClientEvent('christmas:syncCollectedTrees', source, collectedTrees)
end)

RegisterNetEvent('christmas:collectTree')
AddEventHandler('christmas:collectTree', function(pointIndex)

	pointIndex = tostring(pointIndex) 
    if not collectedTrees[pointIndex] then
        collectedTrees[pointIndex] = true
        TriggerClientEvent('christmas:treeCollected', -1, pointIndex)
        SaveCollectedTrees()

    end

end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    LoadCollectedTrees()
end)

--[[ AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    SaveCollectedTrees()
end) ]]