*** Variables ***
${button_next}          //*[contains(@id, "Next")]
${field_login}          //input[@type="email"]
${field_password}       //input[@type="password"]


*** Keywords ***
Email precondition
  Open Browser  https://www.google.com/gmail/about/#  chrome
  eMail login
  Закрити валідаційне вікно в email  welcome_dialog_next
  Закрити валідаційне вікно в email  ok


eMail login
  ${login}  get_user_variable  user1  login
  ${password}  get_user_variable  user1  mail_password
  Click Element  css=[data-g-label="Sign in"]
  Input Text  ${field_login}  ${login}
  Click Element  ${button_next}
  Input Text  ${field_password}  ${password}
  Click Element  ${button_next}
  Run Keyword And Ignore Error  Click Element  //*[text()='Done' or text()='Готово']


Закрити валідаційне вікно в email
  [Arguments]  ${name}
  ${button}  Set Variable  //*[@name="${name}"]
  ${status}  Run Keyword And Return Status  Wait Until Page Contains Element  ${button}
  Run Keyword If  '${status}' == 'True'  Click Element  ${button}
