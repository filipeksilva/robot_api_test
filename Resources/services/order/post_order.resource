*** Settings ***
Resource    ../../../base.resource

*** Variables ***
${env}

*** Keywords ***
Request Post Orders
    [Arguments]
    ...  ${order_id}
    ...  ${status}
    ...  ${items_product}
    ...  ${items_quantity}
    ...  ${items_price}
    ...  ${status_code}
    ...  ${customer_name}=${user_data.${env}.user_name}
    ...  ${customer_email}=${user_data.${env}.user_email}
    ...  ${shipping_address}=${True}   
    [Return]  ${response}


    IF    ${shipping_address}
        ${shipping_address_street}  Street Name
        ${shipping_address_city}  City
        ${shipping_address_zipcode}  Zipcode
    ELSE
        ${shipping_address_street}  Set Variable  ${EMPTY}
        ${shipping_address_city}  Set Variable  ${EMPTY}
        ${shipping_address_zipcode}  Set Variable  ${EMPTY}
    END

    ${items}  ${total_price}  Listing Items    
    ...    product=${items_product}    
    ...    quantity=${items_quantity}    
    ...    price=${items_price}

    ${body}  Body Post Orders
    ...    order_id=${order_id}
    ...    total_price=${total_price}
    ...    status=${status}
    ...    customer_name=${customer_name}
    ...    customer_email=${customer_email}
    ...    items=${items}
    ...    street=${shipping_address_street}
    ...    city=${shipping_address_city}
    ...    zipcode=${shipping_address_zipcode}
        
    Set Test Variable    ${body}

    ${alias}  Create Orders Session
    
    ${response}   POST On Session
    ...  alias=${alias}
    ...  url=/posts
    ...  json=${body}
    ...  expected_status=${status_code}
    ...  msg=Erro ao criar pedido de venda


Listing Items
    [Arguments]
    ...  ${product}
    ...  ${quantity}
    ...  ${price}
    [Return]
    ...  ${items_list}
    ...  ${total_price}

    
    ${items}  Load Json From File    ${CURDIR}/json/items_list.json
    ${items_list}  Create List

    FOR    ${l1-product}    ${l2-quantity}    ${l3-price}    IN ZIP    ${product}    ${quantity}    ${price}
        ${items}  Update Value To Json    ${items}    $.product     ${l1-product} 
        ${items}  Update Value To Json    ${items}    $.quantity    ${l2-quantity}
        ${items}  Update Value To Json    ${items}    $.price       ${l3-price}

        Append To List    ${items_list}  ${items}
    END

    ${total_price}  Evaluate    sum(int(item['quantity']) * int(item['price']) for item in ${items_list})


Body Post Orders  
    [Arguments]
    ...  ${order_id}
    ...  ${total_price}
    ...  ${status}
    ...  ${customer_name}
    ...  ${customer_email}
    ...  ${items}
    ...  ${street}
    ...  ${city}
    ...  ${zipcode}
    [Return]
    ...  ${body}

    ${body}  Load Json From File    ${CURDIR}/json/post_order.json

    ${body}  Update Value To Json    ${body}    $.order.order_id                    ${order_id}
    ${body}  Update Value To Json    ${body}    $.order.total_price                 ${total_price}
    ${body}  Update Value To Json    ${body}    $.order.status                      ${status}
    ${body}  Update Value To Json    ${body}    $.order.customer.name               ${customer_name}
    ${body}  Update Value To Json    ${body}    $.order.customer.email              ${customer_email}
    ${body}  Update Value To Json    ${body}    $.order.items                       ${items}
    ${body}  Update Value To Json    ${body}    $.order.shipping_address.street     ${street}
    ${body}  Update Value To Json    ${body}    $.order.shipping_address.city       ${city}
    ${body}  Update Value To Json    ${body}    $.order.shipping_address.zipcode    ${zipcode}

Assert Post Orders
    [Arguments]  
    ...  ${response}
    ...  ${products}

    Should Be Equal As Strings  ${response.json()["order"]["order_id"]}            ${body["order"]["order_id"]}
    Should Be Equal As Numbers  ${response.json()["order"]["total_price"]}         ${body["order"]["total_price"]}
    Should Be Equal As Strings  ${response.json()["order"]["status"]}              ${body["order"]["status"]}
    Should Be Equal As Strings  ${response.json()["order"]["customer"]["name"]}    ${body["order"]["customer"]["name"]}
    Should Be Equal As Strings  ${response.json()["order"]["customer"]["email"]}   ${body["order"]["customer"]["email"]}

    FOR    ${product}    IN    @{products}
        ${body_items}  Get Value From Json    ${body}    $.order.items[?(@.product=="${product}")]
        ${response_items}  Get Value From Json    ${response.json()}    $.order.items[?(@.product=="${product}")]
        
        Should Be Equal As Strings  ${response_items[0]["product"]}   ${body_items[0]["product"]}
        Should Be Equal As Strings  ${response_items[0]["quantity"]}  ${body_items[0]["quantity"]}
        Should Be Equal As Strings  ${response_items[0]["price"]}     ${body_items[0]["price"]}               
    END

    Should Be Equal As Strings  ${response.json()["order"]["shipping_address"]["street"]}   ${body["order"]["shipping_address"]["street"]}
    Should Be Equal As Strings  ${response.json()["order"]["shipping_address"]["city"]}     ${body["order"]["shipping_address"]["city"]}
    Should Be Equal As Strings  ${response.json()["order"]["shipping_address"]["zipcode"]}  ${body["order"]["shipping_address"]["zipcode"]}