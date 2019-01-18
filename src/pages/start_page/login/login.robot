*** Settings ***
Resource  	../../../common/header_old/header_old.robot


*** Keywords ***
Fill Login
	[Arguments]  ${login}
	${field}  Set Variable  //*[@data-qa="form-login-login"]//input
#	Clear Element Text  ${field}
#	Execute Javascript  document.querySelector('[data-qa="form-login-login"]').setAttribute('value', '')
	Input Text  ${field}  ${login}
	Press Key  //html//body  \\09
	${get}  Get Element Attribute  ${field}  value
	Should Be Equal  ${get}  ${login}


Fill Password
	[Arguments]  ${password}
	${field}  Set Variable  //*[@data-qa="form-login-password"]//input
#	Clear Element Text  ${field}
#	Execute Javascript  document.querySelector('[data-qa="form-login-password"]').setAttribute('value', '')
	Input Text  ${field}  ${password}
	Press Key  //html//body  \\09
	${get}  Get Element Attribute  ${field}  value
	Should Be Equal  ${get}  ${password}


Click Log In
	Click Element  //*[@data-qa="form-login-success"]
	Дочекатись закінчення загрузки сторінки


Click I forgot password
	Click Element  //*[@data-qa="form-login-forgot-password"]
	Location Should Contain  /Authentication/ForgotPassword/


Close window
	Click Element  //*[@id='ModalLogin']//*[contains(@class, 'close')]
	Wait Until Keyword Succeeds  10  1
	...  Element Should Not Be Visible  //*[@data-qa="form-login-login"]


Дочекатись валідаційного повідомлення з текстом
	[Arguments]  ${text}
	${selector}  Set Variable  css=.ivu-message-notice-content
	Element Should Contain  ${selector}  ${text}
