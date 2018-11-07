*** Keywords ***
Підтвердити повідомлення про умови проведення аукціону
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Чи погоджуєтесь Ви з умовами проведення аукціону?
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  xpath=//button[@class="btn btn-success"]
    ...  AND  Wait Until Element Is Not Visible  xpath=//button[@class="btn btn-success"]


Отримати посилання на аукціон учасником
    [Arguments]  ${role}
    Switch Browser  ${role}
	Дочекатись дати закінчення періоду прийому пропозицій
    Wait Until Keyword Succeeds  3m  2  Отримати посилання на участь в аукціоні учасником
	Перейти та перевірити сторінку участі в аукціоні  ${data['auctionUrl_participate']}


Отримати посилання на участь в аукціоні учасником
	Reload Page
	Натиснути кнопку "До аукціону"
	${auction_href}  Отримати URL для участі в аукціоні
	Set To Dictionary  ${data}  auctionUrl_participate  ${auction_href}


Отримати посилання на участь в аукціоні користквачем
    Reload Page
	Натиснути кнопку "До аукціону"
	${auction loading}  Set Variable  (//*[@class="ivu-load-loop ivu-icon ivu-icon-load-c"])[1]
	Wait Until Page Does Not Contain Element  ${auction loading}  30
    ${status}  Run Keyword And Return Status  Page Should Contain Element  //*[@data-qa="link-participate" and @disabled="disabled"]
    Run Keyword If  ${status}  Fail  Кнопка взяти участь в аукціоні не активна


Натиснути кнопку "До аукціону"
	Wait Until Element Is Visible  //*[@data-qa="button-poptip-participate-view"]
	Click Element  //*[@data-qa="button-poptip-participate-view"]


Отримати URL для участі в аукціоні
	${selector}  Set Variable  //*[@data-qa="link-participate"]
	${auction loading}  Set Variable  (//*[@class="ivu-load-loop ivu-icon ivu-icon-load-c"])[1]
	Wait Until Page Does Not Contain Element  ${auction loading}  30
	${auction_href}  Wait Until Keyword Succeeds  20  3  Get Element Attribute  ${selector}  href
	Run Keyword If  '${auction_href}' == 'None'  Отримати URL для участі в аукціоні
	[Return]  ${auction_href}


Отримати URL на перегляд
	${selector}  Set Variable  //*[@data-qa="link-view"]
	${auction loading}  Set Variable  (//*[@class="ivu-load-loop ivu-icon ivu-icon-load-c"])[1]
	Wait Until Page Does Not Contain Element  ${auction loading}  30
	${auction_href}  Wait Until Keyword Succeeds  20  3  Get Element Attribute  ${selector}  href
	Run Keyword If  '${auction_href}' == 'None'  Отримати URL на перегляд
	[Return]  ${auction_href}



Отримати посилання на перегляд аукціону користувачем
	Reload Page
	Натиснути кнопку "До аукціону"
	${auction_href}  Отримати URL для перегляду аукціону
	Set To Dictionary  ${data}  auctionUrl_view  ${auction_href}


Отримати URL для перегляду аукціону
    ${selector}  Set Variable  //*[@data-qa="link-view"]
	Wait Until Page Contains Element  ${selector}  60
	${auction_href}  Get Element Attribute  ${selector}  href
	[Return]  ${auction_href}


Перевірити можливість отримати посилання на аукціон користувачем
	[Arguments]  ${role}
	Switch Browser  ${role}
	Reload Page
	Run Keyword And Expect Error  *  Отримати посилання на участь в аукціоні користквачем


Перейти та перевірити сторінку участі в аукціоні
	[Arguments]  ${auction_href}
	Go To  ${auction_href}
	Підтвердити повідомлення про умови проведення аукціону
	Wait Until Page Contains Element  //*[@class="page-header"]//h2  30
	Location Should Contain  bidder_id=
	Sleep  2
	Element Should Contain  //*[@class="page-header"]//h2  ${data['tender_uaid']}
	Element Should Contain  //*[@class="lead ng-binding"]  ${data['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['item']['description']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['item']['quantity']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['item']['unit']}
	Element Should Contain  //h4  Вхід на даний момент закритий.