*** Settings ***
Test Tags   get
Resource    ../base.resource

*** Test Cases ***
Cenário: Realizar busca de pedido de venda

    ${response}  Request Get Orders 
    ...  order_id=1
    ...  status_code=200

    Assert Get Orders
    ...  response=${response}

Cenário: Realizar busca de pedido de venda inexistente

    ${response}  Request Get Orders
    ...  order_id=999
    ...  status_code=404

    Assert Get Orders
    ...  response=${response}