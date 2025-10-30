require 'httparty'
require_relative '../../lib/utils/app_logger'
require_relative '../../lib/FTTH/HSI/hsi_request'
require 'test/unit'
include Test::Unit::Assertions


When(/^client sends an (ADD|DEL|UPDATE) "([^"]*)" (GET|POST|PUT|DELETE|PATCH) request to "(.*)" with parameters$/) do |operacao, srv, method, path, *args |
  table = args.first
  case srv
  when "HSI"

    template = table.hashes[0]['template_name'] if table
    template = template != nil ? template + '.json' : 'service_order_hsi.json'

    # Instancia a classe e carrega o arquivo json
    @hsi = HSI_Request.new(template)
    @hsi.hsi_services(table, path, operacao, srv)
  else
    raise("The provided service is not supported: #{srv}")
  end

end

Then("the response should match the request payload") do

  # puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  # puts Gem.loaded_specs['test-unit'].version
  # puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

  # response_body = JSON.parse(@response.body)
  request_body = @hsi.json_request_payload
  response_body = JSON.parse(@hsi.json_response_payload.body)

  # State
  assert_equal("Acknowledged", response_body["state"])

  # externalId??

  # category
  assert_equal(request_body["category"], response_body["category"])
  assert_equal(request_body["requesterCallback"], response_body["requesterCallback"])

  # orderDate
  assert_equal(request_body["orderDate"].to_s, response_body["orderDate"])

  # requesterCallback
  assert_equal(request_body["requesterCallback"], response_body["requesterCallback"])

  # orderItem[0].id
  assert_equal(request_body["orderItem"][0]["id"], response_body["orderItem"][0]["id"])

  # action
  assert_equal(request_body["orderItem"][0]["action"].to_s, response_body["orderItem"][0]["action"])

  # serviceSpecification.id
  assert_equal(request_body["orderItem"][0]["serviceSpecification"]["id"], response_body["orderItem"][0]["serviceSpecification"]["id"])

  # service.id
  assert_equal(request_body["orderItem"][0]["service"]["id"].to_s, response_body["orderItem"][0]["service"]["id"])

  # service.category
  assert_equal(request_body["orderItem"][0]["service"]["category"].to_s, response_body["orderItem"][0]["service"]["category"])

  # Check some serviceCharacteristics (match by name)
  req_chars = request_body["orderItem"][0]["service"]["serviceCharacteristic"]
  res_chars = response_body["orderItem"][0]["service"]["serviceCharacteristic"]

  req_chars.each do |req_char|
    # Only validate the ones that exist in the response
    res_match = res_chars.find { |rc| rc["name"] == req_char["name"] }
    arr_elements = ["relatedServiceIdentifier", "serviceIdentifier"]
    if !arr_elements.include?(req_char["name"])
      if res_match
        assert_equal(req_char["value"].to_s, res_match["value"])
      end
    end
  end

  # Check place properties
  req_place = request_body["orderItem"][0]["service"]["place"]
  if req_place and req_place.size > 0
    req_place = req_place.first
    res_place = response_body["orderItem"][0]["service"]["place"].first
    req_role = req_place["role"]
    res_role = res_place["role"]
    assert_equal(req_role, res_role) if req_role

    req_place = req_place["property"]
    res_place = res_place["property"]

    req_place.each do |prop|

      res_prop = res_place.find { |p| p["name"] == prop["name"] }
      if res_prop
        # expect(res_prop["value"]).to eq(prop["value"])
        assert_equal(prop["value"].to_s, res_prop["value"])
      end
    end
  end

end

