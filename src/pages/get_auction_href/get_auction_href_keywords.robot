*** Keywords ***
Отримати URL для участі в аукціоні
	${auction_participate_href}  Get Element Attribute  ${participate in auction link}  href
	${status}  Run Keyword And Return Status  Page Should Contain Element  ${participate in auction link}[@disabled="disabled"]
    Run Keyword If  ${status}  Fail  Ой! Не вдалося отримати посилання. Кнопка взяти участь в аукціоні не активна.
	Run Keyword If  '${auction_participate_href}' == 'None'  Отримати URL для участі в аукціоні
	[Return]  ${auction_participate_href}


Отримати URL на перегляд
	${auction_href}  Get Element Attribute  ${view auction link}  href
	${status}  Run Keyword And Return Status  Page Should Contain Element  ${view auction link}[@disabled="disabled"]
    Run Keyword If  ${status}  Fail  Ой! Не вдалося отримати посилання. Кнопка до перегляду аукціону не активна.
	Run Keyword If  '${auction_href}' == 'None'  Отримати URL на перегляд
	[Return]  ${auction_href}


Дочекатись формування посилань на аукціон
	${auction loading}  Set Variable  (//*[@class="ivu-load-loop ivu-icon ivu-icon-load-c"])[1]
	Wait Until Page Does Not Contain Element  ${auction loading}  30
	Sleep  1