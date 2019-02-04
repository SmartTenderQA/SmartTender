*** Settings ***


*** Variables ***
${notice element locator}				css=.ivu-message-notice-content


*** Keywords ***
Дочекатись сповіщення з текстом
	[Arguments]  ${text}
	elements.Дочекатися відображення елемента на сторінці  ${notice element locator}  5
	Element Should Contain  ${notice element locator}  ${text}
	Wait Until Keyword Succeeds  10  .5  Element Should Not Be Visible  ${notice element locator}