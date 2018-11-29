*** Settings ***
Resource  ../../src/src.robot
Test Setup  Test Precondition
Test Teardown  Test Postcondition
Suite Setup  Відкрити головну сторінку SmartTender.biz під потрібною роллю
Suite Teardown  Close All Browsers


*** Variables ***
${button pro-kompaniyu}              css=.with-drop>a[href='/pro-kompaniyu/']
${button taryfy}                     css=#MenuList a[href='/taryfy/']
${button podii}                      css=#LoginDiv [href='/podii/']
${button dogovir}                    css=#ContractButton
${dropdown navigation}               css=#MenuList div.dropdown li>a
${pro-kompaniyu text}                xpath=//div[@itemscope='itemscope']//div[1]/*[@class='ivu-card-body']/div[2]/div[1]
${header text}                       css=div[itemscope=itemscope] h1
${novyny text}                       css=[class="row content"] h1
${news block}                        css=.ivu-row-undefined-space-between
${news search input}                 css=.ivu-card-body input
${news search button}                css=.ivu-card-body button
${kontakty text}                     css=div[itemscope=itemscope]>div.ivu-card:nth-child(1) span
${kontakty block}                    css=div[itemscope=itemscope]>div.ivu-card
${nashi-klienty text}                xpath=(//*[@class="row text-center"]//b)[1]
${nashi-klienty text1}               xpath=(//*[@class="row text-center"]//b)[2]
${vakansii text}                     css=.container>div.row>div
${taryfy text}                       //*[@class="body-content"]//ul[@class="nav nav-pills nav-justified"]//li
${client banner}                     css=.container .row .ivu-card-body
${item plan}                         css=tr[data-planid] a
${item dogovory}                     xpath=//*[contains(@class, 'container')]//*[contains(@class, 'content-expanded')]/div[2]/*
${auction active items}              //tbody/tr[@class='head']|//*[@id='hotTrades']/div/div|//*[@class="panel-body"]
${auction active header}             css=.ivu-card-body h4
${auction active item}               css=.ivu-row>div>div[class="ivu-card-body"] a
${RegisterAnchor}                    css=#RegisterAnchor
${instruktsii link}                  css=#LoginDiv a[href='/instruktсii/']
${h1 header text}                    css=#main h1
${feedback link}                     css=.footer-feedback a
${site map}                          css=a[href='/karta-saytu/']
${exchange rates header}             css=#content h1
${exchange link1}                    xpath=//div[@class='bank-view'][1]//a
${exchange link2}                    xpath=//div[@class='bank-view'][2]//a
${contract link1}                    css=li:nth-child(1)>a
${contract link2}                    css=li:nth-child(2)>a
${advanced search2}                  xpath=//span[contains(text(),'Розгорнути')]
${dropdown menu for bid statuses}    xpath=//label[contains(text(),'Статуси')]/../../ul
${info form1}                        xpath=//*[@data-qa='tender-header-detail-biddingForm']/div[2]|//*[@id='tenderPage']//h1
${info form for sales}               xpath=//h5[@class='label-key' and contains(text(), 'Тип процедури')]/following-sibling::p
${info form4}                        xpath=//*[contains(text(), 'Тип активу')]/../following-sibling::div
${first lot}                         //*[@data-qa="lot-list-block"]//*[@data-qa="value-list"]
${tender_type_procurement}           //*[@data-qa="procedure-type"]//div[2]//*|//*[@class="info_form"]
${elastic search input}              css=.ivu-card-bordered input
${elastic search button}             css=.ivu-card-bordered button
${elastic search clean filter}       css=.tag-holder button
${vidhuky}                           css=.ivu-row .ivu-card
${blog}                              css=.ivu-card-body>.ivu-row
${blog input}                        css=.ivu-card-body input
${blog search button}                css=.ivu-card-body button
${breadcrumbs}					     //*[contains(@class, "breadcrumbs")]//li
${last found multiple element}     		xpath=(//*[@id='tenders']//*[@class='head']//span[@class='Multilots']/../..//a[@class='linkSubjTrading'])[last()]


#robot --consolecolors on -L TRACE:INFO -A suites/walking_man/arguments.txt -v hub:None -v user:prod_provider1 -i your_account suites/walking_man/suite.robot
*** Test Cases ***
Особистий кабінет
  [Tags]  your_account
  start_page.Відкрити особистий кабінет


Аналітика участі
  [Tags]  your_account
  start_page.Відкрити особистий кабінет
  personal_account.Відкрити сторінку за назвою  analytics
  analytics.Перевірити сторінку
  analytics.Відкрити аналітику по конкуренту  ТОВАРИСТВО З ОБМЕЖЕНОЮ ВІДПОВІДАЛЬНІСТЮ "УКРАЇНСЬКИЙ ПАПІР"
  analytics.Встановити період аукціону  Минулий місяць
  analytics.Перевірити відображення компонентів
  analytics.Перевірити роботу кругової діаграми
  analytics.Перевірити роботу фільтра по періоду


Налаштування підписки
  [Tags]  your_account  -prod  -test
  start_page.Відкрити особистий кабінет
  personal_account.Відкрити сторінку за назвою  subscription
  subscription.Перевірити сторінку
  subscription.Перевірити блок запиту допомоги з налаштування підписки
  subscription.Перевірити блок Персональне запрошення організатора
  subscription.Перевірити блок E-mail адреси для дублювання всіх розсилок
  subscription.Перевірити вкладки підписки для закупівель
  subscription.Перевірити вкладки підписки на продаж
  subscription.Активувати тип торгів для підписки  на закупівлю


Заявки на отримання тендерного забезпечення
  [Tags]  your_account
  start_page.Відкрити особистий кабінет
  personal_account.Відкрити сторінку за назвою  tender_providing
  tender_providing.Перевірити сторінку


Юридична допомога
  [Tags]  your_account  -ip
  start_page.Відкрити особистий кабінет
  personal_account.Відкрити сторінку за назвою  legal_help
  legal_help.Перевірити сторінку


Особисті дані користувача
  [Tags]  your_account
  start_page.Відкрити особистий кабінет
  personal_account.Відкрити сторінку за назвою  company_profile
  company_profile.Перевірити сторінку


Змінити пароль
  [Tags]  your_account  -ip
  start_page.Відкрити особистий кабінет
  personal_account.Відкрити сторінку за назвою  change_password
  change_password.Перевірити сторінку


Управління користувачами
  [Tags]  your_account
  start_page.Відкрити особистий кабінет
  personal_account.Відкрити сторінку за назвою  user_management
  user_management.Перевірити сторінку


Звіти
  [Tags]  your_account
  start_page.Відкрити особистий кабінет
  personal_account.Відкрити сторінку за назвою  reports
  reports.Перевірити сторінку
  reports.Встановити фільтр Тільки обрані звіти  вимкнути
  reports.Перевірити наявність звітів
  reports.Прибрати усі звіти з обраних
  ${name}  reports.Додати в обрані випадковій звіт та повернути назву
  reports.Встановити фільтр Тільки обрані звіти  увімкнути
  reports.Перевірити наявність звіту  ${name}
  reports.Прибрати усі звіти з обраних


Відгуки
  [Tags]  site  -test
  Зайти на сторінку відгуків
  Перевірити заголовок відгуків
  Перевірити наявність відгуків
  Відкрити та перевірити відгук


Блог
  [Tags]  site  -test
  Зайти на сторінку блогу
  Перевірити загловок блогу
  Перевірити наявність блогів
  ${title}  Перевірити пошук на сторінці блогів
  Відкрити Блог
  Перевірити відкритий блог  ${title}


Перевірити elastic
	[Tags]  site  -test
	Зайти на сторінку пошуку elastic
	Очистити Фільтр Пошуку Elastic
	Виконати пошук в elastic  бумага
	${status}  Run Keyword And Return Status  Page Should Contain  папір
	Run Keyword If  not ${status}  Page Should Contain  Папір
	Очистити фільтр пошуку elastic


Договір
  [Tags]  site  -test
  Відкрити вікно договору
  Перевірити заголовок договору
  Перевірити перший абзац договору
  Перевірити лінки в тексті договору


Про компанію
  [Tags]  site
  Зайти на сторінку про компанію
  Перевірити заголовок сторінки про компанію
  Перевірити текст сторінки про компанію


Новини
  [Tags]  site
  Зайти на сторінку з новинами
  Перевірити заголовок сторінки з новинами
  Порахувати кількість новин
  Перевірити пошук(Click button)
  Перевірити пошук(ENTER)
  Переглянути новину
  Перевірити лінк хлібних крох


Контакти
  [Tags]  site
  Зайти на сторінку contacts
  Перевірити заголовок сторінки контактів
  Порахувати кількість контактів
  Перевірити заголовок контакту


З ким ми працюємо
  [Tags]  site
  Зайти на сторінку клієнтів
  Перевірити заголовок сторінки клієнтів
  Порахувати кількість клієнтів


Вакансії
  [Tags]  site
  Зайти на сторінку вакансій
  Перевірити заголовок сторінки вакансій


Тарифи
  [Tags]  site
  Зайти на сторінку тарифів
  Перевірити кількість закладок
  Закладка Публічні закупівлі
  Закладка Комерційні торги
  Закладка Продаж активів банків, що ліквідуються (ФГВФО)
  Закладка Продаж і оренда майна/активів Державних підприємств


Події
  [Tags]  site
  Зайти на сторінку с подіями
  Превірити заголовок сторінки подій
  Перевірити наявність календаря


Реєстрація
  [Tags]  site
  Run Keyword if  '${role}' != 'viewer'  Pass Execution  only for viewer
  Зайти на сторінку реєстрації
  Перевірити заголовок сторінки реєстрації
  Перевірити підзаголовок сторінки реєстрації


Інструкції
  [Tags]  site
  Відкрити сторінку інструкцій
  Перевірити заголовок сторінки інструкцій
  Перевірити випаючий список інструкцій


Карта сайту
  [Tags]  site
  Перейти на сторінку карти сайту
  Перевірити заголовок сторінки карта сайта
  Порахувати кількість єлементів сторінки карта сайту


Питання та відповіді
  [Tags]  site  -test
  Перейти на сторінку запитань
  Перевірити заголовок сторінки запитань
  Порахувати кількість запитань


Курси валют
  [Tags]  site  -test
  Відкрити вікно курсів валют
  Перевірити шлях курсів валют
  Перевірити заголовок курсів валют
  Перевірити лінки курсів валют


Перевірити наявність всіх видів торгів в випадаючому списку
	[Tags]  commercial
	[Setup]  Run Keywords
	...  Test Precondition
	...  AND  Натиснути На торговельний майданчик
	...  AND  Перевірити назву вкладки Комерційні торги
	...  AND  Перевірити заголовок вкладки комерційні торги  Закупівлі
	...  AND  Перевірити заголовок вкладки комерційні торги  Продажі
	...  AND  Перевірити наявність торгів
	...  AND  old_search.Розгорнути Розширений Пошук
	...  AND  Click Element  ${dropdown menu for bid forms}
	[Template]  Перевірити наявність тексту в випадаючому списку
	Відкриті торги. Аукціон
	Тендер на закупівлю. Аукціон
	Закриті торги. Аукціон
	Аукціон з обмеженим списком учасників
	Обмеж.список. Аукціон
	Обмеж.список.учасників
	Аукціон на закупівлю з обмеженим списком. За рейтингом
	Заявки на закупівлю
	Відкриті торги. Аналіз пропозицій
	Запит пропозицій
	Відкриті торги. Неформалізована оцінка
	Відкриті торги. Аналіз ринку
	Закриті торги. Аналіз ринку


Перевірити комерційні закупівлі prod
	[Tags]  commercial  -prod
	[Setup]  No Operation
	[Template]  Перевірити комерційні закупівлі за назвою
	Відкриті торги. Аукціон
	Відкриті торги. Аналіз пропозицій
	Запит пропозицій
	Відкриті торги. Аналіз ринку


Перевірити комерційні закупівлі test
	[Tags]  commercial  -test
	[Setup]  No Operation
	[Template]  Перевірити комерційні закупівлі за назвою
	Відкриті торги. Аукціон



Перевірити список доступних торгів для Комерційні торги Продажі
	[Tags]  commercial
	[Setup]  Run Keywords
	...  Test Precondition
	...  AND  Натиснути На торговельний майданчик
	...  AND  old_search.Активувати вкладку Комерційні торги за типом  Продажі
	...  AND  old_search.Розгорнути Розширений Пошук
	...  AND  Click Element  ${dropdown menu for bid forms}
	[Template]  Перевірити наявність тексту в випадаючому списку
	Тендер на продаж. Відкриті торги
	Аукціон на продаж. Відкриті торги
	Аукціон на продаж. Обмежений список
	Аукціон на продаж. За рейтингом
	Тендер на продаж. Обмежений список


Аукціон на продаж. Відкриті торги
	[Tags]  commercial  -test
	Натиснути На торговельний майданчик
	old_search.Активувати вкладку Комерційні торги за типом  Продажі
	Перевірити наявність торгів
	old_search.Розгорнути Розширений Пошук
	old_search.Вибрати Тип Процедури  ${TESTNAME}
	old_search.Виконати пошук тендера
	old_search.Перейти по результату пошуку за номером  last()
	Перевірити тип процедури для комерційних торгів


Перевірити список доступних торгів для Державні закупівлі прозорро Конкурентні процедури
	[Tags]  procurement
	[Setup]  Run Keywords
	...  Test Precondition
	...  AND  Натиснути На торговельний майданчик
	...  AND  old_search.Активувати вкладку Державних закупівель
	...  AND  Перевірити заголовок вкладки публічні закупівлі  Конкурентні процедури
	...  AND  Перевірити заголовок вкладки публічні закупівлі  Неконкурентні процедури
	...  AND  Перевірити заголовок вкладки публічні закупівлі  Плани
	...  AND  Перевірити заголовок вкладки публічні закупівлі  Договори
	...  AND  Перевірити наявність торгів
	...  AND  old_search.Розгорнути Розширений Пошук
  	...  AND  Click Element  ${dropdown menu for bid forms}
	[Template]  Перевірити наявність тексту в випадаючому списку
	Допорогові закупівлі
	Відкриті торги
	Відкриті торги з публікацією англійською мовою
	Переговорна процедура для потреб оборони
	Відкриті торги для закупівлі енергосервісу
	Конкурентний діалог 2-ий етап
	Конкурентний діалог з публікацією англійською мовою 2-ий етап
	Конкурентний діалог 1-ий етап
	Конкурентний діалог з публікацією англійською мовою 1-ий етап


Перевірити процедури закупівель
	[Tags]  procurement
	[Setup]  No Operation
	[Template]  Перевірити Конкурентні процедури за назвою
	Допорогові закупівлі
	Відкриті торги
	Відкриті торги з публікацією англійською мовою
	Переговорна процедура для потреб оборони
	Відкриті торги для закупівлі енергосервісу
	Конкурентний діалог 2-ий етап
	Конкурентний діалог з публікацією англійською мовою 2-ий етап
	Конкурентний діалог 1-ий етап
	Конкурентний діалог з публікацією англійською мовою 1-ий етап


Перевірити список доступних торгів для Державні закупівлі прозорро Неконкурентні процедури
	[Tags]  procurement
	[Setup]  Run Keywords
	...  Test Precondition
	...  AND  Натиснути На торговельний майданчик
	...  AND  old_search.Активувати вкладку Державних закупівель
	...  AND  Активувати вкладку Державних закупівель за типом  Неконкурентні процедури
	...  AND  Перевірити наявність торгів
	...  AND  old_search.Розгорнути Розширений Пошук
  	...  AND  Click Element  ${dropdown menu for bid forms}
	[Template]  Перевірити наявність тексту в випадаючому списку
	Звіт про укладений договір
	Переговорна процедура
	Переговорна процедура (скорочена)


Перевірити Державні закупівлі прозорро Неконкурентні процедури
	[Tags]  procurement
	[Setup]  No Operation
	[Template]  Перевірити Неконкурентні процедури за назвою
	Звіт про укладений договір
	Переговорна процедура
	Переговорна процедура (скорочена)


Державні закупівлі прозорро Плани
	[Tags]  procurement
	Натиснути На торговельний майданчик
	old_search.Активувати вкладку Державних закупівель
	Перевірити заголовок вкладки публічні закупівлі  Плани
	old_search.Активувати вкладку Державних закупівель за типом  Плани
	Перевірити наявність планів
	${title}  Отримати назву плану за номером  1
	plany.Перейти по результату пошуку за номером  1
	Порівняти назву плану  ${title}


Державні закупівлі прозорро Договори
	[Tags]  procurement
	Натиснути На торговельний майданчик
	old_search.Активувати вкладку Державних закупівель
	Перевірити заголовок вкладки публічні закупівлі  Договори
	old_search.Активувати вкладку Державних закупівель за типом  Договори
	Перевірити наявність договорів
	${id}  Отримати uaid договору за номером  1
	new_search.Перейти по результату пошуку за номером  1
	Перевірити заголовок договору  ${id}


Перевірити список доступних торгів для Аукціони на продаж активів банків
	[Tags]  sales
	[Setup]  Run Keywords
	...  Test Precondition
	...  AND  Зайти на сторінку аукціони на продаж активів банків
	...  AND  Перевірити заголовок аукціони на продаж активів банків
	...  AND  Перевірити вкладку аукціони на продаж активів банків
	...  AND  Порахувати кількість аукціонів на продаж
	...  AND  old_search.Розгорнути Розширений Пошук
  	...  AND  Click Element  ${dropdown menu for bid forms}
	[Template]  Перевірити наявність тексту в випадаючому списку
	Продаж права вимоги за кредитними договорами
	Продаж майна банків, що ліквідуються
	Голландський аукціон


Продаж права вимоги за кредитними договорами
	[Tags]  sales
	Зайти на сторінку аукціони на продаж активів банків
	old_search.Розгорнути Розширений Пошук
	old_search.Вибрати Тип Процедури  ${TESTNAME}
	old_search.Виконати пошук тендера
	old_search.Перейти по результату пошуку за номером  last()
	Перевірити тип процедури  ${info form for sales}


Продаж майна банків, що ліквідуються
	[Tags]  sales
	Зайти на сторінку аукціони на продаж активів банків
	old_search.Розгорнути Розширений Пошук
	old_search.Вибрати Тип Процедури  ${TESTNAME}
	old_search.Виконати пошук тендера
	old_search.Перейти по результату пошуку за номером  last()
	Перевірити тип процедури  ${info form for sales}


Голландський аукціон
	[Tags]  sales
	Зайти на сторінку аукціони на продаж активів банків
	old_search.Розгорнути Розширений Пошук
	old_search.Вибрати Тип Процедури  ${TESTNAME}
	old_search.Виконати пошук тендера
	old_search.Перейти по результату пошуку за номером  last()
	Перевірити тип процедури  ${info form for sales}


Майно
	[Tags]  sales
	Зайти на сторінку аукціони на продаж активів банків
	Перевірити вкладку активи
	Порахувати кількість прав
	Вибрати тип активу та виконати пошук  ${TESTNAME}
	Перейти по результату пошуку  ${auction active item}
	Перевірити тип процедури  ${info form4}


Права вимоги
	[Tags]  sales
	Зайти на сторінку аукціони на продаж активів банків
	Перевірити вкладку активи
	Вибрати тип активу та виконати пошук  ${TESTNAME}
	Перейти по результату пошуку  ${auction active item}
	Перевірити тип процедури  ${info form4}


Оренда майна
	[Tags]  sales
	Зайти на сторінку аукціони на продаж активів держпідприємств
	Порахувати кількусть торгів Аукціони на продаж активів держпідприємств
	Очистити Фільтр Пошуку Elastic
	Відфільтрувати по формі торгів_new
	Виконати пошук_new
	Перейти по результату пошуку_new  (${auction active items})//h4//a
	Перевірити тип процедури  ${info form for sales}


Продаж майна
	[Tags]  sales
	Зайти на сторінку аукціони на продаж активів держпідприємств
	Очистити Фільтр Пошуку Elastic
	Відфільтрувати по формі торгів_new
	Виконати пошук_new
	Перейти по результату пошуку_new  (${auction active items})//h4//a
	Перевірити тип процедури  ${info form for sales}


Аукціон. Мала приватизація
	[Tags]  sales
	${TESTNAME}  Run Keyword If  "${site}" == "test"  Set Variable  ${TESTNAME}
	...  ELSE  Set Variable  Англійський аукціон. Мала приватизація
	Зайти на сторінку аукціони на продаж активів держпідприємств
	Очистити Фільтр Пошуку Elastic
	Відфільтрувати по формі торгів_new  ${TESTNAME}
	Виконати пошук_new
	Перейти по результату пошуку_new  (${auction active items})//h4//a
	${TESTNAME}  Run Keyword If  "${site}" == "test"  Set Variable  Аукціон
	...  ELSE  Set Variable  ${TESTNAME}
	Перевірити тип процедури  ${info form for sales}  ${TESTNAME}


Аукціон за методом покрокового зниження стартової ціни та подальшого подання цінових пропозицій
	[Tags]  sales  -test
	${TESTNAME}  Run Keyword If  "${site}" == "test"  Set Variable  ${TESTNAME}
	...  ELSE  Set Variable  Голландський аукціон. Мала приватизація
	Зайти на сторінку аукціони на продаж активів держпідприємств
	Очистити Фільтр Пошуку Elastic
	Відфільтрувати по формі торгів_new  ${TESTNAME}
	Виконати пошук_new
	Перейти по результату пошуку_new  (${auction active items})//h4//a
	Перевірити тип процедури  ${info form for sales}  ${TESTNAME}


Об'єкти приватизації
	[Tags]  sales
	Зайти на сторінку аукціони на продаж активів держпідприємств
	Активувати вкладку  Реєстр об'єктів приватизації
	Активувати перемикач на сторінці пошуку малої приватизації  ${TESTNAME}
	Перейти по результату пошуку_new  ${small privatization item}
	Перевірити тип процедури  ${breadcrumbs}[last()]  Об'єкт приватизації


Реєстр інформаційних повідомлень
	[Tags]  sales
	Зайти на сторінку аукціони на продаж активів держпідприємств
	Активувати вкладку  Реєстр об'єктів приватизації
	Активувати перемикач на сторінці пошуку малої приватизації  ${TESTNAME}
	Перейти по результату пошуку_new  ${small privatization item}
	Перевірити тип процедури  ${breadcrumbs}[last()]  Інформаційне повідомлення


Запит цінових пропозицій
	[Tags]  rialto
	Натиснути На торговельний майданчик
	old_search.Активувати вкладку RIALTO
	Перевірити заголовок RIALTO
	Порахувати кількість торгів RIALTO
	old_search.Розгорнути Розширений Пошук
	old_search.Вибрати Тип Процедури  ${TESTNAME}
	old_search.Виконати пошук тендера
	old_search.Перейти по результату пошуку за номером  last()
	Перевірити тип процедури для закупівель


Простий тендер
	[Tags]  rialto
	Натиснути На торговельний майданчик
	old_search.Активувати вкладку RIALTO
	old_search.Розгорнути Розширений Пошук
	old_search.Вибрати Тип Процедури  ${TESTNAME}
	old_search.Виконати пошук тендера
	old_search.Перейти по результату пошуку за номером  last()
	Перевірити тип процедури для закупівель


Двохетапний тендер
	[Tags]  rialto
	Натиснути На торговельний майданчик
	old_search.Активувати вкладку RIALTO
	old_search.Розгорнути Розширений Пошук
	old_search.Вибрати Тип Процедури  ${TESTNAME}
	old_search.Виконати пошук тендера
	old_search.Перейти по результату пошуку за номером  last()
	Перевірити тип процедури для закупівель



*** Keywords ***

#######################################################
#######                                      ##########
#######               Keywords               ##########
#######                                      ##########
#######################################################
Відкрити головну сторінку SmartTender.biz під потрібною роллю
  Start In Grid  ${user}
  Run Keyword If  "tender_owner" in "${role}"  Go To  ${start_page}


Test Precondition
	${location}  Get Location
	Run Keyword If  '${start_page}' != '${location}'  Go To  ${start_page}


Test Postcondition
  Log Location
  Run Keyword If Test Failed  Capture Page Screenshot
  Run Keyword If  "${role}" != "viewer" and "${role}" != "Bened"  Перевірити користувача


Перевірити користувача
  ${status}  Run Keyword And Return Status  Wait Until Page Contains  ${name}  10
  Run Keyword If  "${status}" == "False"  Fatal Error  We have lost user


Перевірити комерційні закупівлі за назвою
	[Arguments]  ${name}
	Go To  ${start_page}/komertsiyni-torgy/
	Натиснути На торговельний майданчик
	old_search.Розгорнути Розширений Пошук
	old_search.Вибрати Тип Процедури  ${name}
	old_search.Виконати пошук тендера
	old_search.Перейти по результату пошуку за номером  last()
	Перевірити тип процедури для комерційних торгів  ${name}


Перевірити Конкурентні процедури за назвою
	[Arguments]  ${name}
	#Test Precondition
	#Натиснути На торговельний майданчик
	#old_search.Активувати вкладку Державних закупівель
	Go To  ${start_page}/publichni-zakupivli-prozorro/
	old_search.Розгорнути Розширений Пошук
	old_search.Вибрати Тип Процедури  ${name}
	old_search.Виконати пошук тендера
	old_search.Перейти по результату пошуку за номером  last()
	Дочекатись закінчення загрузки сторінки(skeleton)
	Перевірити тип процедури для закупівель  ${name}


Перевірити Неконкурентні процедури за назвою
	[Arguments]  ${name}
	#Test Precondition
	#Натиснути На торговельний майданчик
	#old_search.Активувати вкладку Державних закупівель
	#old_search.Активувати вкладку Державних закупівель за типом  Неконкурентні процедури
	Go To  ${start_page}/publichni-zakupivli-prozorro-nekonkurentni/
	old_search.Розгорнути Розширений Пошук
	old_search.Вибрати Тип Процедури  ${name}
	old_search.Виконати пошук тендера
	old_search.Перейти по результату пошуку за номером  last()
	Дочекатись закінчення загрузки сторінки(skeleton)
	Перевірити тип процедури для закупівель  ${name}


Зайти на сторінку про компанію
  Click Element  ${button pro-kompaniyu}
  Location Should Contain  pro-kompaniyu


Перевірити заголовок сторінки про компанію
  ${should header}  Set Variable  Про майданчик SmartTender
  ${is header}  Get Text  ${header text}
  Should Be Equal  ${is header}  ${should header}


Перевірити текст сторінки про компанію
  ${should text}  Set variable  Раді вітати Вас на електронному торговельному майданчику SmartTender!
  ${is text}  Get Text  ${pro-kompaniyu text}
  Should Contain  ${is text}  ${should text}


Зайти на сторінку з новинами
  Mouse Over  ${button pro-kompaniyu}
  Click Element  ${dropdown navigation}[href='/novyny/']
  Location Should Contain  novyny

Перевірити заголовок сторінки з новинами
  ${should}  Set Variable  Новини
  ${is}  Get Text  ${novyny text}
  Should Be Equal  ${is}  ${should}


Порахувати кількість новин
  ${count}  Get Element Count  ${news block}
  Run Keyword if  '${count}' == '0'  Fail  Де новини?


Перевірити пошук(ENTER)
  ${text}  Get Text  ${news block} div>a
  Input text  ${news search input}  ${text}
  Press Key  ${news search input}  \\13
  Дочекатись закінчення загрузки сторінки
  ${count}  Get Element Count  ${news block}
  Run Keyword if  '${count}' != '1'  Fail  Має бути тільки одна новина після пошуку
  Reload Page


Перевірити пошук(Click button)
  ${text}  Get Text  ${news block} div>a
  Input text  ${news search input}  ${text}
  Click Element  ${news search button}
  Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${loading}  120
  ${count}  Get Element Count  ${news block}
  Run Keyword if  '${count}' != '1'  Fail  Має бути тільки одна новина після пошуку
  Reload Page


Переглянути новину
  Open Button  ${news block} div>a
  ${header}  Get Text  css=h1
  Should Not Be Empty  ${header}
  ${news}  Get Text  css=#News
  Should Not Be Empty  ${news}


Перевірити лінк хлібних крох
  ${location}  Get Location
  Click element  xpath=//*[@class='ivu-breadcrumb']/a[last()]
  ${newlocation}  Get Location
  Should Not Be Equal  ${location}  ${newlocation}
  Run Keyword And Expect Error  *  Get Text  css=#News


Перевірити заголовок сторінки контактів
  Sleep  5
  ${should header}  Set Variable  Контакти SmartTender
  ${is header}  Get Text  ${header text}
  Should Be Equal  ${is header}  ${should header}


Порахувати кількість контактів
  ${count}  Get Element Count  ${kontakty block}
  Run Keyword if  '${count}' == '0'  Fail  Нема до кого звертатися!


Перевірити заголовок контакту
  ${should text}  Set variable  З ПИТАНЬ
  ${is text}  Get Text  ${kontakty text}
  Should Contain  ${is text}  ${should text}


Зайти на сторінку клієнтів
  Mouse Over  ${button pro-kompaniyu}
  Click Element  ${dropdown navigation}[href='/nashi-klienty/']
  Location Should Contain  /nashi-klienty/


Перевірити заголовок сторінки клієнтів
  Element Text Should Be  ${nashi-klienty text}  Індивідуальні рішення
  Element Text Should Be  ${nashi-klienty text1}  Останнім часом до нас приєдналися


Порахувати кількість клієнтів
  ${count}  Get Element Count  ${client banner}
  Run Keyword if  ${count} < 5  Fail  Хто увів клієнтів?
  Click Element  css=.container .row>button
  Sleep  1
  ${count}  Get Element Count  ${client banner}
  Run Keyword if  ${count} < 5  Fail  Хто увів клієнтів?


Зайти на сторінку вакансій
  Mouse Over  ${button pro-kompaniyu}
  Click Element  ${dropdown navigation}[href='/vakansii/']
  Location Should Contain  /vakansii/


Перевірити заголовок сторінки вакансій
  ${should}  Set variable  Вакансії
  ${is}  Get Text  ${vakansii text}
  Should Be Equal  ${is}  ${should}


Зайти на сторінку с подіями
  Click Element  ${button podii}
  Location Should Contain  /podii/


Превірити заголовок сторінки подій
  ${should}  Set variable  Заходи SmartTender
  ${is}  Get Text  ${novyny text}
  Should Be Equal  ${is}  ${should}


Перевірити наявність календаря
  Page Should Contain Element  css=div#calendar[class]


Зайти на сторінку реєстрації
  Click Element  ${RegisterAnchor}
  Location Should Contain  /reestratsiya/


Перевірити заголовок сторінки реєстрації
  ${should}  Set variable  Реєстрація
  ${is}  Get Text  ${h1 header text}
  Should Be Equal  ${is}  ${should}


Перевірити підзаголовок сторінки реєстрації
  ${should}  Set variable  Персональна інформація
  ${is}  Get Text  css=.main-content h3
  Should Be Equal  ${is}  ${should}


Відкрити сторінку інструкцій
  Click Element  xpath=//*[@href='/instruktcii/']
  Location Should Contain  instruktcii
  Дочекатись закінчення загрузки сторінки


Перевірити заголовок сторінки інструкцій
  ${get}  Get Text  xpath=//h1
  Should Be Equal  ${get}  Інструкції


Перевірити випаючий список інструкцій
  ${field}  Set Variable  (//*[@class='ivu-card-body'])[1]//span[contains(text(), "Інструкції для")]
  ${element from dropdown menu}  Set Variable  (//*[@class='ivu-card-body'])[1]//ul/li[@class]
  Click Element  ${field}
  ${n}  Get Element Count  (//*[@class='ivu-card-body'])[1]//ul/li[@class]
  ${list}  Create List
  :FOR  ${i}  IN RANGE  ${n}
  \  ${t}  Evaluate  str(${i}+1)
  \  ${r}  Get Text  ${element from dropdown menu}[${t}]
  \  Append To List  ${list}  ${r}
  List Should Contain Value  ${list}  Показати всі
  List Should Contain Value  ${list}  Інструкції загального напрямку
  List Should Contain Value  ${list}  Інструкції для організатора
  List Should Contain Value  ${list}  Інструкції для учасника
  Click Element  ${field}
  Sleep  2


Перейти на сторінку карти сайту
  Page Should Contain Element  ${site map}
  ${location}  Get Location
  Go to  ${location}/karta-saytu/
  Location Should Contain  /karta-saytu/


Перевірити заголовок сторінки карта сайта
  ${should}  Set variable  Карта сайту
  ${is}  Get Text  ${novyny text}
  Should Be Equal  ${is}  ${should}


Порахувати кількість єлементів сторінки карта сайту
  ${count}  Get Element Count  css=[class="row content"] li>a
  ${number}  Run Keyword If
  ...  "${role}" == "viewer"  Set Variable  31
  ...  ELSE  Set Variable  30
  Run Keyword if  "${count}" < "${number}"  Fail  Нема всіх єлементів


Перейти на сторінку запитань
  Mouse Over  ${button komertsiyni-torgy}
  Click Element  ${dropdown navigation}[href='/zapytannya-i-vidpovidi/']
  Location Should Contain  /zapytannya-i-vidpovidi/
  Дочекатись закінчення загрузки сторінки(circle)


Перевірити заголовок сторінки запитань
  ${should}  Set variable  Питання та відповіді
  ${is}  Get Text  ${novyny text}
  Should Be Equal  ${is}  ${should}


Порахувати кількість запитань
  Select Frame  css=iframe
  ${count}  Get Element Count  css=#faqGroupTree>div>div.hover-div
  Run Keyword if  ${count} < 5  Fail  Хто сховав Питання та відповіді?!
  Unselect Frame


Перевірити закладку неконкурентні процедури
  Click Element  ${torgy top/bottom tab}(2) ${torgy count tab}(2)
  ${should}  Set variable  Неконкурентні процедури
  ${is}  Get Text  ${torgy top/bottom tab}(2) ${torgy count tab}(2)
  Should Be Equal  ${is}  ${should}


Перевірити закладку закупівлі договори
  Click Element  ${torgy top/bottom tab}(2) ${torgy count tab}(4)
  ${should}  Set variable  Комерційні торги та публічні закупівлі в системі ProZorro - Договори
  ${is}  Get Text  ${novyny text}
  ${error_status}  Run Keyword And Return Status  Should Be Equal  ${is}  ${should}
  Run Keyword If  ${error_status}==${False}  Перевірити SEO  ${is}  h1


Перевірити SEO
  [Arguments]  ${is}  ${seo_field}
  ${url}  Get Location
  ${should}  get_seo_data  ${seo_field}  ${site}  ${url}
  Should Be Equal  ${is}  ${should}


Перевірити наявність торгів
	${n}  old_search.Порахувати кількість торгів
	Run Keyword if  '${n}' == '0'  Fail  Як це нема торгів?!


Перевірити наявність договорів
	${n}  new_search.Порахувати кількість торгів
	Run Keyword if  '${n}' == '0'  Fail  Як це нема торгів?!


Зайти на сторінку аукціони на продаж активів банків
  Натиснути На торговельний майданчик
  Click Element  ${torgy top/bottom tab}(1) ${torgy count tab}(3)


Перевірити заголовок аукціони на продаж активів банків
  ${should}  Set variable  Аукціони на продаж активів банків
  ${is}  Get Text  ${torgy top/bottom tab}(1) ${torgy count tab}(3)
  Should Be Equal  ${is}  ${should}


Перевірити вкладку аукціони на продаж активів банків
  ${should}  Set variable  Аукціони
  ${is}  Get Text  ${torgy top/bottom tab}(2) ${torgy count tab}(1)
  Should Be Equal  ${is}  ${should}


Порахувати кількість аукціонів на продаж
  ${count}  Get Element Count  ${auction active items}
  Run Keyword if  '${count}' == '0'  Fail  Як це нема торгів?!


Перевірити вкладку активи
  Click Element  ${torgy top/bottom tab}(2) ${torgy count tab}(2)
  Дочекатись закінчення загрузки сторінки
  ${should}  Set variable  Реєстр активів ФГВФО
  ${is}  Get Text  ${auction active header}
  Should Be Equal  ${is}  ${should}


Порахувати кількість прав
  ${count}  Get Element Count  ${auction active item}
  Run Keyword if  '${count}' == '0'  Fail  Як це без прав?!


Зайти на сторінку аукціони на продаж активів держпідприємств
  Натиснути На торговельний майданчик
  Click Element  ${torgy top/bottom tab}(1) ${torgy count tab}(4)
  Дочекатись закінчення загрузки сторінки(skeleton)


Порахувати кількусть торгів Аукціони на продаж активів держпідприємств
  ${count}  Get Element Count  ${auction active items}
  Run Keyword if  '${count}' == '0'  Fail  Як це нема торгів?!


Відкрити вікно договору
  Click Element  ${button dogovir}
  Sleep  3


Перевірити перший абзац договору
  Select Frame  css=#ui-id-1>iframe
  ${should text}  Set Variable  Для участі у будь-якому статусі в електронних торгах (закупівлях) Вам необхідно укласти відповідний договір із Оператором електронного майданчика Smarttender.biz. Для цього Ви може скористатися Акцептом оферти (прийняття умов договору приєднання).
  ${is text}  Get Text  css=p
  Should Contain  ${is text}  ${should text}


Перевірити лінки в тексті договору
  ${should link1}  Set Variable  https://smarttender.biz/instruktsii/dogovir-pryednannya-so-2015-003-pro-nadannya-informatsiynyh-poslug-pid-chas-provedennya-protsedur-publichnyh-zakupivel-prozorro-ta-zakupivel-rialto/
  ${should link2}  Set Variable  https://smarttender.biz/instruktsii/dogovir-pryednannya-so-2016-001-pro-nadannya-poslug-z-organizatsii-ta-provedennya-vidkrytyh-elektronnyh-torgiv-auktsioniv/
  ${is link1}  Get Element Attribute  ${contract link1}  href
  ${is link2}  Get Element Attribute  ${contract link2}  href
  Should Be Equal  ${is link1}  ${should link1}
  Should Be Equal  ${is link2}  ${should link2}
  Unselect Frame


Відкрити вікно курсів валют
  Mouse Over  ${button komertsiyni-torgy}
  Click Element  ${dropdown navigation}[href='/kursy-valyut/']


Перевірити шлях курсів валют
  Location Should Contain  kursy-valyut


Перевірити заголовок курсів валют
  ${should header}  Set Variable  Курсы валют
  ${is header}  Get Text  ${exchange rates header}
  Should Be Equal  ${is header}  ${should header}


Перевірити лінки курсів валют
  Select Frame  css=#main #content iframe
  ${should link1}  Set Variable  http://www.bank.gov.ua/control/uk/curmetal/currency/
  ${should link2}  Set Variable  http://minfin.com.ua/currency/mb/archive/usd/
  ${is link1}  Get Element Attribute  ${exchange link1}  href
  ${is link2}  Get Element Attribute  ${exchange link2}  href
  Should Contain  ${is link1}  ${should link1}
  Should Contain  ${is link2}  ${should link2}
  Unselect Frame


Відфільтрувати по статусу торгів
  [Arguments]  ${status}
  Click Element  ${dropdown menu for bid statuses}
  Click Element  xpath=//li[text()='${status}']


Перевірити тип процедури для комерційних торгів
	[Arguments]  ${text}=${TESTNAME}
	${is}  komertsiyni_torgy_tender_detail_page.Отримати форму торгів
	Should Contain  ${is}  ${text}


Перевірити тип процедури для закупівель
	[Arguments]  ${text}=${TESTNAME}
	${is}  procurement_tender_detail.Отритами дані зі сторінки  ['procedure-type']
	Should Contain  ${is}  ${text}


Перевірити наявність тексту в випадаючому списку
  [Arguments]  ${bid form}
  Set Focus To Element  xpath=//li[contains(text(), '${bid form}')]
  Wait Until Page Contains Element  xpath=//li[contains(text(), '${bid form}')]


Вибрати тип активу та виконати пошук
  [Arguments]  ${selector}
  Click Element  ${advanced search2}
  Click Element  xpath=//span[contains(text(),'Оберіть тип активу')]
  Wait Until Page Contains Element  xpath=//li[contains(text(),'${selector}')]
  Click Element  xpath=//li[contains(text(),'${selector}')]
  Дочекатись закінчення загрузки сторінки(sales spin)


Зайти на сторінку тарифів
  Click Element  ${button taryfy}
  Location Should Contain  /taryfy/


Перевірити кількість закладок
  Select Frame  css=iframe
  ${count}  Get Element Count  ${taryfy text}
  Run Keyword if  '${count}' != '4'  Fail  Не вірна кількість закладок тарифів


Закладка Публічні закупівлі
  Click Element  ${taryfy text}[1]
  Page Should Contain Element  ${taryfy text}[1][@class="active"]
  ${should}  Set variable   Публічні закупівлі ProZorro та торги RIALTO
  ${is}  Get Text  ${taryfy text}[1]
  Should Be Equal  ${is}  ${should}


Закладка Комерційні торги
  Click Element  ${taryfy text}[2]
  Page Should Contain Element  ${taryfy text}[2][@class="active"]
  ${should}  Set variable    Комерційні торги
  ${is}  Get Text  ${taryfy text}[2]
  Should Be Equal  ${is}  ${should}


Закладка Продаж активів банків, що ліквідуються (ФГВФО)
  Click Element  ${taryfy text}[3]
  Page Should Contain Element  ${taryfy text}[3][@class="active"]
  ${should}  Set variable    Продаж активів банків, що ліквідуються (ФГВФО)
  ${is}  Get Text  ${taryfy text}[3]
  Should Be Equal  ${is}  ${should}


Закладка Продаж і оренда майна/активів Державних підприємств
  Click Element  ${taryfy text}[4]
  Page Should Contain Element  ${taryfy text}[4][@class="active"]
  ${should}  Set variable    Продаж і оренда майна/активів Державних підприємств
  ${is}  Get Text  ${taryfy text}[4]
  Should Be Equal  ${is}  ${should}
  Unselect Frame


Перевірити сторінку окремого лота в мультилоті
  Go Back
  ${status}  Run Keyword And Ignore Error  Перейти по результату пошуку  ${last found multiple element}
  ${presence}  Run Keyword If  '${status[0]}' == 'PASS'  Перевірити наявність декалькох лотів
  Run Keyword If  '${presence}' == 'True'
  ...  Перевірити лот в мультилоті


Перевірити наявність декалькох лотів
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${first lot}
  [Return]  ${status}


Перевірити лот в мультилоті
  ${lot name}  Get Text  ${first lot}/div
  Click Element  ${first lot}/div//a
  Location Should Contain  /lot/details/
  Wait Until Page Contains Element  css=[data-qa="main-block"] [data-qa="title"]
  Sleep  1
  ${text}  Get Text  css=[data-qa="main-block"] [data-qa="title"]
  Should Be Equal  ${text}  ${lot name}
  ${status}  Get Text  //*[@data-qa="status"]
  Run Keyword If  "${role}" != "tender_owner" and "${status}" != "Відмінений"  Run Keywords
  ...  Page Should Contain Element  //*[@data-qa="bid-button"]
  ...  AND  Page Should Contain Element  //*[@data-qa="jurist-help-dropdown"]


Вибрати тип процедури для малої приватизації
  Click Element  //*[contains(text(), "${TESTNAME}")]
  Дочекатись закінчення загрузки сторінки(skeleton)
  ${status}  Run Keyword And Return Status  Page Should Contain Element
  ...  //*[contains(text(), "${TESTNAME}")]/../*[contains(@class, 'checked')]
  Run Keyword If  '${status}' == 'False' and "${TESTNAME}" != "Аукціони"  Вибрати тип процедури для малої приватизації


Порахувати кількість торгів малої приватизації
  ${n}  Get Element Count  //*[@class="content-block"]/div
  Run Keyword if  '${n}' < 1  Fail  Look above


Перевірити пошук малої приватизації
  Wait Until Page Contains Element  //*[@class="content-block"]/div[last()]//*[contains(text(), 'UA')]  15
  ${id}  Get Text  //*[@class="content-block"]/div[last()]//*[contains(text(), 'UA')]
  Виконати пошук малої приватизації  ${id}
  Open Button  //*[@class="content-block"]/div//a
  Дочекатись закінчення загрузки сторінки(skeleton)
  ${text}  Get Text  //*[@class="ivu-card-body"]//a[@href and @rel="noopener noreferrer"]|//h4/a|//h4/following-sibling::a
  Should Be Equal  ${text}  ${id}


Виконати пошук малої приватизації
  [Arguments]  ${id}
  Input Text  //*[contains(@class, 'inner-button')]//input  ${id}
  Click Element  //*[contains(@class, 'inner-button')]//input/following-sibling::*//button
  Дочекатись закінчення загрузки сторінки(skeleton)
  ${n}  Get Element Count  //*[@class="content-block"]/div
  Should Be Equal  '${n}'  '1'


Зайти на сторінку пошуку elastic
  Go To  ${start_page}/Participation/tenders/
  Дочекатись закінчення загрузки сторінки(skeleton)


Виконати пошук в elastic
  [Arguments]  ${text}
  Input Text  ${elastic search input}  ${text}
  Click Element  ${elastic search button}
  Дочекатись закінчення загрузки сторінки(skeleton)
  Wait Until Page Contains Element  ${elastic search clean filter}


Очистити фільтр пошуку elastic
	${status}  Run Keyword And Return Status  Page Should Contain Element  ${elastic search clean filter}
	Run Keyword If  ${status} == ${True}  Run Keywords
	...  Wait Until Keyword Succeeds  10  1  Click Element  ${elastic search clean filter}
	...  AND  Дочекатись закінчення загрузки сторінки(skeleton)
	...  AND  Wait Until Element Is Not Visible  ${elastic search clean filter}


Зайти на сторінку блогу
  Mouse Over  ${button pro-kompaniyu}
  Click Element  ${dropdown navigation}[href='/blog/']
  Location Should Contain  /blog/


Перевірити загловок блогу
   Element Should Contain  //h1  Блог


Перевірити наявність блогів
  ${count}  Get Element Count  ${blog}
  Run Keyword if  ${count} < 1  Fail  2018+, не можна без блогів!


Перевірити пошук на сторінці блогів
  ${get}  Get Text  ${blog}>div a
  Input Text  ${blog input}  ${get}
  Click Element  ${blog search button}
  Дочекатись закінчення загрузки сторінки
  ${count}  Get Element Count  ${blog}
  Run Keyword if  ${count} != 1  Fail  Повинен залишитися тільки один БЛОГ!
  [Return]  ${get}


Відкрити Блог
  Open Button  ${blog} a


Перевірити відкритий блог
  [Arguments]  ${title}
  Element Should Contain  //h1  ${title}
  Page Should Contain Element  css=#NewsContent


Зайти на сторінку відгуків
  Mouse Over  ${button pro-kompaniyu}
  Click Element  ${dropdown navigation}[href='/vidhuky/']
  Location Should Contain  /vidhuky/


Перевірити заголовок відгуків
  Element Should Contain  //h1  Відгуки


Перевірити наявність відгуків
  ${count}  Get Element Count  ${vidhuky}
  Run Keyword if  ${count} < 6  Fail  оу, а було як мінінмум 6 відгуків


Відкрити та перевірити відгук
  Click Element  ${vidhuky}
  Wait Until Page Contains Element  //div[@id="pdf-main-container"]//*[@id="div-pdf-canvas"]|//*[@class="ivu-modal-content"]//img  10


create_e-mail
  ${n}  random_number  4  12
  ${name}  Generate Random String  ${n}  [LOWER]
  [Return]  ${name}@gmail.com


Перевірити наявність перемикача для активування сповіщень
  ${element}  Set Variable  //*[@class="ivu-row" and contains(., "Періодичність оповіщення про публікацію")]//span[contains(@class, "ivu-switch")]
  Page Should Contain Element  ${element}


Перевірити блок Ключові слова
  Перевірити заголовок Ключові слова
  Перевірити неактивність перемикачів Ключові слова
  Перевірити поле вводу Ключові слова
  Перевірити checkbox Ключові слова


Перевірити заголовок Ключові слова
  ${element}  Set Variable  (//h4)[6]
  Element Should Contain  ${element}  Ключові слова


Перевірити неактивність перемикачів Ключові слова
  ${element}  Set Variable  //*[@class="ivu-card-body" and contains(., "Ключові слова")]


Розгорнути перший лот
  Run Keyword If  '${multiple status}' == 'multiple'  Click Element  ${block}[2]//button


Додати файл до openeu
  Run Keyword If  '${multiple status}' == 'multiple'  Створити та додати PDF файл  2
  ...  ELSE  Створити та додати PDF файл  1


Активувати вкладку
	[Arguments]  ${text}=Реєстр об'єктів приватизації
	${selector}  Set Variable  //*[contains(@class, "tab-pane") and contains(., "${text}")]
	${class}  Get Element Attribute  ${selector}  class
	${tab status}  Run Keyword And Return Status  Should Contain  ${class}  active
	Run Keyword If  ${tab status} == ${False}  Wait Until Keyword Succeeds  10  1  Click Element  ${selector}
	Дочекатись закінчення загрузки сторінки(skeleton)


Перевірити заголовок вкладки комерційні торги
	[Arguments]  ${text}
	${i}  Run Keyword If
	...  'Закупівлі' == '${text}'  Set Variable  1  ELSE IF
	...  'Продажі' == '${text}'  Set Variable  2
	${is}  Get Text  ${torgy top/bottom tab}(2) ${torgy count tab}(${i})
	Should Be Equal  ${is}  ${text}


Перевірити заголовок вкладки публічні закупівлі
	[Arguments]  ${text}
	${i}  Run Keyword If
	...  'Конкурентні процедури' == '${text}'  Set Variable  1  ELSE IF
	...  'Неконкурентні процедури' == '${text}'  Set Variable  2  ELSE IF
	...  'Плани' == '${text}'  Set Variable  3  ELSE IF
	...  'Договори' == '${text}'  Set Variable  4
	${is}  Get Text  ${torgy top/bottom tab}(2) ${torgy count tab}(${i})
	Should Be Equal  ${is}  ${text}


Перевірити заголовок вкладки ФГВ
	[Arguments]  ${text}
	${i}  Run Keyword If
	...  'Аукціони' == '${text}'  Set Variable  1  ELSE IF
	...  'Реєстр активів' == '${text}'  Set Variable  2
	${is}  Get Text  ${torgy top/bottom tab}(2) ${torgy count tab}(${i})
	Should Be Equal  ${is}  ${text}


Перевірити назву вкладки Комерційні торги
	${should}  Set variable  Комерційні торги (тендери SmartTender)
	${is}  Get Text  ${torgy top/bottom tab}(1) ${torgy count tab}(1) p
	Should Be Equal  ${is}  ${should}


Перевірити назву вкладки Державних закупівель
	${should}  Set variable  Публічні (державні) закупівлі PROZORRO
	${is}  Get Text  ${torgy top/bottom tab}(1) ${torgy count tab}(2)
	Should Be Equal  ${is}  ${should}


Перевірити назву вкладки ФГВ
	${should}  Set variable  Аукціони на продаж активів банків
	${is}  Get Text  ${torgy top/bottom tab}(1) ${torgy count tab}(3)
	Should Be Equal  ${is}  ${should}


Перевірити назву вкладки ФГИ
	${should}  Set variable  Аукціони на продаж активів держпідприємств
	${is}  Get Text  ${torgy top/bottom tab}(1) ${torgy count tab}(4)
	Should Be Equal  ${is}  ${should}


Перевірити назву вкладки RIALTO
	${should}  Set variable  Торги RIALTO
	${is}  Get Text  ${torgy top/bottom tab}(1) ${torgy count tab}(5)
	Should Be Equal  ${is}  ${should}


Перевірити наявність планів
	${count}  plany.Порахувати кількість плану
	Run Keyword if  '${count}' == '0'  Fail  Як це ми без плану?!


Перевірити тип процедури
	[Arguments]  ${selector}  ${type}=${TESTNAME}
	Дочекатись закінчення загрузки сторінки(skeleton)
	Wait Until Keyword Succeeds  20  1  Wait Until Page Contains Element  ${selector}
	Sleep  .5
	${is}  Get Text  ${selector}
	Should Contain  ${is}  ${type}
