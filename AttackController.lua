local Exports = {} 

local Net = Services.ReplicatedStorage.Modules.Net

local RegisterAttack = Net:WaitForChild("RE/RegisterAttack")
local RegisterHit = Net:WaitForChild("RE/RegisterHit")

function Exports.GetHits() 
    local Hits = {} 
    
    for _, ChildInstance in Services.Workspace.Enemies:GetChildren() do 
        local PrimaryPart = ChildInstance:FindFirstChild("PrimaryPart")
        
        if PrimaryPart and CaculateDistance(PrimaryPart.Position) < 80 then 
            table.insert(Hits, PrimaryPart)
        end 
    end 
    
    return Hits
end

function Exports.Attack() 
    if Character:FindFirstChildOfClass("Tool") then 
        local Hits, IsRegistered = Exports.GetHits(), false 
        
        for _, Child in Hits do 
            if not IsRegistered then 
                RegisterAttack:FireServer(0) 
                IsRegistered = true 
            end 
            RegisterHit:FireServer(Child)
        end 
    end 
end 

return Exports
