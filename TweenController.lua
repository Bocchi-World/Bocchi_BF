local Exports = {} 

Exports.TweenPart = Instance.new("Part", workspace) 
Exports.TweenPart.CanCollide = false
Exports.TweenPart.Transparency = 1 

function Exports.Update() 

    local Part = Exports.TweenPart
    Part.CanCollide = true 
    Part.Transparency = .3 
    
    local HumanoidRootPart = LocalPlayer.Character:WaitForChild("HumanoidRootPart") 
    
    if CaculateDistance(Part.CFrame) > 50 then
        wait() 
        Part.CFrame = HumanoidRootPart.CFrame
        wait() 
    end
    HumanoidRootPart.CFrame = Part.CFrame+Vector3.new(0,3,0)
end

Exports.TweenPart:GetPropertyChangedSignal("CFrame"):Connect(Exports.Update)  

function Exports.Create(Position)
    assert(Position) 
    
    local Position = ConvertTo(CFrame, Position) 
    
    if TweenInstance then 
        pcall(function() 
            TweenInstance:Cancel() 
        end)
    end 
    
    Exports.Update()
    
    TweenInstance = Services.TweenService:Create(
            Exports.TweenPart,
            TweenInfo.new(CaculateDistance(Exports.TweenPart.CFrame, Position) / 350, Enum.EasingStyle.Linear),
            {CFrame = Position-Vector3.new(0,3,0)}
        ) 
    TweenInstance:Play()
end

return Exports
