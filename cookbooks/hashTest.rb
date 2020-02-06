executionOrder=Hash.new
dependentActions=Hash.new

actionList=Array.new
actionList << "obpoid_uploadonly"
actionList << "obpoid_shutdown"
actionList << "obpoid_onlineonly"

executionOrder["obpoid"] = actionList

actionList=[]
actionList << "obpoid_uploadonly"
actionList << "obpoid_shutdown"
actionList << "obpoid_onlineonly"
executionOrder["obpobh"] = actionList 

actionList=[]
actionList << "obpoid_uploadonly"
actionList << "obpoid_shutdown"
actionList << "obpoid_onlineonly"
executionOrder["obpsoa"] = actionList

dependentActions["obpobh_onlineonly"]="obpoid_onlineonly"
dependentActions["obpsoa_onlineonly"]="obpoid_onlineonly"


puts executionOrder
puts dependentActions
