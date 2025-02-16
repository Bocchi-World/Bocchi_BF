local Segmants = {"RawConstants", "Utilly", "QuestManager", "SpawnRegionLoader", "TweenController", "AttackController", "CombatController", "FunctionsHandler", "Hooks", "Hash"}

local CDN_HOST = "https://raw.githubusercontent.com/Bocchi-World/Bocchi_BF/refs/heads/main/"
local FolderPath = "Bocchi/Blox_Fruit/Assets/"
FolderStruct = 
{
    Bocchi = 
    {
        Blox_Fruit =
        {
            "Assets", 
            "Cache"
        }
    }
}

loadstring(game:HttpGet(CDN_HOST .. "Hash.lua"))() 

function GenerateFolder(Data, path)
    _ = not path and print("[ Debug ] No folder found, regenerating...")
    
    path = path or ""
    for idx, val in pairs(Data) do
        if type(idx) == "string" then
            warn("[ Debug ] Generating ", path, "/", idx)
            pcall(makefolder, path .. "/" .. idx)

            GenerateFolder(val, path .. "/" .. idx)
        else
            print("[ Debug ] Generating /", path, "/", val)
            pcall(makefolder, path .. "/" .. val)
        end
    end
end

-- ty gemini ai 
local function StringToEpoch(date_string)
  local year, month, day, hour, minute, second = date_string:match("(%d%d%d%d)-(%d%d)-(%d%d)T(%d%d):(%d%d):(%d%d)Z")

  year = tonumber(year)
  month = tonumber(month)
  day = tonumber(day)
  hour = tonumber(hour)
  minute = tonumber(minute)
  second = tonumber(second)

  local days_in_month = { 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

  if (year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0 then
    days_in_month[2] = 29
  end

  local days = 0

  for y = 1970, year - 1 do
    if (y % 4 == 0 and y % 100 ~= 0) or y % 400 == 0 then
      days = days + 366
    else
      days = days + 365
    end
  end
  for m = 1, month - 1 do
    days = days + days_in_month[m]
  end

  days = days + day - 1

  local seconds = days * 86400 + hour * 3600 + minute * 60 + second

  return seconds
end

function GetLastestReposityCommitDate()
    local Result = game:GetService("HttpService"):JSONDecode(
        game:HttpGet"https://api.github.com/repos/Bocchi-World/Bocchi_BF/commits/main" 
    ) 
    return StringToEpoch(Result.commit.author.date), sha256(Result.commit.author.date)
end 

function Download(ForceSegmant) 
    
    local StartTime = tick() 
    
    for Index, Segmant in Segmants do 
        
        if not ForceSegmant or Segmant == ForceSegmant then 
                
            print("[ Debug ]", Index, "/", #Segmants, "Downloading", Segmant, "...") 
            local Result = game:HttpGet(CDN_HOST .. Segmant .. ".lua") 
            
            print("[ Debug ] Successfully written", Segmant, ".lua" )
            
            writefile(FolderPath .. Segmant .. ".lua", Result)
        end
    end
end 
_ = not isfolder("Bocchi") and GenerateFolder(FolderStruct)


local Date, Hash = GetLastestReposityCommitDate() 

if not isfile(FolderPath .. "._fingerprint") or ( readfile(FolderPath .. "._fingerprint") ~= Hash and os.time() - Date > 300 ) then
    print("[ Debug ] New version", Hash, "found, downloading...")
    Download()
    writefile(FolderPath .. "._fingerprint", Hash)
end 


for _, Segmant in Segmants do 
    if not isfile(FolderPath .. Segmant .. ".lua") then  
        print("[ Debug ] Segmant", Segmant, "is missing, collecting...")
        Download(Segmant)
    end
end 

