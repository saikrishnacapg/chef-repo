require 'json'
res=%x{curl -k -s -u l2007:Sahasra14$ https://ocloud-mintpress.wpdev.mintpress.io/runtime/rest/api/latest/result/ORCHESTRATIONE2686B82F8D7436EB4CCCFAE132D5FA0-ORCHESTRATIONCUSTOMACTION-10.json}
parsed=JSON.parse(res)
for i in 1..17 do
res=%x{curl -k -s -u l2007:Sahasra14$ https://ocloud-mintpress.wpdev.mintpress.io/runtime/rest/api/latest/result/ORCHESTRATIONE2686B82F8D7436EB4CCCFAE132D5FA0-ORCHESTRATIONCUSTOMACTION-#{i}.json}

parsed=JSON.parse(res)
if i == 7 
#pp res
end
puts "#{parsed["buildState"]} state -> #{parsed["state"]} finished -> #{parsed["finished"]} successful #{parsed["successful"]} lifeCycleState -> #{parsed["lifeCycleState"]} notRunYet -> #{parsed["notRunYet"]}"
puts("Build state and State of the Job #{parsed["key"]} -> #{parsed["state"]} == #{parsed["buildState"]} time taken for execution is as follows #{parsed["buildDurationInSeconds"]/60} mins and #{parsed["buildDurationInSeconds"]%60} secs")
end
