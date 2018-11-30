*** Settings ***
Resource  			keywords.robot

*** Variables ***
${events}                           xpath=//*[@id="LoginDiv"]//a[2]
${logout}                           id=LogoutBtn
${dropdown navigation}              //*[@id='MenuList']//div[@class='dropdown']//li/a[contains(text(), '')]
${button dogovir}                   css=#ContractButton
${button taryfy}                    css=#MenuList a[href='/taryfy/']
${RegisterAnchor}                   css=#RegisterAnchor
${site map}                         css=a[href='/karta-saytu/']


*** Keywords ***
Відкрити сторінку Заходи SmartTender
	Click Element  ${events}
	Element Should Contain  //h1  Заходи SmartTender
	Page Should Contain Element  css=div#calendar[class]


Відкрити сторінку Тарифів
	Click Element  ${button taryfy}
	Location Should Contain  /taryfy/


Відкрити сторінку Про компанію
	Click Element  ${button pro-kompaniyu}
	Location Should Contain  pro-kompaniyu


Відкрити сторінку Реєстрація
	Click Element  ${RegisterAnchor}
	Location Should Contain  /reestratsiya/
	Element Should Contain  //h1  Реєстрація
	Element Should Contain  css=.main-content h3  Персональна інформація


Відкрити сторінку інструкцій
	Click Element  xpath=//*[@href='/instruktcii/']
	Location Should Contain  instruktcii
	Дочекатись закінчення загрузки сторінки
	Element Should Contain  //h1  Інструкції


Відкрити сторінку Карта сайту
	Run Keyword And Ignore Error  other.Видалити кнопку "Замовити звонок"
	Page Should Contain Element  ${site map}
	Click Element  ${site map}
	Location Should Contain  /karta-saytu/
	Element Should Contain  //h1  Карта сайту


Відкрити вікно договору
	Click Element  ${button dogovir}
	Sleep  3


Натиснути Вийти
	Click Element  ${logout}
	Wait Until Page Does Not Contain Element  ${logout}


Навести мишку на
	[Documentation]  ${text}==Про компанію|Торговий майданчик
	[Arguments]  ${text}
	${dict}  Отримати словник для випадаючих списків
	${text}  Encode String To Bytes  ${text}  UTF-8
	Mouse Over  ${dict['${text}']}


Натиснути на елемент з випадаючого списка
	[Arguments]  ${text}
	${selector}  Set Variable  //*[@id='MenuList']//div[@class='dropdown']//li/a[contains(text(), '${text}')]
	Click Element  ${selector}
