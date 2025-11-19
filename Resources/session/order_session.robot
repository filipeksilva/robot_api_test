*** Settings ***
Library    RequestsLibrary

*** Keywords ***
session.orders
    [Return]
    ...  ${alias}    

    ${alias}  Set Variable  orders    

    ${headers}  Create Dictionary  user_id=user_1
    ${cookies}  Create Dictionary  _id=1234
    ${auth}  Create List  test_user@robot.com  psw123
    
    Create Session    
    ...    alias=${alias}
    ...    url=https://jsonplaceholder.typicode.com
    ...    disable_warnings=${True}
    ...    headers=${headers}
    ...    cookies=${cookies}
    ...    auth=${auth}