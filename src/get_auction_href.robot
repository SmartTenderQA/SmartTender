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
    Wait Until Keyword Succeeds  10m  20s  Отримати посилання на участь в аукціоні учасником
	Wait Until Keyword Succeeds  10m  20s  Перейти та перевірити сторінку участі в аукціоні  ${data['auctionUrl_participate']}


Подати пропозицію учасниками
    [Arguments]  ${role}
    Switch Browser  ${role}
	wait until keyword succeeds  20m  30s  Перевірити статус тендера  Прийом пропозицій
	Sleep  3m
    Перевірити кнопку подачі пропозиції
	Заповнити поле з ціною  1  1
    Додати файл  1
	Run Keyword And Ignore Error  Підтвердити відповідність
	Подати пропозицію
    Go Back


Перевірити статус тендера
    [Arguments]  ${tender status}
    Reload Page
    Wait Until Element Is Visible  //*[@data-qa="status"]  20
    ${status}  Get Text  //*[@data-qa="status"]
    Should Be Equal  '${status}'  '${tender status}'


Отримати посилання на участь в аукціоні учасником
	Reload Page
	Натиснути кнопку "До аукціону"
	${auction_href}  Отримати URL для участі в аукціоні
	Set To Dictionary  ${data}  auctionUrl_participate  ${auction_href}


Натиснути кнопку "До аукціону"
	Wait Until Element Is Visible  //*[@data-qa="button-poptip-participate-view"]
	Click Element  //*[@data-qa="button-poptip-participate-view"]


Отримати URL для участі в аукціоні
	${selector}  Set Variable  //*[@data-qa="link-participate"]
	Wait Until Element Is Visible  ${selector}  120
	${auction_href}  Wait Until Keyword Succeeds  20  3  Get Element Attribute  ${selector}  href
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
	Run Keyword And Expect Error  *  Отримати посилання на участь в аукціоні учасником


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