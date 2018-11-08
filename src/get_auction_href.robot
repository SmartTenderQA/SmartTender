*** Keywords ***
Підтвердити повідомлення про умови проведення аукціону
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Чи погоджуєтесь Ви з умовами проведення аукціону?
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  xpath=//button[@class="btn btn-success"]
    ...  AND  Wait Until Element Is Not Visible  xpath=//button[@class="btn btn-success"]


#Отримати посилання на аукціон учасником
#   Wait Until Keyword Succeeds  3m  2  Отримати посилання на участь в аукціоні учасником
#	Перейти та перевірити сторінку участі в аукціоні  ${data['auctionUrl_participate']}


#Отримати посилання на участь в аукціоні учасником
#	Reload Page
#	Натиснути кнопку "До аукціону"
#	${auction_href}  Отримати URL для участі в аукціоні
#	Set To Dictionary  ${data}  auctionUrl_participate  ${auction_href}


Натиснути кнопку "До аукціону"
	Wait Until Element Is Visible  //*[@data-qa="button-poptip-participate-view"]
	Click Element  //*[@data-qa="button-poptip-participate-view"]
	Дочекатись отримання посилань на аукціон


Натиснути кнопку "Перегляд аукціону"
	${selector}  Set Variable  //*[@data-qa="button-poptip-view"]
	Wait Until Element Is Visible  ${selector}
	Click Element  ${selector}
	Дочекатись отримання посилань на аукціон


Дочекатись отримання посилань на аукціон
	${auction loading}  Set Variable  (//*[@class="ivu-load-loop ivu-icon ivu-icon-load-c"])[1]
	Wait Until Page Does Not Contain Element  ${auction loading}  30
	Sleep  1


Отримати URL для участі в аукціоні
	${selector}  Set Variable  //*[@data-qa="link-participate"]
	${auction_href}  Get Element Attribute  ${selector}  href
	Run Keyword If  '${auction_href}' == 'None'  Отримати URL для участі в аукціоні
	[Return]  ${auction_href}


Отримати URL на перегляд
	${selector}  Set Variable  //*[@data-qa="link-view"]
	${auction loading}  Set Variable  (//*[@class="ivu-load-loop ivu-icon ivu-icon-load-c"])[1]
	Wait Until Page Does Not Contain Element  ${auction loading}  30
	${auction_href}  Wait Until Keyword Succeeds  20  3  Get Element Attribute  ${selector}  href
	Run Keyword If  '${auction_href}' == 'None'  Отримати URL на перегляд
	[Return]  ${auction_href}


Дочекатись початку аукціону
    ${auction start date}  Get text  //*[@data-qa="auction-start"]//span[@data-qa]
    Дочекатись дати  ${auction start date}
    Дочекатися статусу тендера  Аукціон


Дочекатись початку періоду перкваліфікації
    ${tender end date}  Get text  //*[@data-qa="tendering-period"]//*[@data-qa="date-end"]
    Дочекатись дати  ${tender end date}
    Дочекатися статусу тендера  Прекваліфікація


#Перевірити можливість отримати посилання на аукціон користувачем
#	[Arguments]  ${role}
#	Switch Browser  ${role}
#	Reload Page
#	Run Keyword And Expect Error  *  Отримати посилання на участь в аукціоні користквачем


#Отримати посилання на участь в аукціоні користквачем
#   Reload Page
#	Натиснути кнопку "До аукціону"
#	${auction loading}  Set Variable  (//*[@class="ivu-load-loop ivu-icon ivu-icon-load-c"])[1]
#	Wait Until Page Does Not Contain Element  ${auction loading}  30
#   ${status}  Run Keyword And Return Status  Page Should Contain Element  //*[@data-qa="link-participate" and @disabled="disabled"]
#   Run Keyword If  ${status}  Fail  Кнопка взяти участь в аукціоні не активна

