local RawMobRegions = game:HttpGet("https://github.com/Bocchi-World/Bocchi_BF/raw/refs/heads/main/RawMobPositions.json") 

ServerRuntime.MobRegions = {} 

for Name, Positions in Services.HttpService:JSONDecode(RawMobPositions) do 
    ServerRuntime.MobRegions[Name] = {} 
    for _, Position in Positions do 
        table.insert(ServerRuntime.MobRegions[Name], Vector3.new(Position[1], Position[2], Position[3])) 
    end 
end 
