*** Keywords ***
Натиснути кнопку Особистий кабінет
    ${selector}  Set Variable  //a[text()="Особистий кабінет"]
    Click element  ${selector}
    Wait Until Page Does Not Contain Element  ${selector}