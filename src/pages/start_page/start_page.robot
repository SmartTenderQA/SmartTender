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


Вибрати елемент з випадаючого списку заголовку
	[Arguments]  ${list}  ${item}
	${list dict}  Create Dictionary
	...  Торговий майданчик=menu-electronicProcurementSystem
	...  Про SmartTender=menu-aboutSmartTender
	...  Регламент=menu-regulation
	...  Інформаційний центр=menu-informationCenter

	${item dict}  Create Dictionary
#	Торговий майданчик
	...  Публічні закупівлі Prozorro=menu-publicProcurementsProzorro
	...  Комерційні закупівлі= enu-commercialTrades
	...  Комерційні продажі=menu-commercialTradesSales
	...  Неконкурентні процедури Prozorro=menu-publicProcurementsProzorroNoncompetitive
	...  Плани державних закупівель=menu-publicProcurementsProzorroPlans
	...  Аукціони на продаж майна банків=menu-auctionsOfBankSssets
	...  Аукціони на продаж державного майна=menu-auctionsOfGovernmentSssets
	...  Торги RIALTO=menu-rialtoTrades
#	Про SmartTender
	...  Про майданчик=menu-aboutCompany
	...  Наші клієнти=menu-ourClients
	...  Новини=menu-news
	...  Блог=menu-blog
	...  Вакансії=menu-vacancies
	...  Контакти=menu-contacts
	...  Відгуки=menu-reviews
#	Регламент
	...  Регламент SmartTender=menu-etpRegulation
    ...  Регламент Prozorro.Продажі=menu-spf
    ...  Регламент аукціонів ФГВФО=menu-fgvfl
#	Інформаційний центр
	...  Договір с майданчиком=menu-ontract
    ...  Тарифи=menu-tariffs
    ...  Запитання та відповіді=menu-faq
    ...  Тестові тендери=menu-testbids
    ...  Контракти публічних закупівель=menu-prozorroProcurementContracts
	${list selector}  Set Variable  //*[@data-qa="${list dict[u'${list}']}"]
	Mouse Over  ${list selector}

    ${item selector}  Set Variable  //*[@data-qa="${item dict[u'${item}']}"]
	Click Element  ${list selector}/..${item selector}


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
