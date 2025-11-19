*** Settings ***
Test Tags   get
Library     RequestsLibrary
Resource    ../Resources/requests/get_order.robot
Resource    ../Resources/asserts/assert_get_order.robot

*** Test Cases ***
Cenário: Realizar pesquisa de pedido de venda

    ${response}  request.get.orders 
    ...  order_id=1
    ...  status_code=200

    asserts.get.orders
    ...  response=${response}

Cenário: Realizar pesquisa de pedido de venda inexistente

    ${response}  request.get.orders 
    ...  order_id=999
    ...  status_code=404

    asserts.get.orders
    ...  response=${response}