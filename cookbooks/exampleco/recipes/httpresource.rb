
file '/tmp/sai' do
  content "#{printdata()}"
  owner "osboxes"
  group "osboxes" 
#  verify do |path|
#    open(path).read.include? "file"
#  end
end

git '/tmp/couch' do
  repository 'git://github.com/saikrishnacapg/chef-repo.git'
  revision 'master'
  action :sync
end

def testdata()
  data="===============================This is new data==========================="
end

lazy {Chef::Log.info("#{testdata()}")}
