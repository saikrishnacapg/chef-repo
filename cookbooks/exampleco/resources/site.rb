resource_name :catalogaction
require 'json'
require 'base64'
require 'pp'
#property :homepage, String, default: '<h1>Hello world!</h1>'
property :filepath, String, default: 'tmp'
property :uuid, String, default:''

def printSaiName()
uuid=['71b509bb-4052-4541-84a8-a4c35118886f','e2686b82-f8d7-436e-b4cc-cfae132d5fa0']
puts uuid
end
runtimeUrl="https://ocloud-mintpress.wpdev.mintpress.io/runtime"
action :create do
   begin
    buildResultKey=""
    Chef::Log.info(printSaiName())
    Chef::Log.info "#{new_resource.filepath} #{new_resource.uuid}"
    performAction=%x{curl -s -k -u l2007:Sahasra14$ -X POST -H "Content-Type: application/json" -d '{"uuid": e2686b82-f8d7-436e-b4cc-cfae132d5fa0, "actionCode": "uploadonly", "ignoreInitialState": "false"}' https://ocloud-mintpress.wpdev.mintpress.io/REST/ServiceCatalog/performAction}
    Chef::Log.info("curl -s -k -u l2007:Sahasra14$ https://ocloud-mintpress.wpdev.mintpress.io/REST/ServiceCatalog/get?uuid=#{new_resource.uuid}")
    response=%x{curl -s -k -u l2007:Sahasra14$ https://ocloud-mintpress.wpdev.mintpress.io/REST/ServiceCatalog/get?uuid=e2686b82-f8d7-436e-b4cc-cfae132d5fa0}
    parsed=JSON.parse(response)

      if !parsed["launchDetails"]["providersToServiceCatalogItems"][0]["serviceCatalogItems"][0]["currentActionInvocation"].nil?
        buildResultKey=parsed["launchDetails"]["providersToServiceCatalogItems"][0]["serviceCatalogItems"][0]["currentActionInvocation"]["buildResultKey"]
        Chef::Log.info "Status of invoked action for UUID e2686b82-f8d7-436e-b4cc-cfae132d5fa0 is #{parsed["launchDetails"]["providersToServiceCatalogItems"][0]["serviceCatalogItems"][0]["currentActionInvocation"]}"
        while !parsed["launchDetails"]["providersToServiceCatalogItems"][0]["serviceCatalogItems"][0]["currentActionInvocation"].nil? do
          Chef::Log.info "Status of invoked action for UUID e2686b82-f8d7-436e-b4cc-cfae132d5fa0 is #{parsed["launchDetails"]["providersToServiceCatalogItems"][0]["serviceCatalogItems"][0]["currentActionInvocation"]["actionInvocationState"]}"
          Chef::Log.info "Waiting for 10 Secs to get the status"
          sleep 10
          response=%x{curl -s -k -u l2007:Sahasra14$ https://ocloud-mintpress.wpdev.mintpress.io/REST/ServiceCatalog/get?uuid=e2686b82-f8d7-436e-b4cc-cfae132d5fa0}
          parsed=JSON.parse(response)
        end
      end
     #Chef::Log.info "Outside of If Method curl -s -k -u l2007:Sahasra14$ https://ocloud-mintpress.wpdev.mintpress.io/runtime/rest/api/latest/result/#{buildResultKey}.json}" 
    uuid=parsed["uuid"]
    mintRTRes=%x{curl -s -k -u l2007:Sahasra14$ https://ocloud-mintpress.wpdev.mintpress.io/runtime/rest/api/latest/result/#{buildResultKey}.json}
    parsed=JSON.parse(mintRTRes)
    if parsed["buildState"].include?("Successful")
       Chef::Log.info "UUID is #{uuid} triggered Runtime Plan #{runtimeUrl}/#{buildResultKey} and the Job execution state is #{parsed["lifeCycleState"]} and Job status is #{parsed["buildState"]} time taken for execution #{parsed["buildDurationInSeconds"]/60} mins and #{parsed["buildDurationInSeconds"]%60} secs"
    else
       raise "UUID is #{uuid} triggered Runtime Plan #{runtimeUrl}/#{buildResultKey} and the Job execution state is #{parsed["lifeCycleState"]} and Job status is #{parsed["buildState"]} time taken for execution #{parsed["buildDurationInSeconds"]/60} mins and #{parsed["buildDurationInSeconds"]%60} secs"
    end
    #Chef::Log.info "Response is #{response}"
   end
end


