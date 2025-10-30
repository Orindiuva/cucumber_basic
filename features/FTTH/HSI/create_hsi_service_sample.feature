Feature: Create HSI Service Sample

  # Duvidas:
  # No campo externalId, o que é o atributo signature e service_id?
  # * externalId": "ADD_HSI_{{signature}}_{{service_id}}
  # O parametro: requesterCallback sempre é informado? Esta com valor fixo no arquivo JSON.

  @HSI_1
  Scenario: ADD HSI Service - 1

    Given client sends an ADD "HSI" POST request to "/mock-hs1" with parameters
      | path                                                                      | value                    |
      | category                                                                  | SALES_NEW                |
      | orderItem[0].id                                                           | sftth-NEW                |
      | orderItem[0].service.serviceCharacteristic[name=relatedServiceIdentifier] | SI{{service_id}}         |
      | orderItem[0].service.serviceCharacteristic[name=downloadSpeed]            | 100                      |
      | orderItem[0].service.serviceCharacteristic[name=uploadSpeed]              | 50                       |
      | orderItem[0].service.serviceCharacteristic[name=serviceProfile]           | UZO                      |
      | orderItem[0].service.place[0].role                                        | installation address tst |
      | orderItem[0].service.place[0].property[name=polarisAddressType]           | NEW_TYPE                 |
      | orderItem[0].service.place[0].property[name=designation]                  | TV                       |
      | orderItem[0].service.place[0].property[name=streetName]                   | Fonte                    |
      | orderItem[0].service.place[0].property[name=doorNumber]                   | 2                        |
    Then the response should match the request payload
    Then print the updated JSON


  #Permite setar com um array vazio
  @HSI_2
  Scenario: ADD HSI Service - 2

    Given client sends an ADD "HSI" POST request to "/mock-hs1" with parameters
      | path                                                            | value     |
      | category                                                        | SALES_NEW |
      | orderItem[0].id                                                 | sftth-NEW |
      | orderItem[0].service.serviceCharacteristic[name=downloadSpeed]  | 100       |
      | orderItem[0].service.serviceCharacteristic[name=uploadSpeed]    | 50        |
      | orderItem[0].service.serviceCharacteristic[name=serviceProfile] | UZO       |
      | orderItem[0].service.serviceCharacteristic[name=xpto]           | xpto      |
      | orderItem[0].service.place                                      | []        |
    Then the response should match the request payload
    Then print the updated JSON

  @HSI_3
  Scenario: ADD HSI Service - 3
    Given client sends an ADD "HSI" POST request to "/mock-hs1" with parameters
      | path                       | value     |
      | category                   | SALES_NEW |
      | orderItem[0].id            | sftth-NEW |
      | orderItem[0].service.place | []        |
    Then the response should match the request payload
    Then print the updated JSON


  #@HSI_4
  #Step esperado com erro: <"SALES_ORDER"> expected but was <"SALES_NEW">
  #Ocorre pq passo o json sem alteracoes
#  Scenario: ADD HSI Service - 4
#    Given client sends an ADD "HSI" POST request to "/mock-hs1" with parameters
#      | path                                                               | value        |
#      | orderItem[0].service.place                                         | []           |
#    Then print the updated JSON
#    Then the response should match the request payload

  @HSI_5
  Scenario: ADD HSI Service - 5

    Given client sends an ADD "HSI" POST request to "/mock-hs1" with parameters
      | path                                                                      | value                 |
      | category                                                                  | SALES_NEWx            |
      | orderItem[0].id                                                           | sftth-NEWx            |
      | orderItem[0].service.serviceCharacteristic[name=relatedServiceIdentifier] | SI{{service_id}}      |
      | orderItem[0].service.serviceCharacteristic[name=downloadSpeed]            | 100x                  |
      | orderItem[0].service.serviceCharacteristic[name=uploadSpeed]              | 50x                   |
      | orderItem[0].service.serviceCharacteristic[name=serviceProfile]           | UZOx                  |
      | orderItem[0].service.place[0].role                                        | installation addressx |
      | orderItem[0].service.place[0].property[name=addressId]                    | xABC                  |
      | orderItem[0].service.place[0].property[name=addressPolarisId]             | PKX                   |
      | orderItem[0].service.place[0].property[name=polarisAddressType]           | NEW_TYPEX             |
    Then the response should match the request payload list errors

  @HSI_6
  Scenario: ADD HSI Service - 6
    Given client sends an ADD "HSI" POST request to "/mock-hs1" with parameters
    Then print the updated JSON

  @HSI_7
  Scenario: ADD HSI Service - 7
    Given client sends an ADD "HSI" POST request to "/mock-hs1" with parameters
      | template_name               |
      | service_order_hsi_parameter |
    Then print the updated JSON

  @HSI_8
  Scenario: ADD HSI Service - 8
    Given client sends an ADD "HSI" POST request to "/mock-hs1" with parameters
      | template_name               | path                                                                      | value            |
      | service_order_hsi_parameter | category                                                                  | SALES_NEW        |
      |                             | orderItem[0].id                                                           | sftth-NEW        |
      |                             | orderItem[0].service.serviceCharacteristic[name=relatedServiceIdentifier] | SI{{service_id}} |
      |                             | orderItem[0].service.serviceCharacteristic[name=downloadSpeed]            | 100              |
      |                             | orderItem[0].service.serviceCharacteristic[name=uploadSpeed]              | 50               |
      |                             | orderItem[0].service.serviceCharacteristic[name=serviceProfile]           | UZO              |
    Then the response should match the request payload
    Then print the updated JSON

