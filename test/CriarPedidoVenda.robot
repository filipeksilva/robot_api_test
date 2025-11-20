*** Settings ***
Test Tags   order
Resource    ../base.resource

*** Test Cases ***
Cenário: Criar pedido de venda com um item com endereço

    @{product}  Create List  Product A
    @{quantity}  Create List  2
    @{price}  Create List  25
    
    ${response}  Request Post Orders
    ...    order_id=123456
    ...    status=Open
    ...    items_product=@{product}
    ...    items_quantity=@{quantity}
    ...    items_price=@{price}
    ...    status_code=201

    Assert Post Orders
    ...    response=${response}
    ...    products=@{product}

Cenário: Criar pedido de venda com um item sem endereço

    @{product}  Create List  Product A
    @{quantity}  Create List  ${2}
    @{price}  Create List  ${25}
    
    ${response}  Request Post Orders
    ...    order_id=123456
    ...    status=Open
    ...    items_product=@{product}
    ...    items_quantity=@{quantity}
    ...    items_price=@{price}
    ...    shipping_address=${False}
    ...    status_code=201

    Assert Post Orders
    ...    response=${response}
    ...    products=@{product}

Cenário: Criar pedido de venda com mais de um item
  
    @{product}  Create List  Product A  Product B  Product C
    @{quantity}  Create List  ${2}  ${3}  ${4}
    @{price}  Create List  ${25}  ${35}  ${45}

    ${response}  Request Post Orders
    ...    order_id=123456
    ...    status=Open
    ...    items_product=@{product}
    ...    items_quantity=@{quantity}
    ...    items_price=@{price}
    ...    status_code=201

    Assert Post Orders
    ...    response=${response}
    ...    products=@{product}