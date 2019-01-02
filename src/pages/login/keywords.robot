*** Settings ***
Resource  	  ../../common/loading/loading.robot

*** Variables ***
${login link}                       id=SignIn
${login button}                     xpath=//*[@id="loginForm"]/button[2]
${login field}                      id=login
${password field}                   id=password
${prompt window}                    xpath=//*[contains(@class,'notification-popover')]
${close promt}                      xpath=//*[contains(@class, 'notification-prompt') and text()='Запретить']


*** Keywords ***
Відкрити вікно авторизації
  Відкрити сторінку Заходи SmartTender
  Click Element  ${login link}
  Sleep  2


#####################################################################
Login
  [Arguments]  ${login}  ${password}
  Fill Login  ${login}
  Fill Password  ${password}
  Click Element  ${login button}
  Дочекатись закінчення загрузки сторінки
  Run Keyword If  "tender_owner" == "${role}"
  ...        Дочекатись закінчення загрузки сторінки(webclient)


Fill login
  [Arguments]  ${user}
  Input Password  ${login field}  ${user}


Fill password
  [Arguments]  ${pass}
  Input Password  ${password field}  ${pass}


#####################################################################
Перевірити успішність авторизації
  Run Keyword If
  ...  "viewer" == "${role}"  No Operation  ELSE IF
  ...  ${fast_login} == ${True}  No Operation  ELSE IF
  ...  "tender_owner" == "${role}"  Перевірити успішність авторизації організатора  ELSE IF
  ...  "provider" in "${role}" or 'ssp_tender_owner' == '${role}'  Перевірити успішність авторизації учасника


Перевірити успішність авторизації учасника
	Wait Until Page Does Not Contain Element  ${login button}
	Wait Until Page Contains  ${name}  10
	Go To  ${start_page}


Перевірити успішність авторизації організатора
	Wait Until Page Does Not Contain Element  ${login button}  120
	Wait Until Page Contains Element  css=.body-container #container
#	Закрити вікно Виберіть об`єкт


Закрити вікно Виберіть об`єкт
	Click Element  //a[@title="Вибір(Enter)"]
	Дочекатись закінчення загрузки сторінки(webclient)

