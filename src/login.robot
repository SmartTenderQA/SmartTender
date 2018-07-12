*** Variables ***
${login link}                       id=SignIn
${events}                           xpath=//*[@id="LoginDiv"]//a[2]
${login button}                     xpath=//*[@id="loginForm"]/button[2]
${login field}                      id=login
${password field}                   id=password

*** Keywords ***
Login
  [Arguments]  ${user}
  Відкрити вікно авторизації
  Авторизуватися  ${user}
  Перевірити успішність авторизації  ${user}


Відкрити вікно авторизації
  Click Element  ${events}
  Click Element  ${login link}
  Sleep  2


Авторизуватися
  [Arguments]  ${user}
  ${login}=  get_user_variable  ${user}  login
  ${password}=  get_user_variable  ${user}  password
  Fill Login  ${login}
  Fill Password  ${password}
  Click Element  ${login button}
  Run Keyword If  '${role}' == 'Bened'
  ...       Wait Until Element Is Not Visible  ${webClient loading}  120
  ...  ELSE  Run Keywords
  ...       Run Keyword And Ignore Error  Wait Until Page Contains Element  ${loading}
  ...  AND  Run Keyword And Ignore Error  Wait Until Page Does Not Contain Element  ${loading}  120


Перевірити успішність авторизації
  [Arguments]  ${user}
  ${status}  Run Keyword And Return Status  Location Should Contain  /webclient/
  Run Keyword If  '${status}' == 'True'  Перевірити успішність авторизації організатора
  ...  ELSE  Перевірити успішність авторизації учасника  ${user}


Перевірити успішність авторизації організатора
  Wait Until Page Does Not Contain Element  ${login button}
  Wait Until Page Contains Element  css=.body-container #container  120


Перевірити успішність авторизації учасника
  [Arguments]  ${user}
  Wait Until Page Does Not Contain Element  ${login button}
  ${name}=  get_user_variable  ${user}  name
  Set Global Variable  ${name}
  Wait Until Page Contains  ${name}  10
  Go To  ${start_page}


Fill login
  [Arguments]  ${user}
  Input Password  ${login field}  ${user}


Fill password
  [Arguments]  ${pass}
  Input Password  ${password field}  ${pass}
