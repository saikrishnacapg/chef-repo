uuid=['71b509bb-4052-4541-84a8-a4c35118886f','e2686b82-f8d7-436e-b4cc-cfae132d5fa0']

uuid.each do |uid|
value=catalogaction "running #{uid}"  do
  uuid "#{uid}"
  action :create
end
puts value
end

