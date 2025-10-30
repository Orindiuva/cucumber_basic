require 'webrick'
require 'json'

# Create the server
server = WEBrick::HTTPServer.new(Port: 4567)


#######################
# HSI - SERVICE
#######################


server.mount_proc '/mock-hs1' do |req, res|
  raw_json = File.read('mock_service/mock_hsi/response_service_order_hsi.json')
  response_json = JSON.parse(raw_json)
  res['Content-Type'] = 'application/json'
  res.body = response_json.to_json
end

# Service A (GET)
server.mount_proc '/service_a/data' do |req, res|
  res['Content-Type'] = 'application/json'
  res.body = { message: "Response from Service A", status: "ok" }.to_json
end

# Service B (POST)
server.mount_proc '/service_b/submit' do |req, res|
  payload = req.body && req.body.size > 0 ? JSON.parse(req.body) : {}
  res['Content-Type'] = 'application/json'
  res.body = { message: "Received by Service B", payload: payload }.to_json
end

# Service C (GET with param)
server.mount_proc '/service_c' do |req, res|
  id = req.query["id"] || "none"
  res['Content-Type'] = 'application/json'
  res.body = { id: id, value: "Fake data from Service C" }.to_json
end

trap('INT') { server.shutdown }

server.start
