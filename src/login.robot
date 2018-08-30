*** Settings ***
Library     service.py


*** Variables ***
${login link}                       id=SignIn
${events}                           xpath=//*[@id="LoginDiv"]//a[2]
${login button}                     xpath=//*[@id="loginForm"]/button[2]
${login field}                      id=login
${password field}                   id=password
${prompt window}                    xpath=//*[contains(@class,'notification-popover')]
${close promt}                      xpath=//*[contains(@class, 'notification-prompt') and text()='Запретить']

*** Keywords ***
Login
  [Arguments]  ${login}  ${password}
  Закрити вспливаюче вікно про повідомлення
  Відкрити вікно авторизації
  Авторизуватися  ${login}  ${password}
  Перевірити успішність авторизації


Відкрити вікно авторизації
  Click Element  ${events}
  Click Element  ${login link}
  Sleep  2


Авторизуватися
  [Arguments]  ${login}  ${password}
  Fill Login  ${login}
  Fill Password  ${password}
  Click Element  ${login button}
  Run Keyword If  '${role}' == 'Bened'
  ...       Wait Until Element Is Not Visible  ${webClient loading}  120
  ...  ELSE  Run Keywords
  ...       Run Keyword And Ignore Error  Wait Until Page Contains Element  ${loading}
  ...  AND  Run Keyword And Ignore Error  Wait Until Page Does Not Contain Element  ${loading}  120


Перевірити успішність авторизації
  ${status}  Run Keyword And Return Status  Location Should Contain  /webclient/
  Run Keyword If  '${status}' == 'True'  Перевірити успішність авторизації організатора
  ...  ELSE  Перевірити успішність авторизації учасника


Перевірити успішність авторизації організатора
  Wait Until Page Does Not Contain Element  ${login button}
  Wait Until Page Contains Element  css=.body-container #container  120


Перевірити успішність авторизації учасника
  Wait Until Page Does Not Contain Element  ${login button}
  Wait Until Page Contains  ${name}  10
  Go To  ${start_page}


Fill login
  [Arguments]  ${user}
  Input Password  ${login field}  ${user}


Fill password
  [Arguments]  ${pass}
  Input Password  ${password field}  ${pass}


Закрити вспливаюче вікно про повідомлення
  Run Keyword And Ignore Error  Wait Until Element Is Visible  ${promt window}  10
  Run Keyword And Ignore Error  Click Element  ${close promt}
  Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${promt window}  10
