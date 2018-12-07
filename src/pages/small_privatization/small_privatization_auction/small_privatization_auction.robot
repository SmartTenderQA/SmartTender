*** Settings ***


*** Variables ***


*** Keywords ***
Отримати UAID та href для Аукціону
    Дочекатись Закінчення Загрузки Сторінки
    Wait Until Element Is Visible  //*[@data-qa='cdbNumber']  10
	${UAID}  Get Text  //*[@data-qa='cdbNumber']
	Run Keyword If  '${UAID}' == ''
	...  Отримати UAID для Аукціону
    Set To Dictionary  ${data}  tender_id  ${UAID}
    ${tender_href}  Get Location
	Set To Dictionary  ${data}  tender_href  ${tender_href}


Знайти аукціон користувачем
	[Arguments]  ${role}
	Switch Browser  ${role}
	Sleep  2
	small_privatization.Перейти на сторінку малої приватизації
	Input Text  //input[@placeholder='Введіть фразу для пошуку']  ${data['tender_id']}
	Click Element  //div[@class='ivu-input-group-append']//button[@type='button']
	Дочекатись закінчення загрузки сторінки(skeleton)
	Click Element  (//*[@class='panel-body']//*[contains(@class,'xs-7')])[1]
	Дочекатись закінчення загрузки сторінки(skeleton)


Дочекатися початку аукціону
	Reload Page
    Дочекатись закінчення загрузки сторінки(skeleton)
    ${auction status should}  Set Variable  Аукціон
	${auction status locator}  Set Variable  //*[@data-qa='auctionStatus']
	${auction status is}  Get Text  ${auction status locator}
	Should Be Equal  ${auction status should}  ${auction status is}