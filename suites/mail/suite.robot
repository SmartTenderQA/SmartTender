*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Provided precondition
Suite Teardown  Suite Postcondition
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${button_next}          //*[text()='Next']
${field_login}          //input[@type="email"]
${field_password}       //input[@type="password"]

*** Test Cases ***
123213
    Click Element  //b[contains(text(), "SmartTender") and contains(text(), "Розпочато моніторінг ДАСУ") and contains(text(), "1866848")]


*** Keywords ***
Provided precondition
    Open Browser  https://www.google.com/gmail/about/#  chrome
    Login


Login
    ${login}  get_user_variable  user1  login
    ${password}  get_user_variable  user1  mail_password
    Input Text  ${field_login}  ${login}
    Click Element  ${button_next}
    Input Text  ${field_login}  ${password}
    Click Element  ${button_next}
    Click Element  //*[text()='Done']