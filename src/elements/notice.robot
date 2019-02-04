*** Settings ***


*** Variables ***
${notice element locator}				css=.ivu-message-notice-content


*** Keywords ***
Дочекатись сповіщення з текстом
	[Arguments]  ${text}
	Дочекатись закінчення загрузки сторінки
	Wait Until Page Contains Element  ${notice element locator}
	Wait Until Keyword Succeeds  5  .5  Element Should Be Visible  ${notice element locator}
	Element Should Contain  ${notice element locator}  ${text}
	Wait Until Keyword Succeeds  5  .5  Element Should Not Be Visible  ${notice element locator}