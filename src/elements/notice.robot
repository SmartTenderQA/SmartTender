*** Settings ***


*** Variables ***
${notice element locator}				css=.ivu-message-notice-content


*** Keywords ***
Дочекатись сповіщення з текстом
	[Arguments]  ${text}  ${timeout}=10
	Wait Until Keyword Succeeds  ${timeout}  .25  notice.Текст сповіщення повинен бути  ${text}
	Wait Until Keyword Succeeds  10  .5  Element Should Not Be Visible  ${notice element locator}


Текст сповіщення повинен бути
	[Arguments]  ${text}
<<<<<<< Updated upstream
	Wait Until Page Contains Element  ${notice element locator}  15
	Wait Until Keyword Succeeds  5  .5  Element Should Be Visible  ${notice element locator}
	Element Should Contain  ${notice element locator}  ${text}
	Wait Until Keyword Succeeds  5  .5  Element Should Not Be Visible  ${notice element locator}
=======
	${text is}  Get Text  ${notice element locator}
	${is equal}  Evaluate  '${text is}' == '${text}'
	Run Keyword If  ${is equal} == ${False}
	...  Fail  Oops! Неочікуваний текст в сповіщенні
>>>>>>> Stashed changes
