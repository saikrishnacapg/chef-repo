require 'base64'
require "net/http"
require "uri"
require 'restclient'

  uuidList = fetchUUID("eng2")
  parsed = JSON.parse(File.read("/tmp/test1.json"))


  runlist = parsed["run_list"][0]
  pp runlist
  assetList = assetList(runlist)
  processList = processList(runlist)   
  dependencyMap = parsed["DependencyDefinition"]["DependencyMap"] 
  dependentList=Hash.new
  dependentList=dependencyList(assetList,dependentList)
  dependentList=updateDependencyList(dependencyMap,runlist,dependentList)
  pp runlist
  executionOrder=executionOrder(dependentList,assetList)

  Chef::Log.info "Processing Json #{assetList}\n"
  Chef::Log.info "Processing Json #{processList}\n"
  Chef::Log.info "DependencyList #{dependentList}\n"
  Chef::Log.info "List of UUID #{uuidList}\n"
  
  printExecutionOrder(executionOrder,dependentList)
  Chef::Log.info "============================"
  Chef::Log.info "Dependency Map for Reference"
  Chef::Log.info "============================"
  dependentList.keys.each do |key|
     Chef::Log.info "#{key} is dependent on completion of #{dependentList[key]}"
  end
