local Exports = {
    CurrentLevel = 2, 
    DoubleQuest = true, 
    CurrentQuests = {},
    BlacklistedQuestIds = {
        BartiloQuest = 1, 
        CitizenQuest = 1, 
        Trainees = 1, 
        MarineQuest = 1, 
    }
} 

local NpcList = require(ReplicatedStorage.GuideModule).Data.NPCList 

repeat wait() until game.Players.LocalPlayer.DataLoaded and ScriptStorage and ScriptStorage.IsInitalized

Exports.Quests = require(game.ReplicatedStorage.Quests) 

function Exports.Set(Self, Index, Value) 
    Self[Index] = Value
end 

function Exports.RefreshQuest(Self) 
    local QuestLevelFlag = 0  
    local CurrentQuestData 
    
    for QuestID, QuestDatas in Exports.Quests do 
        if not Exports.BlacklistedQuestIds[QuestID] then 
            if QuestDatas[0].LevelReq > QuestLevelFlag and QuestDatas[0].LevelReq <= ScriptStorage.PlayerData.Level then 
                QuestLevelFlag = QuestDatas[0].LevelReq  
                CurrentQuestData = QuestDatas
            end 
        end 
    end 
    
    local LastQuest = CurrentQuestData[#CurrentQuestData] 
    
    for _, Count in ChildQuestCount do 
        if Count == 1 then 
            table.remove(CurrentQuestData, #CurrentQuestData)
        end 
    end 
    
    
    for i, v in NPCList do
        for i1, v1 in v.Levels do
            if v1 == CurrentQuestData[#CurrentQuestData].LevelReq then
                Self.CurrentNpc = i.CFrame
            end
        end
    end 
    
    Self.CurrentQuests = CurrentQuestData 
end 

function Exports.GetCurrentQuest(Self) 
    
    local QuestIndex = #Self.CurrentQuests < Self.CurrentLevel and 1 or 2 
    
    return Self.CurrentQuests[QuestIndex], Self.CurrentNpc
end 

function Exports.MarkAsCompleted(Self)
    Self.CurrentLevel = Self.CurrentLevel == 2 and 1 or 2
end  

return Exports
