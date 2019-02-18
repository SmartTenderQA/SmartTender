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


Натиснути кнопку Реєстрація
	Wait Until Page Contains Element  ${sign up button}
	Click Element  ${sign up button}
	Дочекатись закінчення загрузки сторінки
	Location Should Contain  /reestratsiya/
	Element Should Contain  //h1  Реєстрація
	Element Should Contain  css=.main-content h3  Персональна інформація


Навести мишку на іконку з заголовку
	[Arguments]  ${icon name}
	${dict}  Create Dictionary
	...  Календар=title-btn-podii
	...  Повідомлення=title-btn-notifications
	...  Баланс=title-balance
	...  Меню_користувача=title-menu-user-fio
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
	...  Договори публічних закупівель=menu-prozorroProcurementContracts
	...  Тестові тендери=menu-testbids
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
#	it's link
#    ...  Регламент Prozorro.Продажі=menu-spf
#    ...  Регламент аукціонів ФГВФО=menu-fgvfl
#	Інформаційний центр
	...  Договір с майданчиком=menu-contract
    ...  Тарифи=menu-tariffs
    ...  Інструкції=menu-documentations
    ...  Запитання та відповіді=menu-faq
    ...  Курси валют=menu-exchangeRates
	${list selector}  Set Variable  //*[@data-qa="${list dict[u'${list}']}"]
	Wait Until Keyword Succeeds  10  1  Mouse Over  ${list selector}

    ${item selector}  Set Variable  //*[@data-qa="${item dict[u'${item}']}"]
	Wait Until Keyword Succeeds  10  1  Click Element  ${list selector}/..${item selector}


Натиснути на іконку з баннеру
	[Arguments]  ${icon name}
	&{dict}  Create Dictionary
	...  Державні закупівлі Prozorro=['page-banner-btn-prozorro', '/publichni-zakupivli-prozorro/']
	...  Аукціони на продаж майна банків=['page-banner-btn-bank', '/auktsiony-na-prodazh-aktyviv-bankiv']
	...  Комерційні тендери SmartTender=['page-banner-btn-commercialZakupki', '/komertsiyni-torgy/']
	...  Аукціони на продаж державного майна=['page-banner-btn-auctionGov', '/auktsiony-na-prodazh-aktyviv-derzhpidpryemstv']
	...  Комерційні продажі товарів та послуг=['page-banner-btn-commercialSales', '/komertsiyni-torgy-prodazhi/']
	...  Оренда землі=['page-banner-btn-house', '/auktsiony-na-prodazh-aktyviv-derzhpidpryemstv']
	${item}  Get From Dictionary  ${dict}  ${icon name}
	@{list}  Evaluate  list(${item})
	${data-qa}  Set Variable  ${list[0]}
	${part of location}  Set Variable  ${list[1]}
	${selector}  Set Variable  //*[@data-qa="${data-qa}"]
	Click Element  ${selector}
	Location Should Contain  ${part of location}
