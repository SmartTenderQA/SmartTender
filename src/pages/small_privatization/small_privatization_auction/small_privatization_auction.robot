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


Дочекатися статусу лота
	[Arguments]  ${auction status}  ${time}
    Wait Until Keyword Succeeds  ${time}  30 sec  Run Keywords
    ...  Reload Page  												AND
    ...  Дочекатись закінчення загрузки сторінки(skeleton)  		AND
    ...  Статус лота повинен бути  ${auction status}


Статус лота повинен бути
	[Arguments]  ${auction status should}
	${auction status is}  Отримати статус лота
	Should Be Equal  ${auction status should}  ${auction status is}


Отримати статус лота
	${auction status locator}  Set Variable  //*[@data-qa='auctionStatus']
	${auction status is}  Get Text  ${auction status locator}
	[Return]  ${auction status is}
