require 'json'
require 'set'

def assetList(runlist)
 
 assetActions=Hash.new
 actionList=Array.new  
 
 runlist.each do |key,value|
    value["action"].split(",").each do |action|
       actionList << "#{key}_#{action}"
    end
    assetActions[key]=actionList
    actionList=[]
 end
 assetActions 
end

def processList(runlist)

 processList=Hash.new

 runlist.each do |key,value|
    value["action"].split(",").each do |action|
       processList["#{key}_#{action}"]=false
    end
 end
 processList
end

def updateDependencyList(dependencyMap,runlist,dependentMap)
  depKeys=Array.new
  if !dependencyMap.nil?
   dependencyMap.each do |depAssets|
    depKeys << depAssets.keys
   end
   count=0
   depKeys.each do |keyVal|
    if keyVal[0].include? "*.*" 
      assetId=keyVal[0].split("_")[0]
      runlist[assetId]["action"].split(",").each do |actions|
         dependentMap["#{assetId}_#{actions}"]=dependencyMap[count][keyVal[0]]
      end 
    else
         dependentMap[keyVal[0]]=dependencyMap[count][keyVal[0]]
    end
    count=count+1
   end
  end
  dependentMap
end

def executionOrder(dependentList, assetList)
  executionOrder=Array.new(Array.new)
  parallelExOrder=[]
  
  assetList.each do |asset,actions|
    actions.each_with_index do |action,index|
      if executionOrder[index].nil?
         executionOrder[index]=[]
      end
      if dependentList[action].nil?
         executionOrder[index].push(action)
      end
      dependentList.keys.each do |key|
        if dependentList[key].eql?action
           if executionOrder[index+1].nil?
             executionOrder[index+1]=[] 
           end
           executionOrder[index+1].push(key)
        end
      end 
    end
  end
  executionOrder
end
def dependencyList(assetActions,dependentList)
   assetActions.keys.each do |key|
     i=assetActions[key].length
     while(i>1)
       dependentList[assetActions[key][i-1]]=assetActions[key][i-2]
       i=i-1
     end
   end 
   dependentList
end
def printExecutionOrder(executionOrder, dependentList)
  printingData=""
  Chef::Log.info "==============="
  Chef::Log.info "Execution Order"
  Chef::Log.info "===============" 
  executionOrder.each_with_index do |executeList,index|
    Chef::Log.info "#{index+1}). #{executionOrder[index]}"
    Chef::Log.info
  end
end
