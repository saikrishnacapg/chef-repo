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
       processList["#{key}_#{action}"]="USHER"
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
      runlist[assetId]["action"].split(",").each_with_index do |actions,index|
         if index==0
            dependentMap["#{assetId}_#{actions}"]=dependencyMap[count][keyVal[0]]
         end
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
def appendToAsset(assetTree,executionDepHash,assetName,count,processList)

  symbol="━"
  pipe="┣"
  doneSymbol="✅"
  waitSymbol="🌕"
  processingSymbol="🔵"
  failedSymbol="🚫"
  initalStatus="⛔"
  symbolCount=0
  if count<1
          if processList[assetName].eql?("USHER")
            assetTree+=pipe+assetName+" "+initalStatus+"\n"
          elsif processList[assetName].eql?("INPROGRESS")
	    assetTree+=pipe+assetName+" "+processingSymbol+"\n"
          elsif processList[assetName].eql?("FAILED")
            assetTree+=pipe+assetName+" "+failedSymbol+"\n"
          elsif processList[assetName].eql?("DONE")
            assetTree+=pipe+assetName+" "+doneSymbol+"\n"
          end 
          
  else
        while symbolCount<count-1
                symbol+="━━"
                symbolCount+=1
        end
          if processList[assetName].eql?("USHER")
            assetTree+=pipe+symbol+assetName+" "+initalStatus+"\n"
          elsif processList[assetName].eql?("INPROGRESS")
            assetTree+=pipe+symbol+assetName+" "+processingSymbol+"\n"
          elsif processList[assetName].eql?("FAILED")
            assetTree+=pipe+symbol+assetName+" "+failedSymbol+"\n"
          elsif processList[assetName].eql?("DONE")
            assetTree+=pipe+symbol+assetName+" "+doneSymbol+"\n"
          end
  end
  count+=1
  #Chef::Log.info "#{assetName} -> #{executionDepHash[assetName]} -> #{count}"
  if !executionDepHash[assetName].nil?
    executionDepHash[assetName].each do |asset|
      assetTree=appendToAsset(assetTree,executionDepHash,asset,count,processList)
    end
  end
  assetTree
end
def createExecutionHash(dependentList,processList)
  executionDepHash=Hash.new(Array.new)
  processList.keys.each do |key|
    executionDepHash[key]=[]
  end
  dependentList.keys.each do |key|
    if !dependentList[key].nil?
       executionDepHash[dependentList[key]] << key
    end
  end
  executionDepHash
end
def buildExecutionTree(executionDepHash,firstexecuteList,processList)

  #pp executionDepHash
  assetTree=""
  count=0
  firstexecuteList[0].each do |asset|
    assetTree=appendToAsset(assetTree,executionDepHash,asset,count,processList)
  end
  processList.keys.each do |key|
    if processList[key].eql?"USHER"
      Chef::Log.info "Asset #{processList[key]} is waiting to process"
    elsif processList[key].eql?"INPROGRESS"
      Chef::Log.info "Asset #{processList[key]} is in progress "
    elsif processList[key].eql?"DONE"
      Chef::Log.info "Asset #{processList[key]} Completed execution"
    end 
  end

  Chef::Log.info"======================================"
  Chef::Log.info"Execution Sequence and Dependency Tree"
  Chef::Log.info"======================================"
  Chef::Log.info assetTree
end
