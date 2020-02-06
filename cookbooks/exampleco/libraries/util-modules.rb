require 'base64'
require 'restclient'
require 'json'

#===============================================
#Start of function to fetch uuid of environment 
#Author: Jsky
#Date: 05-Feb-2020
#===============================================

def fetchUUID(envname)

 uuidList = Hash.new
 Chef::Log.info("Looking for UUID File")
 if !(File.file?("/tmp/allUUID.json")) 
   Chef::Log.info("File allUUID json is not Found, making Rest api call to fetch the data from mintpress") 
   Chef::Log.info("Calling the mintpress rest api to get the UUID")
   response=callRestClient("https://ocloud-mintpress.wpdev.mintpress.io/REST/ServiceCatalog/list?verbose=true","l2007","Sahasra14$","","")
   #response=RestClient::Request.execute(method: :get, user: "l2007", password: "Sahasra14$", url: "https://ocloud-mintpress.wpdev.mintpress.io/REST/ServiceCatalog/list?verbose=true", payload: '', headers: {'Content-Type' => 'application/json' })
   File.write('/tmp/allUUID.json', response)
 end
 Chef::Log.info("Parsing the UUID file")
 parsed=JSON.parse(File.read("/tmp/allUUID.json"))
 Chef::Log.info("File")
 parsed.each do |element|
  if element["launchDetails"]["environment"]["name"].include?("eng2")
    uuidList[element["launchDetails"]["providersToServiceCatalogItems"][0]["serviceCatalogItems"][0]["code"]]=element["uuid"]
  end
 end

 uuidList
end 

def callRestClient(url,username,password,payload,method)
  response=RestClient::Request.execute(method: :get, user: username, password: password, url: url, payload: payload, headers: {'Content-Type' => 'application/json' })
  response
end
