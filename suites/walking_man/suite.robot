*** Settings ***
Resource  ../../src/src.robot
Test Setup  Test Precondition
Test Teardown  Test Postcondition
Suite Setup  Відкрити головну сторінку SmartTender.biz під потрібною роллю
Suite Teardown  Close All Browsers


*** Variables ***
${button podii}                     css=#LoginDiv [href='/podii/']
${kontakty text}                    css=div[itemscope=itemscope]>div.ivu-card:nth-child(1) span
${auction active items}             //tbody/tr[@class='head']|//*[@id='hotTrades']/div/div|//*[@class="panel-body"]
${auction active header}            css=.ivu-card-body h4
${instruktsii link}                 css=#LoginDiv a[href='/instruktсii/']
${feedback link}                    css=.footer-feedback a
${exchange link1}                   xpath=//div[@class='bank-view'][1]//a
${exchange link2}                   xpath=//div[@class='bank-view'][2]//a
${contract link1}                   css=li:nth-child(1)>a
${contract link2}                   css=li:nth-child(2)>a
${dropdown menu for bid statuses}   xpath=//label[contains(text(),'Статуси')]/../../ul
${info form for sales}              xpath=//h5[@class='label-key' and contains(text(), 'Тип процедури')]/following-sibling::p
${first lot}                        //*[@data-qa="lot-list-block"]//*[@data-qa="value-list"]
${num_of_tenders}                   xpath=(//*[@class="num"])[3]
${analytics_page}                   /ParticipationAnalytic/?segment=3&organizationId=226
${tender_type_procurement}          //*[@data-qa="procedure-type"]//div[2]//*|//*[@class="info_form"]
${report}                           //*[@class="ivu-card-body"]//*[@class="favoriteStar"]
${last found multiple element}		  xpath=(//*[@id='tenders']//*[@class='head']//span[@class='Multilots']/../..//a[@class='linkSubjTrading'])[last()]


*** Test Cases ***
Аналітика участі
  [Tags]  your_account  -test
  start_page.Відкрити особистий кабінет
  personal_account.Відкрити сторінку за назвою  analytics
  Відкрити аналітику по конкуренту  ТОВАРИСТВО З ОБМЕЖЕНОЮ ВІДПОВІДАЛЬНІСТЮ "УКРАЇНСЬКИЙ ПАПІР"
  analytics.Змінити період аукціону  Минулий місяць
  ${status}  analytics.Перевірити відображення діаграм
  Should Be Equal  ${status}  ${True}
  ${status}  analytics.Перевірити відображення таблиці
  Should Be Equal  ${status}  ${True}
  analytics.Перевірити роботу кругової діаграми
  Перевірити роботу фільтра по періоду  Минулий місяць  Поточний рік


Налаштування підписки
  [Tags]  your_account
  [Setup]  Go To  ${start page}/webparts/?id=_PERSONALCABINET
  personal_account.Відкрити сторінку за назвою  subscription
  Перевірити блок запиту допомоги з налаштування підписки
  Перевірити блок Персональне запрошення організатора
  Перевірити блок E-mail адреси для дублювання всіх розсилок
  Перевірити вкладки підписки на закупівлю
  Перевірити вкладки підписки на продаж


Заявки на отримання тендерного забезпечення
  [Tags]  your_account
  [Setup]  Go To  ${start page}/webparts/?id=_PERSONALCABINET
  personal_account.Відкрити сторінку за назвою  tender_providing


Юридична допомога
  [Tags]  your_account  -ip
  [Setup]  Go To  ${start page}/webparts/?id=_PERSONALCABINET
  personal_account.Відкрити сторінку за назвою  legal_help


Особисті дані користувача
  [Tags]  your_account
  [Setup]  Go To  ${start page}/webparts/?id=_PERSONALCABINET
  Run Keyword If  '${site}' == 'prod'
  ...  personal_account.Відкрити сторінку за назвою  company_profile
  Run Keyword If  '${site}' == 'test'
  ...  personal_account.Відкрити сторінку за назвою  user_profile


Змінити пароль
  [Tags]  your_account  -ip
  [Setup]  Go To  ${start page}/webparts/?id=_PERSONALCABINET
  personal_account.Відкрити сторінку за назвою  change_password


Управління користувачами
  [Tags]  your_account
  [Setup]  Go To  ${start page}/webparts/?id=_PERSONALCABINET
  personal_account.Відкрити сторінку за назвою  user_management


Звіти
  [Tags]  your_account
  [Setup]  Go To  ${start page}/webparts/?id=_PERSONALCABINET
  personal_account.Відкрити сторінку за назвою  reports
  reports.Встановити фільтр Тільки обрані звіти  увімкнути
  Прибрати усі звіти з обраних
  reports.Встановити фільтр Тільки обрані звіти  вимкнути
  ${name}  Додати в обрані випадковій звіт та повернути назву
  reports.Встановити фільтр Тільки обрані звіти  увімкнути
  reports.Перевірити наявність звіту за назвою  ${name}
  Прибрати усі звіти з обраних


Відгуки
	[Tags]  site  -test
	Навести мишку на  Про компанію
	Натиснути на елемент з випадаючого списка  Відгуки
	Перевірити заголовок сторінки відгуків
	Перевірити наявність відгуків
	vidhuky.Відкрити відгук


Блог
	[Tags]  site  -test
	Навести мишку на  Про компанію
	Натиснути на елемент з випадаючого списка  Блог
	blog.Перевірити загловок блогу
	Перевірити наявність блогів
	${title}  blog.Отримати назву блогу за номером  1
	blog.Ввести текст для пошуку  ${title}
	blog.Виконати пошук
	Перевірити результат пошуку на сторінці блогів
	blog.Відкрити Блог за номером  1
	Перевірити відкритий блог  ${title}


Договір
	[Tags]  site  -test
	header_old.Відкрити вікно договору
	contract.Перевірити заголовок договору
	contract.Перевірити перший абзац договору
	contract.Перевірити лінки в тексті договору


Про компанію
	[Tags]  site
	header_old.Відкрити Сторінку Про Компанію
	pro_kompaniyu.Перевірити заголовок сторінки
	pro_kompaniyu.Звірити початок тексту на сторінці


Новини
	[Tags]  site
	Навести мишку на  Про компанію
	Натиснути на елемент з випадаючого списка  Новини
	Перевірити заголовок сторінки з новинами
	Перевірити наявність новин
	Перевірити пошук новин через  click
	Перевірити пошук новин через  press
	${title}  Отримати заголовк новини за номером  1
	novyny.Відкрити новину за номером  1
	Перевірити заголовок відкритої новини  ${title}
	#Перевірити лінк хлібних для новин


Контакти
	[Tags]  site
	Зайти на сторінку contacts
	Перевірити наявність контактів


З ким ми працюємо
	[Tags]  site  -test
	Навести мишку на  Про компанію
	Натиснути на елемент з випадаючого списка  З ким ми працюємо
	nashi_klienty.Перевірити заголовок
	Перевірити наявність клієнтів
	${count1}  nashi_klienty.Порахувати кількість клієнтів
	# Зі сторінки прибрали кнопку "Показати ще"
	#nashi_klienty.Натиснути "Показати ще"
	#${count2}  nashi_klienty.Порахувати кількість клієнтів
	#Run Keyword If  ${count1} >= ${count2}  Fail  Кнопка "Показати ще" не працюе


Вакансії
	[Tags]  site
	Навести мишку на  Про компанію
	Натиснути на елемент з випадаючого списка  Вакансії
	vakansii.Перевірити заголовок сторінки вакансій


Тарифи
	[Tags]  site
	Відкрити сторінку Тарифів
	taryfy.Перевірити кількість закладок
	taryfy.Активувати вкладку  Публічні закупівлі ProZorro та торги RIALTO
	taryfy.Активувати вкладку  Комерційні торги
	taryfy.Активувати вкладку  Продаж активів банків, що ліквідуються (ФГВФО)
	taryfy.Активувати вкладку  Продаж і оренда майна/активів Державних підприємств


Реєстрація
	[Tags]  site
	Run Keyword if  '${role}' != 'viewer'  Pass Execution  only for viewer
	header_old.Відкрити сторінку Реєстрація


Інструкції
	[Tags]  site
	header_old.Відкрити сторінку інструкцій
	Перевірити наявність інструкцій
	instruktcii.Вибрати з видаючого списку  Показати всі
	Перевірити наявність інструкцій
	instruktcii.Вибрати з видаючого списку  Інструкції загального напрямку
	Перевірити наявність інструкцій
	instruktcii.Вибрати з видаючого списку  Інструкції для організатора
	Перевірити наявність інструкцій
	instruktcii.Вибрати з видаючого списку  Інструкції для учасника
	Перевірити наявність інструкцій


Карта сайту
	[Tags]  site
	Відкрити сторінку Карта сайту
	Порахувати кількість єлементів сторінки карта сайту


Запитання та відповіді
	[Tags]  site  -test
	Навести мишку на  Торговий майданчик
	Натиснути на елемент з випадаючого списка  Запитання та відповіді
	zapytannya_i_vidpovidi.Перевірити заголовок сторінки
	Перевірити наявність запитань


Курси валют
	[Tags]  site  -test
	Навести мишку на  Торговий майданчик
	Натиснути на елемент з випадаючого списка  Курси валют
	kursy_valyut.Перевірити заголовок сторінки
	kursy_valyut.Перевірити посилання


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
	[Tags]  commercial  -test
	[Setup]  No Operation
	[Template]  Перевірити комерційні закупівлі за назвою
	Відкриті торги. Аукціон
	Відкриті торги. Аналіз пропозицій
	Запит пропозицій
	Відкриті торги. Аналіз ринку


Перевірити комерційні закупівлі test
	[Tags]  commercial  -prod
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
	[Setup]  Go To  ${start_page}/komertsiyni-torgy-prodazhi/
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
	[Tags]  procurement -test
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
	Перевірити наявність торгів(new_search)
	${id}  Отримати uaid договору за номером  1
	new_search.Перейти по результату пошуку за номером  1
	dogovory.Перевірити заголовок договору  ${id}


Перевірити список доступних торгів для Аукціони на продаж активів банків
	[Tags]  sales
	[Setup]  Run Keywords
	...  Test Precondition  								AND
	...  Натиснути На торговельний майданчик  				AND
	...  old_search.Активувати вкладку ФГВ  				AND
	...  Перевірити назву вкладки ФГВ  						AND
	...  Перевірити заголовок вкладки ФГВ  Аукціони			AND
	...  Перевірити заголовок вкладки ФГВ  Реєстр активів	AND
	...  old_search.Розгорнути Розширений Пошук  			AND
  	...  Click Element  ${dropdown menu for bid forms}
	[Template]  Перевірити наявність тексту в випадаючому списку
	Продаж права вимоги за кредитними договорами
	Продаж майна банків, що ліквідуються
	Голландський аукціон


Перевірити аукціони
	[Tags]  sales
	[Setup]  No Operation
	[Template]  Перевірити аукціони за назвою
	Продаж права вимоги за кредитними договорами
	Продаж майна банків, що ліквідуються
	Голландський аукціон


Перевірити реєстр активів Майно
	[Tags]  sales
	Натиснути На торговельний майданчик
	Активувати вкладку ФГВ
	Активувати вкладку ФГВ за типом  Реєстр активів
	Перевірити наявність активів
	dgf-registry.Розгорнути детальний пошук
	dgf-registry.Вибрати тип активу  Майно
	dgf-registry.Перейти по результату пошуку за номером  1
	Перевірити тип процедури для активу  Майно


Перевірити реєстр активів Права вимоги
	[Tags]  sales
	[Setup]  Go To  ${start_page}/dgf-registry/
	dgf-registry.Розгорнути детальний пошук
	dgf-registry.Вибрати тип активу  Права вимоги
	dgf-registry.Перейти по результату пошуку за номером  1
	Перевірити тип процедури для активу  Права вимоги


Оренда майна
	[Tags]  sales
	Натиснути На торговельний майданчик
  	Активувати вкладку ФГИ
	new_search.Очистити фільтр пошуку
	new_search.Розгорнути фільтр  Вид торгів
	new_search.Операція над чекбоксом  Оренда майна  select
	Дочекатись закінчення загрузки сторінки(skeleton)
	new_search.Перейти по результату пошуку за номером  1
	Перевірити тип процедури для аукціонів  Оренда майна


Продаж майна
	[Tags]  sales
	[Setup]  Go To  ${start_page}/auktsiony-na-prodazh-aktyviv-derzhpidpryemstv
	new_search.Очистити фільтр пошуку
	new_search.Розгорнути фільтр  Вид торгів
	new_search.Операція над чекбоксом  Продаж майна  select
	Дочекатись закінчення загрузки сторінки(skeleton)
	new_search.Перейти по результату пошуку за номером  2
	${status}  Run Keyword And Return Status
	...  Перевірити тип процедури для аукціонів  Продаж майна
	Run Keyword If  ${status} == ${False}
	...  Перевірити тип процедури для аукціонів  Продаж дозволів на користування надрами


Аукціон. Мала приватизація
	[Tags]  sales
	[Setup]  Go To  ${start_page}/auktsiony-na-prodazh-aktyviv-derzhpidpryemstv
	${TESTNAME}  Run Keyword If  "${site}" == "test"  Set Variable  ${TESTNAME}
	...  ELSE  Set Variable  Англійський аукціон. Мала приватизація
	new_search.Очистити фільтр пошуку
	new_search.Розгорнути фільтр  Вид торгів
	new_search.Операція над чекбоксом  ${TESTNAME}  select
	Дочекатись закінчення загрузки сторінки(skeleton)
	new_search.Перейти по результату пошуку за номером  2
	${TESTNAME}  Run Keyword If  "${site}" == "test"  Set Variable  Аукціон
	...  ELSE  Set Variable  ${TESTNAME}
	Перевірити тип процедури для аукціонів  ${TESTNAME}


Аукціон за методом покрокового зниження стартової ціни та подальшого подання цінових пропозицій
	[Tags]  sales  -test
	[Setup]  Go To  ${start_page}/auktsiony-na-prodazh-aktyviv-derzhpidpryemstv
	${TESTNAME}  Run Keyword If  "${site}" == "test"  Set Variable  ${TESTNAME}
	...  ELSE  Set Variable  Голландський аукціон. Мала приватизація
	new_search.Очистити фільтр пошуку
	new_search.Розгорнути фільтр  Вид торгів
	new_search.Операція над чекбоксом  ${TESTNAME}  select
	Дочекатись закінчення загрузки сторінки(skeleton)
	new_search.Перейти по результату пошуку за номером  1
	Перевірити тип процедури для аукціонів  ${TESTNAME}


Оренда землі
	[Tags]  sales
	[Setup]  Go To  ${start_page}/auktsiony-na-prodazh-aktyviv-derzhpidpryemstv
	new_search.Очистити фільтр пошуку
	new_search.Розгорнути фільтр  Вид торгів
	new_search.Операція над чекбоксом  Оренда землі  select
	Дочекатись закінчення загрузки сторінки(skeleton)
	new_search.Перейти по результату пошуку за номером  1
	Перевірити тип процедури для аукціонів  Оренда землі



Об'єкти приватизації
	[Tags]  sales
	Натиснути На торговельний майданчик
  	Активувати вкладку ФГИ
	small_privatization_search.Активувати вкладку  Реєстр об'єктів приватизації
	small_privatization_search.Активувати перемемик процедури на  Об'єкти приватизації
	small_privatization_search.Перейти по результату пошуку за номером  1
	Перевірити тип процедури для малої приватизації  Об'єкт приватизації


Реєстр інформаційних повідомлень
	[Tags]  sales
	Натиснути На торговельний майданчик
  	Активувати вкладку ФГИ
	small_privatization_search.Активувати вкладку  Реєстр об'єктів приватизації
	small_privatization_search.Активувати перемемик процедури на  Реєстр інформаційних повідомлень
	small_privatization_search.Перейти по результату пошуку за номером  1
	Перевірити тип процедури для малої приватизації  Інформаційне повідомлення


Запит цінових пропозицій
	[Tags]  rialto
	Натиснути На торговельний майданчик
	old_search.Активувати вкладку RIALTO
	Перевірити назву вкладки RIALTO
	Перевірити наявність торгів
	old_search.Розгорнути Розширений Пошук
	old_search.Вибрати Тип Процедури  ${TESTNAME}
	old_search.Виконати пошук тендера
	old_search.Перейти по результату пошуку за номером  last()
	Перевірити тип процедури для закупівель


Простий тендер
	[Tags]  rialto
	[Setup]  Go To  ${start_page}/torgy-rialto/
	old_search.Розгорнути Розширений Пошук
	old_search.Вибрати Тип Процедури  ${TESTNAME}
	old_search.Виконати пошук тендера
	old_search.Перейти по результату пошуку за номером  last()
	Перевірити тип процедури для закупівель


Двохетапний тендер
	[Tags]  rialto
	[Setup]  Go To  ${start_page}/torgy-rialto/
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
	old_search.Розгорнути Розширений Пошук
	old_search.Вибрати Тип Процедури  ${name}
	old_search.Виконати пошук тендера
	old_search.Перейти по результату пошуку за номером  last()
	Перевірити тип процедури для комерційних торгів  ${name}


Перевірити Конкурентні процедури за назвою
	[Arguments]  ${name}
	Go To  ${start_page}/publichni-zakupivli-prozorro/
	old_search.Розгорнути Розширений Пошук
	old_search.Вибрати Тип Процедури  ${name}
	old_search.Виконати пошук тендера
	old_search.Перейти по результату пошуку за номером  last()
	Дочекатись закінчення загрузки сторінки(skeleton)
	Перевірити тип процедури для закупівель  ${name}


Перевірити Неконкурентні процедури за назвою
	[Arguments]  ${name}
	Go To  ${start_page}/publichni-zakupivli-prozorro-nekonkurentni/
	old_search.Розгорнути Розширений Пошук
	old_search.Вибрати Тип Процедури  ${name}
	old_search.Виконати пошук тендера
	old_search.Перейти по результату пошуку за номером  last()
	Дочекатись закінчення загрузки сторінки(skeleton)
	Перевірити тип процедури для закупівель  ${name}


Перевірити аукціони за назвою
	[Arguments]  ${name}
	Go To  ${start_page}/auktsiony-na-prodazh-aktyviv-bankiv/
	old_search.Розгорнути Розширений Пошук
	old_search.Вибрати Тип Процедури  ${name}
	old_search.Виконати пошук тендера
	old_search.Перейти по результату пошуку за номером  last()
	Перевірити тип процедури для аукціонів  ${name}


Перевірити наявність новин
	${count}  novyny.Порахувати кількість новин
	Run Keyword if  '${count}' == '0'  Fail  Де новини?


Перевірити пошук новин через
	[Arguments]  ${action}
	${title}  novyny.Отримати заголовк новини за номером  1
	novyny.Ввести текст для пошуку  ${title}
	novyny.Виконати пошук  ${action}
	${count}  novyny.Порахувати кількість новин
	Run Keyword if  '${count}' != '1'  Fail  Має залишитися тільки один
	Reload Page


Перевірити заголовок відкритої новини
	[Arguments]  ${title}
	${get}  Отримати заголовок відкритої новини
	Should Be Equal  ${get}  ${title}


Перевірити лінк хлібних для новин
	breadcrumbs.Перейти по хлібній крихті за номером  last()-1


Перевірити наявність контактів
	${count}  contacts.Порахувати кількість контактів
	Run Keyword if  '${count}' == '0'  Fail  Нема до кого звертатися!


Зайти на сторінку клієнтів
	Mouse Over  ${button pro-kompaniyu}
	Click Element  ${dropdown navigation}[href='/nashi-klienty/']
	Location Should Contain  /nashi-klienty/


Перевірити наявність клієнтів
	${count}  nashi_klienty.Порахувати кількість клієнтів
	Run Keyword if  ${count} < 5  Fail  Хто увів клієнтів?


Порахувати кількість єлементів сторінки карта сайту
  ${count}  karta_saytu.Порахувати кількість елементів на сторінці
  ${number}  Run Keyword If
  ...  "${role}" == "viewer"  Set Variable  31
  ...  ELSE  Set Variable  30
  Run Keyword if  "${count}" < "${number}"  Fail  Нема всіх єлементів


Перевірити наявність запитань
	${count}  zapytannya_i_vidpovidi.Порахувати кількість запитань
	Run Keyword if  ${count} < 5  Fail  Хто сховав Питання та відповіді?!


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


Перевірити наявність торгів(new_search)
	${n}  new_search.Порахувати кількість торгів
	Run Keyword if  '${n}' == '0'  Fail  Як це нема торгів?!


Перевірити наявність активів
	${n}  Порахувати активи
	Run Keyword if  '${n}' == '0'  Fail  Як це нема активів?!


Перевірити заголовок аукціони на продаж активів банків
  ${should}  Set variable  Аукціони на продаж активів банків
  ${is}  Get Text  ${torgy top/bottom tab}(1) ${torgy count tab}(3)
  Should Be Equal  ${is}  ${should}


Перевірити вкладку аукціони на продаж активів банків
  ${should}  Set variable  Аукціони
  ${is}  Get Text  ${torgy top/bottom tab}(2) ${torgy count tab}(1)
  Should Be Equal  ${is}  ${should}


Перевірити вкладку активи
  Click Element  ${torgy top/bottom tab}(2) ${torgy count tab}(2)
  Дочекатись закінчення загрузки сторінки
  ${should}  Set variable  Реєстр активів ФГВФО
  ${is}  Get Text  ${auction active header}
  Should Be Equal  ${is}  ${should}


Порахувати кількусть торгів Аукціони на продаж активів держпідприємств
  ${count}  Get Element Count  ${auction active items}
  Run Keyword if  '${count}' == '0'  Fail  Як це нема торгів?!


Відфільтрувати по статусу торгів
  [Arguments]  ${status}
  Click Element  ${dropdown menu for bid statuses}
  Click Element  xpath=//li[text()='${status}']

# todo
Перевірити тип процедури для малої приватизації
	[Arguments]  ${type}
	${breadcrumbs}  Set Variable  //*[contains(@class, "breadcrumbs")]//li
	${is}  Get Text  ${breadcrumbs}[last()]
	Should Contain  ${is}  ${type}


Перевірити тип процедури для комерційних торгів
	[Arguments]  ${text}=${TESTNAME}
	${is}  komertsiyni_torgy_tender_detail_page.Отримати форму торгів
	Should Contain  ${is}  ${text}


Перевірити тип процедури для закупівель
	[Arguments]  ${text}=${TESTNAME}
	${is}  procurement_tender_detail.Отритами дані зі сторінки  ['procedure-type']
	Should Contain  ${is}  ${text}


Перевірити тип процедури для аукціонів
	[Arguments]  ${text}=${TESTNAME}
	${is}  auction_detail_page.Отримати тип процедури
	Should Contain  ${is}  ${text}


Перевірити тип процедури для активу
	[Arguments]  ${text}=${TESTNAME}
	${is}  asset_detail_page.Отримати тип активу
	Should Contain  ${is}  ${text}


Перевірити наявність тексту в випадаючому списку
  [Arguments]  ${bid form}
  Set Focus To Element  xpath=//li[contains(text(), '${bid form}')]
  Wait Until Page Contains Element  xpath=//li[contains(text(), '${bid form}')]


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


Перевірити наявність блогів
	${count}  blog.Порахувати кількість блогів
	Run Keyword if  ${count} < 1  Fail  2018+, не можна без блогів!


Перевірити результат пошуку на сторінці блогів
	${count}  blog.Порахувати кількість блогів
	Run Keyword if  ${count} != 1  Fail  Повинен залишитися тільки один БЛОГ!


Перевірити відкритий блог
  [Arguments]  ${title}
  ${get}  blog.Отримати заголовок відкритого блогу
  Should Be Equal  ${get}  ${title}


create_e-mail
  ${n}  random_number  4  12
  ${name}  Generate Random String  ${n}  [LOWER]
  [Return]  ${name}@gmail.com


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


Відкрити аналітику по конкуренту
  [Arguments]  ${company name}
  analytics.Відкрити вікно аналітика по конкурентам
  analytics.Ввести назву компанії  ${company name}
  analytics.Вибрати конкурента з списка за номером  1


Перевірити роботу фільтра по періоду
  [Arguments]  ${before}  ${after}
  analytics.Змінити період аукціону  ${before}
  ${tenders_before}  Отримати кількість торгів
  analytics.Змінити період аукціону  ${after}
  ${tenders_after}  Отримати кількість торгів
  Run Keyword if  ${tenders_before} > ${tenders_after}  Fail  Не працює фільтрація по періоду


Перевірити блок запиту допомоги з налаштування підписки
  subscription.Натиснути на кнопку Відправити запит
  subscription.Закрити вікно Запит налаштування підписки


Перевірити блок Персональне запрошення організатора
  subscription.Перевірити заголовок Персональне запрошення організатора
  subscription.Перевірити перемикач Персональне запрошення організатора


Перевірити блок E-mail адреси для дублювання всіх розсилок
  subscription.Перевірити заголовок E-mail адреси для дублювання всіх розсилок
  Перевірити поле вводу E-mail адреси для дублювання всіх розсилок
  Перевірити поле вводу E-mail адреси для дублювання всіх розсилок(negative)


Перевірити поле вводу E-mail адреси для дублювання всіх розсилок
  ${mail}  create_e-mail
  subscription.Ввести E-mail для дублювання розсилок  ${mail}
  subscription.Видалити E-mail для дублювання розсилок за назвою  ${mail}


Перевірити поле вводу E-mail адреси для дублювання всіх розсилок(negative)
  ${n}  random_number  4  20
  ${mail}  Generate Random String  ${n}  [LOWER]
  subscription.Ввести E-mail для дублювання розсилок  ${mail}
  Wait Until Element Contains  css=.ivu-message-notice span  Неправильний формат електронної пошти
  Run Keyword And Expect Error  *  subscription.Видалити E-mail для дублювання розсилок за назвою  ${mail}


Перевірити вкладки підписки на закупівлю
  subscription.Активувати тип торгів для підписки  на продаж
  subscription.Вибрати вкладку для підписки та перевірити наявність всіх елементів в блоці категорії  Публічні закупівлі
  subscription.Вибрати вкладку для підписки та перевірити наявність всіх елементів в блоці категорії  RIALTO.Закупівлі


Перевірити вкладки підписки на продаж
  subscription.Активувати тип торгів для підписки  на продаж
  subscription.Вибрати вкладку для підписки та перевірити наявність всіх елементів в блоці категорії  Аукціони на продаж активів банків
  subscription.Вибрати вкладку для підписки та перевірити наявність всіх елементів в блоці категорії  Аукціони на продаж активів держпідприємств


Прибрати усі звіти з обраних
  :FOR  ${i}  IN RANGE  999999
    \  ${count}  reports.Прибрати звіт з обраних
    \  Exit For Loop If    ${count} == 0


Додати в обрані випадковій звіт та повернути назву
  ${count}  reports.Отримати кількість звітів
  ${report num}  random_number  1  ${count}
  reports.Додати звіт в обрані за номером  ${report num}
  ${report name}  reports.Отримати назву звіту за номером  ${report num}
  [Return]  ${report name}


Перевірити наявність відгуків
	${count}  vidhuky.Порахувати кількість відгуків
	Run Keyword if  ${count} < 6  Fail  оу, а було як мінінмум 6 відгуків


Перевірити наявність інструкцій
	${count}  instruktcii.Порахувати кількість інструкції
	Run Keyword if  ${count} < 2  Fail  Як це ми без інструкцій?!

