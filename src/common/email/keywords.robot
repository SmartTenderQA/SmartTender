*** Variables ***
${button_next}          //*[contains(@id, "Next")]
${field_login}          //input[@type="email"]
${field_password}       //input[@type="password"]


*** Keywords ***
Авторизуватися в Gmail
	[Arguments]  ${user}
	${sign in btn}  Set Variable  //div[@class="h-c-header__cta"]//a[contains(text(),'Sign in')]|//*[@data-g-label="Sign in"]
	elements.Дочекатися відображення елемента на сторінці  ${sign in btn}  15
	Open button  ${sign in btn}
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
	Run Keyword And Ignore Error  Відмовитись отримувати сповіщення в email


Закрити валідаційне вікно в email
	[Arguments]  ${name}
	${button}  Set Variable  //*[@name="${name}"]
	${status}  Run Keyword And Return Status  Wait Until Page Contains Element  ${button}  2
	Run Keyword If  '${status}' == 'True'  Click Element  ${button}


Відмовитись отримувати сповіщення в email
	${button}  Set Variable  //*[@id="link_enable_notifications_hide"]
	${status}  Run Keyword And Return Status  Wait Until Page Contains Element  ${button}  2
	Run Keyword If  '${status}' == 'True'  Click Element  ${button}


Перевірити наявність листа за темою
	[Arguments]  ${title}  ${time now -3 min}
	elements.Дочекатися зникнення елемента зі сторінки  //*[@class='msg' and contains(text(),'Завантаження Gmail')]  30
	${time selector}  Set Variable  //*[contains(text(),'${title}')]/ancestor::tr//*[@class='xW xY ']
	${time is}  Get Text  ${time selector}
	${is today}  Evaluate  not '.' in '${time is}'
	Run Keyword If  ${is today} == ${False}  Fail
	${time}  compare_dates_smarttender  ${time now -3 min}  <=  ${time is}
	Should Be Equal  ${time}  ${True}
	Reload Page
	Run Keyword And Ignore Error  Handle Alert  action=DISMISS