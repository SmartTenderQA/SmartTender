*** Settings ***


*** Variables ***


*** Keywords ***
Дочекатися статусу повідомлення Аукціон
	Reload Page
    Дочекатись закінчення загрузки сторінки(skeleton)
    ${message status should}  Set Variable  Аукціон
	${message status locator}  Set Variable  //h4[contains(@class,'action-block-item')]
	${message status is}  Get Text  ${message status locator}
	Should Be Equal  ${message status should}  ${message status is}
	${auction locator}  Set Variable  //a[contains(text(),'Перейти до аукціону')]
	Page Should Contain Element  ${auction locator}
	Element Should Be Visible  ${auction locator}


Отримати UAID для Аукціону
    Дочекатись Закінчення Загрузки Сторінки
    Wait Until Element Is Visible  //*[@data-qa='cdbNumber']  10
	${UAID}  Get Text  //*[@data-qa='cdbNumber']
	Run Keyword If  '${UAID}' == ''
	...  Отримати UAID для Аукціону
    Set To Dictionary  ${data}  tender_id  ${UAID}
