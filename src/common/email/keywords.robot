*** Variables ***
${button_next}          //*[contains(@id, "Next")]
${field_login}          //input[@type="email"]
${field_password}       //input[@type="password"]


*** Keywords ***
eMail login
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


Закрити валідаційне вікно в email
	[Arguments]  ${name}
	${button}  Set Variable  //*[@name="${name}"]
	${status}  Run Keyword And Return Status  Wait Until Page Contains Element  ${button}  2
	Run Keyword If  '${status}' == 'True'  Click Element  ${button}


Перевірити наявність листа
	[Arguments]  ${text}
	${time now}  smart_get_time  0  h
	${time}  Get Text  //*[@class='xW xY ']
	${is}  compare_dates_smarttender  ${time now}  >=  ${time}
	Should Be Equal  ${is}  ${True}
	${is}  Get Text  //*[@class='Cp']//tr
	Should Contain  ${is}  ${text}  AND