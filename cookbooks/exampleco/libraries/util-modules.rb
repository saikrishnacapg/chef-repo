require 'base64'
require 'restclient'
require 'json'

#======================================
#Start of function to process the json 
#Author: Jsky
#Date: 05-Feb-2020
#======================================

def processJson(filename)
count=1;
parsed=JSON.parse(File.read(filename))
executionOrder=""
runlist=parsed["run_list"][0]
totalAssets=[]
parallelAssets=[]
sequenceAssets=[]
depMap=[]
runlist.each do |key,value|
  totalAssets << key 
end
if !parsed["DependencyDefinition"]["DependencyMap"].nil? && !parsed["DependencyDefinition"]["DependencyMap"].empty?
    depMap = parsed["DependencyDefinition"]["DependencyMap"].split("=>")
    depMap.each_with_index do |depAsset,index|
      if count == 1
         depAsset.split("|").each do |assetCode|
            runlist[assetCode]['action'].split("=>").each_with_index do |action,index|
               executionOrder+="#{assetCode}_#{action}"
               if index+1<runlist[assetCode]['action'].split("=>").length()
               executionOrder+="=>"
               end
               totalAssets.delete(assetCode)
            end
         end  
      else
           depAsset.split("|").each_with_index do |assetCode,index|
            runlist[assetCode]['action'].split("=>").each_with_index do |action,index|
               executionOrder+="#{assetCode}_#{action}"
               if index+1<runlist[assetCode]['action'].split("=>").length()
               executionOrder+="=>"
               end
               totalAssets.delete(assetCode)
            end
            if index+1<depAsset.split("|").length()
              executionOrder+="," 
            end
         end 
      end
      count= count+1


      if index+1<depMap.length()
               executionOrder+="=>"
            end
    end
      parallelAssets << executionOrder
            executionOrder=""
end
  totalAssets.each_with_index do |assetCode,index|
            runlist[assetCode]['action'].split("=>").each_with_index do |action,index|
               executionOrder+="#{assetCode}_#{action}"
               if index+1<runlist[assetCode]['action'].split("=>").length()
               executionOrder+="=>"
               end
            end
            parallelAssets << executionOrder
            executionOrder=""
   end
   puts parallelAssets
end

#======================================
#End of function to process the json 
#======================================


#===============================================
#Start of function to fetch uuid of environment 
#Author: Jsky
#Date: 05-Feb-2020
#===============================================

def fetchUUID(envname)

 uuidList = Hash.new
 response=RestClient::Request.execute(method: :get, user: "l2007", password: "Sahasra14$", url: "https://ocloud-mintpress.wpdev.mintpress.io/REST/ServiceCatalog/list?verbose=true", payload: '', headers: {'Content-Type' => 'application/json' })
 parsed=JSON.parse(response)

 parsed.each do |element|
  if element["launchDetails"]["environment"]["name"].include?("eng2")
    puts "UUID #{element["uuid"]} and #{element["launchDetails"]["providersToServiceCatalogItems"][0]["serviceCatalogItems"][0]["code"]}"
    uuidList[element["launchDetails"]["providersToServiceCatalogItems"][0]["serviceCatalogItems"][0]["code"]]=element["uuid"]
  end
 end

 uuidList
end 
