*** Settings ***
Resource  	../../../common/header_old/header_old.robot


*** Keywords ***
Fill Login
	[Arguments]  ${login}
	${field}  Set Variable  //*[@data-qa="form-login-login"]//input
	Input Text  ${field}  ${login}
	Press Key  //html//body  \\09
	${get}  Get Element Attribute  ${field}  value
	Should Be Equal  ${get}  ${login}


Fill Password
	[Arguments]  ${password}
	${field}  Set Variable  //*[@data-qa="form-login-password"]//input
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