Then("the response should match the request payload list errors") do
  list_erros = []
  # response_body = JSON.parse(@response.body)
  request_body = @hsi.json_request_payload
  response_body = JSON.parse(@hsi.json_response_payload.body)

  # State
  list_erros << "Expected value: Acknowledged Got: #{response_body["state"]}" if "Acknowledged" != response_body["state"]

  # externalId??

  # category
  req_category = request_body["category"]
  resp_category = response_body["category"]
  list_erros << "Expected value: #{req_category} Got: #{resp_category}" if req_category and req_category != resp_category
  # orderDate
  req_order_date = request_body["orderDate"].to_s
  resp_order_date = response_body["orderDate"]
  list_erros << "Expected value: #{req_order_date} Got: #{resp_order_date}" if req_order_date and req_order_date != resp_order_date

  # requesterCallback
  req_requester_callback = request_body["requesterCallback"]
  resp_requester_callback = response_body["requesterCallback"]
  list_erros << "Expected value: #{req_requester_callback} Got: #{resp_requester_callback}" if req_requester_callback != resp_requester_callback

  # orderItem[0].id
  req_order_item_id = request_body["orderItem"][0]["id"]
  resp_order_item_id = response_body["orderItem"][0]["id"]
  list_erros << "Expected value: #{req_order_item_id} Got: #{resp_order_item_id}" if req_order_item_id and req_order_item_id != resp_order_item_id

  # action
  req_action = request_body["orderItem"][0]["action"].to_s
  resp_action = response_body["orderItem"][0]["action"]
  list_erros << "Expected value: #{req_action} Got: #{resp_action}" if req_action != resp_action

  # serviceSpecification.id
  req_service_specification = request_body["orderItem"][0]["serviceSpecification"]["id"]
  resp_service_specification = response_body["orderItem"][0]["serviceSpecification"]["id"]
  list_erros << "Expected value: #{req_service_specification} Got: #{resp_service_specification}" if req_service_specification != resp_service_specification

  # service.id
  req_service_id = request_body["orderItem"][0]["service"]["id"].to_s
  resp_service_id = response_body["orderItem"][0]["service"]["id"]
  list_erros << "Expected value: #{req_service_id} Got: #{resp_service_id}" if req_service_id != resp_service_id

  # service.category
  req_service_category = request_body["orderItem"][0]["service"]["category"].to_s
  resp_service_category = response_body["orderItem"][0]["service"]["category"]
  list_erros << "Expected value: #{req_service_category} Got: #{resp_service_category}" if req_service_category != resp_service_category

  # Check some serviceCharacteristics (match by name)
  req_chars = request_body["orderItem"][0]["service"]["serviceCharacteristic"]
  res_chars = response_body["orderItem"][0]["service"]["serviceCharacteristic"]

  req_chars.each do |req_char|
    # Only validate the ones that exist in the response
    res_match = res_chars.find { |rc| rc["name"] == req_char["name"] }
    arr_elements = ["relatedServiceIdentifier", "serviceIdentifier"]
    if !arr_elements.include?(req_char["name"])
      if res_match
        list_erros << "Expected value: #{req_char["value"].to_s} Got: #{res_match["value"]}" if req_char["value"].to_s != res_match["value"]
      end
    end
  end

  # Check place properties
  if request_body["orderItem"][0]["service"]["place"].size > 0
    req_place = request_body["orderItem"][0]["service"]["place"].first
    res_place = response_body["orderItem"][0]["service"]["place"].first
    req_role = req_place["role"]
    res_role = res_place["role"]
    list_erros << "Expected value: #{req_role} Got: #{res_role}" if req_role and req_role != res_role

    req_place = req_place["property"]
    res_place = res_place["property"]

    req_place.each do |prop|
      res_prop = res_place.find { |p| p["name"] == prop["name"] }
      if res_prop
        list_erros << "Expected value: #{prop["value"].to_s} Got: #{res_prop["value"]}" if prop["value"].to_s != res_prop["value"]
      end
    end
  end

  if list_erros.size > 0
    AppLogger.error('xxxxxxxxxxx - Errors List - xxxxxxxxxxx')
    list_erros.each do |error|
      AppLogger.error(error)
    end
    AppLogger.error("xxxxxxxxxxx - Errors List - xxxxxxxxxxx")
    raise("Validation failed: one or more errors occurred!")
  end

end

Then("print the updated JSON") do
  puts "xxxxxxxxxxxxxxxxxxxxx - request - xxxxxxxxxxxxxxxxxxxxxxxx"
  puts JSON.pretty_generate(@hsi.json_request_payload)

  print("")
  puts "xxxxxxxxxxxxxxxxxxxxx - response - xxxxxxxxxxxxxxxxxxxxxxxx"
  resp_json = JSON.parse(@hsi.json_response_payload.response.body)
  puts JSON.pretty_generate(resp_json)

end
