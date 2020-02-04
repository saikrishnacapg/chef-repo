file '/tmp/sai' do
  content "This is my file"
  owner "osboxes"
  group "osboxes" 
  verify do |path|
    open(path).read.include? "file"
  end
end
