require 'base64'
require "net/http"
require "uri"
require 'restclient'

#==================================================
#make rest app call to fetch the mintcatalog uuid's
#==================================================

result=RestClient::Request.execute(method: :get, user: "l2007", password: "Sahasra14$", url: "https://ocloud-mintpress.wpdev.mintpress.io/REST/ServiceCatalog/list?verbose=true", payload: '', headers: {'Content-Type' => 'application/json' })

#parse the json to fetch uuid for specific environment
parsed = JSON.parse(result)
parsed.each do |element|
if element["launchDetails"]["environment"]["name"].include?("eng2")
puts
#puts "UUID #{element["uuid"]} and #{element["launchDetails"]["providersToServiceCatalogItems"][0]["serviceCatalogItems"][0]["code"]}"
if ["OBPOBH","OBPOBU","OBPCOMP"].include?element["launchDetails"]["providersToServiceCatalogItems"][0]["serviceCatalogItems"][0]["code"]
    uuid=element["uuid"]
    puts "UUID #{element["uuid"]} and #{element["launchDetails"]["providersToServiceCatalogItems"][0]["serviceCatalogItems"][0]["code"]}"
    response=%x{curl -s -k -u l2007:Sahasra14$ -X POST -H "Content-Type: application/json" -d '{"uuid": #{uuid}, "actionCode": "uploadonly", "ignoreInitialState": "false"}' https://ocloud-mintpress.wpdev.mintpress.io/REST/ServiceCatalog/performAction}
    puts response
end
end
end
Chef::Log.info "Processing Json #{processJson("/tmp/test1.json")}"
