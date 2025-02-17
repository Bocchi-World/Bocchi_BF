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

local NpcList = require(game.ReplicatedStorage.GuideModule).Data.NPCList 
local QuestFrame = PlayerGui.Main.Quest

repeat wait() until game.Players.LocalPlayer.DataLoaded and ScriptStorage 

Exports.Quests = require(game.ReplicatedStorage.Quests) 

function Exports.Set(Self, Index, Value) 
    Self[Index] = Value
end 

function Exports.RefreshQuest(Self) 
    while not ScriptStorage.PlayerData.Level do 
        wait(1) 
        print("[ Debug ] Waiting for LocalPlayer datas.")
    end 
    
    local QuestLevelFlag = 0  
    local CurrentQuestData 
    
    for QuestID, QuestDatas in Exports.Quests do 
        if not Exports.BlacklistedQuestIds[QuestID] then 
            if QuestDatas[1].LevelReq > QuestLevelFlag and QuestDatas[1].LevelReq <= ScriptStorage.PlayerData.Level then 
                QuestLevelFlag = QuestDatas[1].LevelReq  
                CurrentQuestData = QuestDatas
                Self.CurrentQuestId = QuestID
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
    
    return Self.CurrentQuests[QuestIndex].MonName, Self.CurrentNpc, Self.CurrentQuestId, QuestIndex
end 

function Exports.MarkAsCompleted(Self)
    Self.CurrentLevel = Self.CurrentLevel == 2 and 1 or 2
end  

function Exports.AbandonQuest() 
    Remotes.CommF_:InvokeServer("AbandonQuest")
end 

function Exports.GetCurrentClaimQuest() 
    return QuestFrame.Visible and QuestFrame.Container.QuestTitle.Title.Text:gsub("%s*Defeat%s*(%d*)%s*(.-)%s*%b()", "%2") 
end 

function Exports.StartQuest(QuestId, QuestLevel) 
    return Remotes.CommF_:InvokeServer("StartQuest", QuestId, QuestLevel) 
end

return Exports
