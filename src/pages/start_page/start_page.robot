*** Settings ***
Resource    	keywords.robot
Resource    	balance/balance.robot
Resource    	login/login.robot
Resource    	menu-user/menu-user.robot
Resource    	notifications/notifications.robot


*** Variables ***
${log in button}					//*[@data-qa="btn-showModalLogin"]
${sign up button}					//*[@data-qa="btn-registration"]


*** Keywords ***
Відкрити вікно авторизації
	Wait Until Page Contains Element  ${log in button}
	Click Element  ${log in button}
	Wait Until Page Contains Element  //*[@id="ModalLogin"]  ${swt}


Навести мишку на іконку з заголовку
	[Arguments]  ${icon name}
	${dict}  Create Dictionary
	...  Календар=podii
	...  Повідомлення=notifications
	...  Баланс=balance
	...  Меню_користувача=menu-user
	${selector}  Set Variable
	...  //*[@data-qa="${dict[u'${icon name}']}"]
	Mouse Over  ${selector}


Натиснути на іконку з баннеру
	[Arguments]  ${icon name}
	&{dict}  Create Dictionary
	...  Державні закупівлі Prozorro=['btn-banner-item-prozorro', '/publichni-zakupivli-prozorro/']
	...  Аукціони на продаж майна банків=['btn-banner-item-bank', '/auktsiony-na-prodazh-aktyviv-bankiv']
	...  Комерційні тендери SmartTender=['btn-banner-item-commercialZakupki', '/komertsiyni-torgy/']
	...  Аукціони на продаж державного майна=['btn-banner-item-auctionGov', '/auktsiony-na-prodazh-aktyviv-derzhpidpryemstv']
	...  Комерційні продажі товарів та послуг=['btn-banner-item-commercialSales', '/komertsiyni-torgy-prodazhi/']
	...  Оренда землі=['btn-banner-item-house', '/auktsiony-na-prodazh-aktyviv-derzhpidpryemstv']
	${item}  Get From Dictionary  ${dict}  ${icon name}
	@{list}  Evaluate  list(${item})
	${data-qa}  Set Variable  ${list[0]}
	${part of location}  Set Variable  ${list[1]}
	${selector}  Set Variable  //*[@data-qa="${data-qa}"]
	Click Element  ${selector}
	Location Should Contain  ${part of location}


################legacy
Зайти на сторінку contacts
	Click Element  ${button kontakty}
	Location Should Contain  /pro-kompaniyu/kontakty/
	${header text}  Set Variable  css=div[itemscope=itemscope] h1
	${should header}  Set Variable  Контакти SmartTender
	${is header}  Get Text  ${header text}
	Should Be Equal  ${is header}  ${should header}
