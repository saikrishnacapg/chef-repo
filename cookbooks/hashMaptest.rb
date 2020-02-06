data=Array.new(Array.new)
(1..5).each do |i|
count=1
if data[i].nil?
  data[i-1]=[]
end
while count<i+1
data[i-1]<<count
count=count+1
end
end
pp data

