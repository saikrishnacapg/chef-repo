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
  failedSymbol="🔴"
  unknownStatus="⛔"
  flower=
  symbolCount=1
  if count<1
         if processList[assetName].eql?"DONE"
         assetTree+=pipe+assetName+" "+doneSymbol+"\n"
         else if processList[assetName].eql?"USHER"
          assetTree+=pipe+assetName+" "+waitSymbol+"\n"
         else if processList[assetName].eql?"PROGRESSING"
          assetTree+=pipe+assetName+" "+processingSymbol+"\n"
         else 
          assetTree+=pipe+assetName+" "+failedSymbol+"\n"
         end
  else
        while symbolCount<count-1
                symbol+="━━"
                symbolCount+=1
        end
        #puts "#{assetName} #{executionDepHash[assetName].nil?}"
           if processList[assetName].eql?"DONE"
         assetTree+=pipe+symbol+assetName+" "+doneSymbol+"\n"
         else if processList[assetName].eql?"USHER"
          assetTree+=pipe+symbol+assetName+" "+waitSymbol+"\n"
         else if processList[assetName].eql?"PROGRESSING"
          assetTree+=pipe+symbol+assetName+" "+processingSymbol+"\n"
         else 
          assetTree+=pipe+symbol+assetName+" "+failedSymbol+"\n"
         end
  end
  count+=1
  #puts executionDepHash[assetName]
  if !executionDepHash[assetName].nil?
    executionDepHash[assetName].each do |asset|
      assetTree=appendToAsset(assetTree,executionDepHash,asset,count,false)
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
  puts"======================================"
  puts"Execution Sequence and Dependency Tree"
  puts"======================================"
  puts assetTree
end