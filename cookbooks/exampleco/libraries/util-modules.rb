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
  if element["launchDetails"]["environment"]["name"].include?(envname)
    uuidList[element["launchDetails"]["providersToServiceCatalogItems"][0]["serviceCatalogItems"][0]["code"]]=element["uuid"]
  end
 end

 uuidList
end 

def postRestClient(url,username,password,payload,method)
  response=RestClient::Request.execute(method: method, user: username, password: password, url: url, payload: payload, headers: {'Content-Type' => 'application/json' })
  response
end

def getRestClient(url,username,password)
  response=RestClient::Request.execute(method: :get, user: username, password: password, url: url, payload: {}, headers: {})
  response
end

def fetchCatalogStatus(username,password,uuid)
  count=0
  spinner = spinnerMethod() 
  spinner1 = spinnerMethod() 
  puts "Entered in to FetchCatalogStaus"
  uuid="e2686b82-f8d7-436e-b4cc-cfae132d5fa0"
  fetchCatalogStatusUrl="https://ocloud-mintpress.wpdev.mintpress.io/REST/ServiceCatalog/get?uuid=#{uuid}"
  response=getRestClient(fetchCatalogStatusUrl,username,password)
  parsed=JSON.parse(response)
  if !parsed["launchDetails"]["providersToServiceCatalogItems"][0]["serviceCatalogItems"][0]["currentActionInvocation"].nil?
      while !parsed["launchDetails"]["providersToServiceCatalogItems"][0]["serviceCatalogItems"][0]["currentActionInvocation"].nil? do
        text=parsed["launchDetails"]["providersToServiceCatalogItems"][0]["serviceCatalogItems"][0]["currentActionInvocation"]["actionInvocationState"]
        assetCode=parsed["launchDetails"]["providersToServiceCatalogItems"][0]["serviceCatalogItems"][0]["code"]
        envName=parsed["launchDetails"]["environment"]["name"]
        printf("\r#{envName} service catalog of #{assetCode} is in #{text} state, request is processing for %s %ds %s",spinner.next,count/10,spinner1.next)
        printf("\r#{envName} service catalog of #{assetCode} is in #{text} state, request is processing for %s %ds %s",spinner.next,count/10,spinner1.next)
        sleep(0.1)
        if count%100==0
         response=getRestClient(fetchCatalogStatusUrl,username,password)
        end 
        parsed=JSON.parse(response)
        count+=1
      end  
  end
  
end

def callRestClient(url,username,password,payload,method)
  response=RestClient::Request.execute(method: :get, user: username, password: password, url: url, payload: payload, headers: {'Content-Type' => 'application/json' })
  response
end
