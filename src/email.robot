*** Variables ***
${button_next}          //*[contains(@id, "Next")]
${field_login}          //input[@type="email"]
${field_password}       //input[@type="password"]


*** Keywords ***
email precondition
  [Arguments]  ${user}
  Open Browser  https://www.google.com/gmail/about/#  chrome  email
  eMail login  ${user}
  #Закрити валідаційне вікно в email  welcome_dialog_next
  #Закрити валідаційне вікно в email  ok


eMail login
  [Arguments]  ${user}
  Click Element  css=[data-g-label="Sign in"]
  Wait Until Page Contains Element  ${field_login}
  Wait Until Keyword Succeeds  20  2
  ...  Input Password  ${field_login}  ${users_variables["${user}"]["login"]}
  Click Element  ${button_next}
  Wait Until Page Contains Element  ${field_password}
  Wait Until Keyword Succeeds  20  2
  ...  Input Password  ${field_password}  ${users_variables["${user}"]["password"]}
  Click Element  ${button_next}
  #Run Keyword And Ignore Error  Click Element  //*[text()='Done' or text()='Готово']


Закрити валідаційне вікно в email
  [Arguments]  ${name}
  ${button}  Set Variable  //*[@name="${name}"]
  ${status}  Run Keyword And Return Status  Wait Until Page Contains Element  ${button}
  Run Keyword If  '${status}' == 'True'  Click Element  ${button}


Відкрити лист в email
    [Arguments]  ${text}
    Wait Until Page Contains Element  xpath=//*[@class='nH']  timeout=10s
    Click Element  xpath=//*[contains(text(),'${text}')]/../../..
    Wait Until Page Contains Element  xpath=//*[@class='Bu bAn']


Перейти за посиланням в листі
    [Arguments]  ${text}
    ${count}  Get Element Count  //img[@class='ajT']
    sleep  0.5
    Run Keyword If  ${count} > 0  Click Element  xpath=(//img[@class='ajT'])[last()]
    Click Element  partial link=${text}
