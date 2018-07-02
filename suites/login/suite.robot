*** Settings ***
Resource        ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot

*** Variables ***
${forgot password locator}                  xpath=//*[@id="loginForm"]/h5/a
${forgot password link}                     http://test.smarttender.biz/vidnovlennya-parolyu/
${registration locator}                     xpath=//*[@id="login-modal"]//div[2]/p/a
${registration link}                        http://test.smarttender.biz/reestratsiya/


*** Test Cases ***
Залогінитися
    [Tags]  Main
    Set role variable  user1
    Login  user1
    Go To  ${start page}
    Reload and check

prepearing for next step
    Click Element  ${logout}
    Click Element  ${events}
    Click Element  ${login link}
    Wait Until Page Contains Element  ${login field}  5

Спроба залогінитися з невірними даними
    [Tags]  Main
    [Template]  Login with wrong data
    user1  user2
    user2  empty
    wrong user  user1
    wrong user  wrong user
    empty  user2
    empty  empty
    deleted  deleted
    deleted  user1
    user2  deleted
    deleted  empty
    empty  deleted

Перевірити лінки
    ${a}=  Get Element Attribute  ${forgot password locator}  href
    should be equal  ${a}  ${forgot password link}
    ${a}=  Get Element Attribute  ${registration locator}  href
    should be equal  ${a}  ${registration link}

Залогінитися та перевірити користувача
    [Tags]  Main  Dimon
    Go To  ${start page}
    Login  user1
    Reload and check

Комерційні торги
    [Tags]  Main  Dimon
    Go To  ${start page}
    Reload and check
    Click Element  ${komertsiyni-torgy icon}
    Reload and check
    Open button  ${first element find tender}
    Reload and check

Державні закупківлі
    [Tags]  Main  Dimon
    Go To  ${start page}
    Reload and check
    Click Element  ${komertsiyni-torgy icon}
    Reload and check
    Click Element  ${derzavni zakupku}
    Reload and check
    Open Button  ${first element find tender}
    Reload And Check
    Go To  ${start page}
    Reload and check

*** Keywords ***
Precondition
    Start
    ${name}=  get_user_variable  user1  name
    set global variable  ${name}

Postcondition
    close all browsers

Login with wrong data
    [Arguments]  ${name1}  ${name2}
    sleep  .2
    ${login}=  get_user_variable  ${name1}  login
    Fill login  ${login}
    ${password}=  get_user_variable  ${name2}  password
    Fill password  ${password}
    Click Element  ${login button}
    Wait Until Page Contains Element  ${error}  5

Reload and check
    Reload Page
    Wait Until Page Contains  ${name}  10

Set role variable
  [Arguments]  ${user}
  ${role}  Set Variable  ${user}
  Set Global variable  ${role}