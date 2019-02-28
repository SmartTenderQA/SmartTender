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
    ...  Дочекатись закінчення загрузки сторінки  		AND
    ...  Статус лота повинен бути  ${auction status}


Статус лота повинен бути
	[Arguments]  ${auction status should}
	${auction status is}  Отримати статус лота
	Should Be Equal  ${auction status should}  ${auction status is}


Отримати статус лота
	${auction status locator}  Set Variable  //*[@data-qa='auctionStatus']
	${auction status is}  Get Text  ${auction status locator}
	[Return]  ${auction status is}


Розгорнути результати аукціону для учасника
	[Arguments]  ${user}
	${full name}  Отримати дані користувача по полю  ${user_name}  fullName
	${show result btn}  Set Variable  //div[contains(@class,'action-block') and contains(.,'${full name}')]//i[contains(@class,'dropdown')]
	elements.Дочекатися відображення елемента на сторінці  ${show result btn}
	Click Element  ${show result btn}
	elements.Дочекатися зникнення елемента зі сторінки  ${show result btn}


Натиснути "Дискваціфікувати"
	${disqualify btn}  Set Variable  //*[@data-qa="disqualify"]
	elements.Дочекатися відображення елемента на сторінці  ${disqualify btn}
	Click Element  	${disqualify btn}
	${rejection protocol btn}  Set Variable  //*[@data-qa="uploadRejectionProtocol"]
	elements.Дочекатися відображення елемента на сторінці  ${rejection protocol btn}  2
	${act btn}  Set Variable  //*[@data-qa="uploadAct"]
	elements.Дочекатися відображення елемента на сторінці  ${act btn}  2


Натиснути дискваліфікація
	[Documentation]  ${reason}=Завантажити рішення про відмову у затвердженні протоколу|Завантажити акт про відмову учасника
	[Arguments]  ${reason}
	${reason btn}  Set Variable If
	...  '${reason}' == 'Рішення про відмову'  //*[@data-qa="uploadRejectionProtocol"]
	...  '${reason}' == 'Акт про відмову учасника'  //*[@data-qa="uploadAct"]
	Click Element  ${reason btn}
	elements.Дочекатися зникнення елемента зі сторінки  ${reason btn}


Завантажити кваліфікаційний документ
	[Documentation]  ${documentType}=Рішення про відмову у затвердженні протоколу|Акт про відмову учасника|Протокол аукціону
	[Arguments]  ${documentType}
	${disqualify document block}  Set Variable  //*[contains(@data-qa,"upload") and contains(@data-qa,"Card")]
	elements.Дочекатися відображення елемента на сторінці  ${disqualify document block}
	${input file}  Set Variable  ${disqualify document block}//input[@type='file']
	${doc}  Створити та додати файл  ${input file}
	${md5}  get_checksum_md5  ${OUTPUTDIR}/${doc[1]}
	Set To Dictionary  ${docs_data}  documentType  ${documentType}
	Set To Dictionary  ${docs_data}  title  ${doc[1]}
	Set To Dictionary  ${docs_data}  hash  md5:${md5}
    ${new docs}  Evaluate  ${docs_data}.copy()
	Append To List  ${data['documents']}  ${new docs}
	Log  ${new docs}
	Log  ${data}
	Click Element  //*[@data-qa="submit"]

