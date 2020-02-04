file '/tmp/sai' do
  content "This is my file"
  owner "osboxes"
  group "osboxes" 
  verify do |path|
    open(path).read.include? "file"
  end
end


git '/tmp/couch' do
  repository 'git://github.com/saikrishnacapg/chef-repo.git'
  revision 'master'
  action :sync
end
