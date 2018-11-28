*** Settings ***
Resource  		keywords.robot


*** Keywords ***
Натиснути кнопку "До аукціону"
    Reload Page
	Wait Until Element Is Visible  //*[@data-qa="button-poptip-participate-view"]  30
	Click Element  //*[@data-qa="button-poptip-participate-view"]
	Дочекатись отримання посилань на аукціон


Натиснути кнопку "Перегляд аукціону"
	${selector}  Set Variable  //*[@data-qa="button-poptip-view"]
	Wait Until Element Is Visible  ${selector}
	Click Element  ${selector}
	Дочекатись отримання посилань на аукціон


Отримати URL для участі в аукціоні
	${selector}  Set Variable  //*[@data-qa="link-participate"]
	${auction_href}  Get Element Attribute  ${selector}  href
	${status}  Run Keyword And Return Status  Page Should Contain Element  //*[@data-qa="link-participate" and @disabled="disabled"]
    Run Keyword If  ${status}  Fail  Кнопка взяти участь в аукціоні не активна
	Run Keyword If  '${auction_href}' == 'None'  Отримати URL для участі в аукціоні
	[Return]  ${auction_href}


Отримати URL на перегляд
	${selector}  Set Variable  //*[@data-qa="link-view"]
	${auction loading}  Set Variable  (//*[@class="ivu-load-loop ivu-icon ivu-icon-load-c"])[1]
	Wait Until Page Does Not Contain Element  ${auction loading}  30
	${auction_href}  Wait Until Keyword Succeeds  20  3  Get Element Attribute  ${selector}  href
	Run Keyword If  '${auction_href}' == 'None'  Отримати URL на перегляд
	[Return]  ${auction_href}