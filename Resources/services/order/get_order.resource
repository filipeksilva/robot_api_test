*** Settings ***
Resource   ../../../base.resource

*** Keywords ***
Request Get Orders
    [Arguments]
    ...  ${order_id}
    ...  ${status_code}
    [Return]  
    ...  ${response}
    
    ${alias}  Create Orders Session

    ${headers}  Create Dictionary  robot=True

    ${response}    GET On Session
    ...  alias=${alias}
    ...  url=/posts/${order_id}
    ...  headers=${headers}
    ...  expected_status=${status_code}
    ...  msg=Falha ao realizar requisição GET
    
Assert Get Orders
    [Arguments]  
    ...  ${response}

    IF    ${response.status_code} == ${200}
        Should Be Equal As Numbers    ${response.json()['userId']}   1
        Should Be Equal As Numbers    ${response.json()['id']}       1
        Should Be Equal As Strings    ${response.json()['title']}    sunt aut facere repellat provident occaecati excepturi optio reprehenderit
        Should Be Equal As Strings    ${response.json()['body']}     quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto
    ELSE IF    ${response.status_code} == ${404}
        Should Be Empty    ${response.json()}
    END