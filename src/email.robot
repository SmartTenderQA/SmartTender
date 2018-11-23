*** Variables ***
${button_next}          //*[contains(@id, "Next")]
${field_login}          //input[@type="email"]
${field_password}       //input[@type="password"]


*** Keywords ***
Розпочати роботу з Gmail
  [Arguments]  ${user}
  Open Browser  https://www.google.com/gmail/about/#  chrome  email
  Авторизуватися в Gmail  ${user}
  Закрити валідаційне вікно (за необходністю)


Авторизуватися в Gmail
  [Arguments]  ${user}
  Click Element  css=[data-g-label="Sign in"]
  Wait Until Page Contains Element  ${field_login}
  Wait Until Keyword Succeeds  20  2
  ...  Input Password  ${field_login}  ${users_variables["${user}"]["login"]}
  Click Element  ${button_next}
  Wait Until Page Contains Element  ${field_password}
  Wait Until Keyword Succeeds  20  2
  ...  Input Password  ${field_password}  ${users_variables["${user}"]["mail_password"]}
  Click Element  ${button_next}
  sleep  0.5
  Run Keyword And Ignore Error  Click Element  //*[text()='Done' or text()='Готово']


Закрити валідаційне вікно (за необходністю)
  Wait Until Page Contains Element  xpath=//*[@class='nH']  timeout=10s
  Run Keyword And Ignore Error  Закрити валідаційне вікно в email  welcome_dialog_next
  Run Keyword And Ignore Error  Закрити валідаційне вікно в email  ok


Закрити валідаційне вікно в email
  [Arguments]  ${name}
  ${button}  Set Variable  //*[@name="${name}"]
  ${status}  Run Keyword And Return Status  Wait Until Page Contains Element  ${button}  2
  Run Keyword If  '${status}' == 'True'  Click Element  ${button}


Перевірити наявність листа за темою
  [Arguments]  ${title}
  ${time now -1 min}  Evaluate  '{:%H:%M}'.format(datetime.datetime.now() + datetime.timedelta(minutes=-1))  modules=datetime
  ${time is}  Get Text  //*[@class='xW xY ']
  ${time}  compare_dates_smarttender  ${time now -1 min}  <=  ${time is}
  Should Be Equal  ${time}  ${True}
  ${title is}  Get Text  //*[@class='Cp']//tr
  Should Contain  ${title is}  ${title}


Відкрити лист в email за темою
  [Arguments]  ${title}
  Wait Until Keyword Succeeds  5 min  3 s  Перевірити наявність листа за темою  ${title}
  Click Element  xpath=//td[@id]//span[contains(text(), '${title}')]
  Wait Until Page Contains Element  xpath=//*[@class='Bu bAn']


Розгорнути останній лист (за необхідність)
  ${count}  Get Element Count  //img[@class='ajT']
  sleep  0.5
  Run Keyword If  ${count} > 0  Click Element  xpath=(//img[@class='ajT'])[last()]
  sleep  1


Перейти за посиланням в листі
  [Arguments]  ${title}
  Розгорнути останній лист (за необхідність)
  Click Element  xpath=//a[contains(text(),'Відновити пароль→')]
  Select Window  New
  sleep  0.5


Перевірити вкладений файл за назвою
  [Arguments]  ${should}  ${title}
  Click Element  //a[contains(., '${title}')]
  ${text}  Evaluate  str(${should})
  Wait Until Page Contains  ${text}  10