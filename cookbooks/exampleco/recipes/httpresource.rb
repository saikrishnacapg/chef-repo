http_request 'getting http data' do
  action :get
  url 'https://ocloud-mintpress.wpdev.mintpress.io/REST/ServiceCatalog/list?verbose=true'
  #message ({:some => 'data'}.to_json)
  headers({'AUTHORIZATION' => "Basic #{
    Base64.encode64('l2007:Sahasra14$')}",
    'Content-Type' => 'application/json'
  })
end
