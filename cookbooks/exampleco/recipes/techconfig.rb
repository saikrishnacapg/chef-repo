require 'base64'
require "net/http"
require "uri"
require 'restclient'

  uuidList = fetchUUID("eng2")
  parsed = JSON.parse(File.read("/tmp/release.json"))


  runlist = parsed["run_list"][0]
  pp runlist
  assetList = assetList(runlist)
  processList = processList(runlist)
  dependencyMap = parsed["DependencyDefinition"]["DependencyMap"]
  dependentList=Hash.new
  dependentList=dependencyList(assetList,dependentList)
  dependentList=updateDependencyList(dependencyMap,runlist,dependentList)
  pp runlist
  firstExecuteList=executionOrder(dependentList,assetList)

  Chef::Log.info "Processing Json #{assetList}\n"
  Chef::Log.info "Processing Json #{processList}\n"
  Chef::Log.info "DependencyList #{dependentList}\n"
  Chef::Log.info "List of UUID #{uuidList}\n"

  Chef::Log.info "============================"
  Chef::Log.info "Dependency Map for Reference"
  Chef::Log.info "============================"
  dependentList.keys.each do |key|
     Chef::Log.info "#{key} is dependent on completion of #{dependentList[key]}"
  end
  spinner=[]
  spinner[0]=circleClock

  count=0
  while count<50
     printf("\rCreating Execution Tree from the asset List %s",spinner[0].next)
     sleep(0.1)
     count+=1
  end
  puts
  
  executeDepHash=createExecutionHash(dependentList,processList) 
  buildExecutionTree(executeDepHash,firstExecuteList,processList) 
  Chef::Log.info "#{firstExecuteList}"
  callCatalogActionUrl="https://ocloud-mintpress.wpdev.mintpress.io/REST/ServiceCatalog/performAction"

  username="l2007"
  password="Sahasra14$"
  methodData="post"
  firstExecuteList[0].each do |asset|
     puts "#{asset.split("_")[0]} -> #{asset.split("_")[1]} -> #{uuidList[asset.split("_")[0]]}"
     payloadData="{'uuid': #{uuidList[asset.split("_")[0]]}, 'actionCode': #{asset.split("_")[1]}, 'ignoreInitialState': 'false'}"   
     processList[asset]="INPROGRESS"
  #   response=postRestClient(callCatalogActionUrl,username,password,payloadData,methodData)
  #   puts response
  end
  buildExecutionTree(executeDepHash,firstExecuteList,processList)
  firstExecuteList[0].each do |asset|
  end
