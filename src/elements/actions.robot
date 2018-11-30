*** Keywords ***
Створити словник
    [Arguments]  ${name}
    ${dict}  Create Dictionary
    Set Global Variable  ${${name}}  ${dict}