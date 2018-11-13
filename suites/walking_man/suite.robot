*** Settings ***
Resource  ../../src/src.robot
Test Teardown  Test Postcondition
Suite Setup  Відкрити головну сторінку SmartTender.biz під потрібною роллю
Suite Teardown  Suite Postcondition


*** Variables ***
${button pro-kompaniyu}              css=.with-drop>a[href='/pro-kompaniyu/']
${button kontakty}                   css=.menu a[href='/pro-kompaniyu/kontakty/']
${button taryfy}                     css=#MenuList a[href='/taryfy/']
${button podii}                      css=#LoginDiv [href='/podii/']
${button dogovir}                    css=#ContractButton
${button messages}                   xpath=//*[contains(@class,'fa-bell')]
${dropdown navigation}               css=#MenuList div.dropdown li>a
${pro-kompaniyu text}                xpath=//div[@itemscope='itemscope']//div[1]/*[@class='ivu-card-body']/div[2]/div[1]
${header text}                       css=div[itemscope=itemscope] h1
${novyny text}                       css=[class="row content"] h1
${news block}                        css=.ivu-row-undefined-space-between
${news search input}                 css=.ivu-card-body input
${news search button}                css=.ivu-card-body button
${kontakty text}                     css=div[itemscope=itemscope]>div.ivu-card:nth-child(1) span
${kontakty block}                    css=div[itemscope=itemscope]>div.ivu-card
${messages block}                    //*[contains(@class,'long-text')]/span
${nashi-klienty text}                xpath=(//*[@class="row text-center"]//b)[1]
${nashi-klienty text1}               xpath=(//*[@class="row text-center"]//b)[2]
${vakansii text}                     css=.container>div.row>div
${taryfy text}                       //*[@class="body-content"]//ul[@class="nav nav-pills nav-justified"]//li
${client banner}                     css=.container .row .ivu-card-body
${item plan}                         css=tr[data-planid] a
${item dogovory}                     xpath=//*[contains(@class, 'container')]//*[contains(@class, 'content-expanded')]/div[2]/*
${auction active items}              xpath=//tbody/tr[@class='head']|//*[@id='hotTrades']/div/div
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
${tender doc exept EDS}              xpath=//*[@data-qa="documents-block"]//*[contains(@class, "filename") and not(contains(., 'sign.p7s')) and not(contains(., '.rar'))]/div|//*[contains(@class, "filename") and not(contains(., 'sign.p7s')) and not(contains(., '.rar'))]/div
${tender doc exept EDS commercial}   //*[contains(@class, 'filename')]//span
${personal account}                  xpath=//*[@id='MenuList']//*[contains(@class, 'loginButton')]//a[@id='LoginAnchor' and not(@class)]
${num_of_tenders}                    xpath=(//*[@class="num"])[3]
${analytics_page}                    /ParticipationAnalytic/?segment=3&organizationId=226
${tender_type_procurement}           //*[@data-qa="procedure-type"]//div[2]//*|//*[@class="info_form"]
${elastic search input}              css=.ivu-card-bordered input
${elastic search button}             css=.ivu-card-bordered button
${elastic search clean filter}       css=.tag-holder button
${vidhuky}                           css=.ivu-row .ivu-card
${blog}                              css=.ivu-card-body>.ivu-row
${blog input}                        css=.ivu-card-body input
${blog search button}                css=.ivu-card-body button
${not collapsed menu button your account}         //*[contains(@class, "page-container") and not(contains(@class, "collapsed"))]//*[@class="sidebar-collapse"]
${collapsed menu button your account}             //*[contains(@class, "page-container") and contains(@class, "collapsed")]//*[@class="sidebar-collapse"]
${report}                            //*[@class="ivu-card-body"]//*[@class="favoriteStar"]
${prozorro-number}                   //*[@data-qa='prozorro-number']//a/span


*** Test Cases ***
Повідомлення
  [Tags]  notification
  Зайти на сторінку з контактами
  Зайти на сторінку повідомлень
  Перевірити заголовок сторінки повідомлень
  Порахувати кількість повідомлень
  Переглянути повідемлення
  Закрити вікно з повідомленням
  Logout
  Зайти на сторінку з контактами
  Перевірити відсутність дзвіночка(повідомлення)
  [Teardown]  Run Keywords
  ...  Log Location
  ...  AND   Run Keyword If Test Failed  Capture Page Screenshot


Перевірка гарантійного внеску для open_eu
  [Tags]  guarantee_amount  broken
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  Відкриті торги з публікацією англійською мовою
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${tender_type_procurement}  Відкриті торги з публікацією англійською мовою
  Перевірка гарантійного внеску


Сформувати рахунок-фактуру
  [Tags]  invoice  -test  broken
  Відкрити особистий кабінет
  Розкрити меню в особистому кабінеті
  Відкрити сторінку рахунка фактури
  ${amount}  Сгенерувати та ввести суму до оплати
  Натиснути сформувати рахунок
  Перевірити валідаційне повідомлення для сформованого рахунку
  Перевірити email рахунок-фактуру  ${amount}


Особистий кабінет
  [Tags]  your_account
  Run Keyword If  '${role}' == 'provider'  Відкрити особистий кабінет
  ...  ELSE IF  '${role}' == 'tender_owner'  Відкрити особистий кабінет webcliend
  ...  ELSE IF  "ssp_tender_owner" in "${role}"  Відкрити особистий кабінет для ssp_tender_owner


Аналітика участі
  [Tags]  your_account
  Відкрити сторінку аналітики
  Вибрати інший період аукціону  Минулий місяць
  Перевірити наявність діаграми та таблиці
  Перевірити роботу кругової діаграми
  Перевірити зміну періоду


Налаштування підписки
  [Tags]  your_account  -test  -prod  broken
  Відкрити особистий кабінет
  Розкрити меню в особистому кабінеті
  Відкрити сторінку налаштування підписки
  Перевірити блок запиту допомоги з налаштування підписки
  Перевірити блок Персональне запрошення організатора
  Перевірити блок E-mail адреси для дублювання всіх розсилок
  Перевірити вкладки підписки для закупівель
  Перевірити вкладки підписки на продаж

  Активувати тип торгів для підписки  на закупівлю


Заявки на отримання тендерного забезпечення
  [Tags]  your_account
  Відкрити особистий кабінет
  Розкрити меню в особистому кабінеті
  Відкрити сторінку Заявки на отримання тендерного забезпечення
  Перевірити сторінку Заявки на отримання тендерного забезпечення


Юридична допомога
  [Tags]  your_account  -ip
  Відкрити особистий кабінет
  Розкрити меню в особистому кабінеті
  Перевірити вкладку Отримати юридичну допомогу


Особисті дані користувача
  [Tags]  your_account
  Відкрити особистий кабінет
  Розкрити меню в особистому кабінеті
  Перевірити вкладку Профіль компанії


Змінити пароль
  [Tags]  your_account  -ip
  Відкрити особистий кабінет
  Розкрити меню в особистому кабінеті
  Перевірити вкладку Змінити пароль


Управління користувачами
  [Tags]  your_account
  Відкрити особистий кабінет
  Розкрити меню в особистому кабінеті
  Перевірити вкладку Управління користувачами


Звіти
  [Tags]  your_account
  Відкрити особистий кабінет
  Розкрити меню в особистому кабінеті
  Відкрити сторінку Звіти
  Натиснути на фільтр Тільки обрані звіти  вимкнути
  Перевірити наявність звітів
  Прибрати з обраних усі звіти
  ${name}  Додати в обрані випадковій звіт та вернути назву
  Перевірити фильтр Тільки обрані звіти  ${name}
  Прибрати з обраних усі звіти


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
  Зайти на сторінку з контактами
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
  ...  Зайти на сторінку комерційніх торгів
  ...  AND  Перевірити заголовок, комерційніх торгів
  ...  AND  Перевірити вкладку комерційніх закупівель
  ...  AND  Порахувати кількість торгів
  ...  AND  Розгорнути розширений пошук та випадаючий список видів торгів  Відкриті торги. Аукціон
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


Відкриті торги. Аукціон
  [Tags]  commercial
  Зайти на сторінку комерційніх торгів
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${info form1}
  Перевірити тендерний документ


Відкриті торги. Аналіз пропозицій
  [Tags]  commercial  -test
  Зайти на сторінку комерційніх торгів
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${info form1}
  Перевірити тендерний документ


Запит пропозицій
  [Tags]  commercial  -test
  Зайти на сторінку комерційніх торгів
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${info form1}
  Перевірити тендерний документ


Відкриті торги. Аналіз ринку
  [Tags]  commercial  -test
  Зайти на сторінку комерційніх торгів
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${info form1}
  Перевірити тендерний документ


Перевірити список доступних торгів для Комерційні торги Продажі
  [Tags]  commercial  -test
  [Setup]  Run Keywords
  ...  Зайти на сторінку комерційніх торгів
  ...  AND  Перевірити вкладку комерційних продаж
  ...  AND  Порахувати кількість торгів
  ...  AND  Розгорнути розширений пошук та випадаючий список видів торгів  Аукціон на продаж. Відкриті торги
  [Template]  Перевірити наявність тексту в випадаючому списку
  Тендер на продаж. Відкриті торги
  Аукціон на продаж. Відкриті торги
  Аукціон на продаж. Обмежений список
  Аукціон на продаж. За рейтингом
  Тендер на продаж. Обмежений список


Аукціон на продаж. Відкриті торги
  [Tags]  commercial  -test
  Зайти на сторінку комерційніх торгів
  Перевірити вкладку комерційних продаж
  Порахувати кількість торгів
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${info form1}
  Перевірити тендерний документ


Перевірка посилання на тендер (з порталу)
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Перевірити заголовок державних закупівель
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  ${id}  Отримати UAID на сторінці з тендером
  ${link}  Сформувати пряме посилання на тендер  ${id}
  Перевірити відкриття тендера за посиланням  ${link}


Перевірити список доступних торгів для Державні закупівлі прозорро Конкурентні процедури
  [Tags]  procurement
  [Setup]  Run Keywords
  ...  Зайти на сторінку державних закупівель
  ...  AND  Перевірити заголовок державних закупівель
  ...  AND  Перевірити закладку конкурентні процедури
  ...  AND  Порахувати кількість торгів
  ...  AND  Розгорнути розширений пошук та випадаючий список видів торгів  Допорогові закупівлі
  [Template]  Перевірити наявність тексту в випадаючому списку
  Допорогові закупівлі
  Відкриті торги
  Відкриті торги з публікацією англійською мовою
  Переговорна процедура для потреб оборони
  Відкриті торги для закупівлі енергосервісу
  Конкурентний діалог 2-ий етап
  Конкурентний діалог з публікацією англійською мовою 2-ий етап
  Звіт про укладений договір
  Переговорна процедура
  Переговорна процедура (скорочена)
  Конкурентний діалог 1-ий етап
  Конкурентний діалог з публікацією англійською мовою 1-ий етап


Допорогові закупівлі
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${tender_type_procurement}
  Перевірити тендерний документ


Відкриті торги
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${tender_type_procurement}
  Перевірити тендерний документ


Відкриті торги з публікацією англійською мовою
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${tender_type_procurement}
  Перевірити тендерний документ


Переговорна процедура для потреб оборони
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${tender_type_procurement}
  Перевірити тендерний документ


Відкриті торги для закупівлі енергосервісу
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${tender_type_procurement}
  Перевірити тендерний документ


Конкурентний діалог 2-ий етап
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${tender_type_procurement}
  Перевірити тендерний документ


Конкурентний діалог з публікацією англійською мовою 2-ий етап
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${tender_type_procurement}
  Перевірити тендерний документ


Конкурентний діалог 1-ий етап
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${tender_type_procurement}
  Перевірити тендерний документ


Конкурентний діалог з публікацією англійською мовою 1-ий етап
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${tender_type_procurement}
  Перевірити тендерний документ


Перевірити список доступних торгів для Державні закупівлі прозорро Неконкурентні процедури
  [Tags]  procurement
  [Setup]  Run Keywords
  ...  Зайти на сторінку державних закупівель
  ...  AND  Перевірити заголовок державних закупівель
  ...  AND  Перевірити закладку неконкурентні процедури
  ...  AND  Порахувати кількість торгів
  ...  AND  Розгорнути розширений пошук та випадаючий список видів торгів  Звіт про укладений договір
  [Template]  Перевірити наявність тексту в випадаючому списку
  Звіт про укладений договір
  Переговорна процедура
  Переговорна процедура (скорочена)


Звіт про укладений договір
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Перевірити закладку неконкурентні процедури
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${tender_type_procurement}
  Перевірити тендерний документ


Переговорна процедура
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Перевірити закладку неконкурентні процедури
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${tender_type_procurement}
  Перевірити тендерний документ


Переговорна процедура (скорочена)
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Перевірити закладку неконкурентні процедури
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${tender_type_procurement}
  Перевірити тендерний документ


Державні закупівлі прозорро Плани
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Перевірити закладку закупівлі плани
  Порахувати кількість плану
  Перейти по результату пошуку  ${item plan}
  Перевірити сторінку прозорро Плани


Державні закупівлі прозорро Договори
  [Tags]  procurement  non-critical-prod
  Зайти на сторінку державних закупівель
  Перевірити закладку закупівлі договори
  Порахувати кількість договорів
  ${id}  Отримати id першого договору
  Перейти по результату пошуку  ${item dogovory}//h4/a
  Перевірити заголовок договору для закупок  ${id}


Перевірити список доступних торгів для Аукціони на продаж активів банків
  [Tags]  sales
  [Setup]  Run Keywords
  ...  Зайти на сторінку аукціони на продаж активів банків
  ...  AND  Перевірити заголовок аукціони на продаж активів банків
  ...  AND  Перевірити вкладку аукціони на продаж активів банків
  ...  AND  Порахувати кількість аукціонів на продаж
  ...  AND  Розгорнути розширений пошук та випадаючий список видів торгів  Продаж права вимоги за кредитними договорами
  [Template]  Перевірити наявність тексту в випадаючому списку
  Продаж права вимоги за кредитними договорами
  Продаж майна банків, що ліквідуються
  Голландський аукціон


Продаж права вимоги за кредитними договорами
  [Tags]  sales
  Зайти на сторінку аукціони на продаж активів банків
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури за зразком  ${info form for sales}  ${TESTNAME}
  Перевірити тендерний документ для commercial


Продаж майна банків, що ліквідуються
  [Tags]  sales
  Зайти на сторінку аукціони на продаж активів банків
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури за зразком  ${info form for sales}  ${TESTNAME}
  Перевірити тендерний документ для commercial


Голландський аукціон
  [Tags]  sales
  Зайти на сторінку аукціони на продаж активів банків
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури за зразком  ${info form for sales}  ${TESTNAME}
  Перевірити тендерний документ для commercial


Майно
  [Tags]  sales
  Зайти на сторінку аукціони на продаж активів банків
  Перевірити вкладку активи
  Порахувати кількість прав
  Вибрати тип активу та виконати пошук  ${TESTNAME}
  Перейти по результату пошуку  ${auction active item}
  Перевірити тип процедури  ${info form4}
  Перевірити тендерний документ для commercial


Права вимоги
  [Tags]  sales
  Зайти на сторінку аукціони на продаж активів банків
  Перевірити вкладку активи
  Вибрати тип активу та виконати пошук  ${TESTNAME}
  Перейти по результату пошуку  ${auction active item}
  Перевірити тип процедури  ${info form4}
  Перевірити тендерний документ для commercial


Оренда майна
  [Tags]  sales
  Зайти на сторінку аукціони на продаж активів держпідприємств
  Перевірити заголовок аукціони на продаж активів держпідприємств
  Порахувати кількусть торгів Аукціони на продаж активів держпідприємств
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури за зразком  ${info form for sales}  ${TESTNAME}
  Перевірити тендерний документ для commercial


Продаж майна
  [Tags]  sales
  Зайти на сторінку аукціони на продаж активів держпідприємств
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури за зразком  ${info form for sales}  ${TESTNAME}
  Перевірити тендерний документ для commercial


Аукціон. Мала приватизація
  [Tags]  sales
  ${TESTNAME}  Run Keyword If  "${site}" == "test"  Set Variable  ${TESTNAME}
  ...  ELSE  Set Variable  Англійський аукціон. Мала приватизація
  Зайти на сторінку аукціони на продаж активів держпідприємств
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  ${TESTNAME}  Run Keyword If  "${site}" == "test"  Set Variable  Аукціон
  ...  ELSE  Set Variable  ${TESTNAME}
  Перевірити тип процедури за зразком  ${info form for sales}  ${TESTNAME}
  Перевірити тендерний документ для commercial


Аукціон за методом покрокового зниження стартової ціни та подальшого подання цінових пропозицій
  [Tags]  sales
  ${TESTNAME}  Run Keyword If  "${site}" == "test"  Set Variable  ${TESTNAME}
  ...  ELSE  Set Variable  Голландський аукціон. Мала приватизація
  Зайти на сторінку аукціони на продаж активів держпідприємств
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури за зразком  ${info form for sales}  ${TESTNAME}
  Перевірити тендерний документ для commercial


Об'єкти приватизації
  [Tags]  sales
  Зайти на сторінку аукціони на продаж активів держпідприємств
  Перевірити вкладку мала приватизація
  Вибрати тип процедури для малої приватизації
  Порахувати кількість торгів малої приватизації
  Перевірити пошук малої приватизації
  Перевірити тендерний документ для commercial


Інформаційні повідомлення
  [Tags]  sales
  Зайти на сторінку аукціони на продаж активів держпідприємств
  Перевірити вкладку мала приватизація
  Вибрати тип процедури для малої приватизації
  Порахувати кількість торгів малої приватизації
  Перевірити пошук малої приватизації
  Перевірити тендерний документ для commercial


Аукціони
  [Tags]  sales
  Зайти на сторінку аукціони на продаж активів держпідприємств
  Перевірити вкладку мала приватизація
  Вибрати тип процедури для малої приватизації
  Порахувати кількість торгів малої приватизації
  Перевірити пошук малої приватизації
  Перевірити тендерний документ для commercial


Запит цінових пропозицій
  [Tags]  rialto
  Зайти на сторінку RIALTO
  Перевірити заголовок RIALTO
  Порахувати кількість торгів RIALTO
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${tender_type_procurement}


Простий тендер
  [Tags]  rialto
  Зайти на сторінку RIALTO
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${tender_type_procurement}


Двохетапний тендер
  [Tags]  rialto
  Зайти на сторінку RIALTO
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  (${first found element})[last()]
  Перевірити тип процедури  ${tender_type_procurement}



*** Keywords ***

#######################################################
#######                                      ##########
#######               Keywords               ##########
#######                                      ##########
#######################################################
Відкрити головну сторінку SmartTender.biz під потрібною роллю
  Start  ${user}
  Run Keyword If  "tender_owner" in "${role}"  Go To  ${start_page}


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


Зайти на сторінку з контактами
  Click Element  ${button kontakty}
  Location Should Contain  /pro-kompaniyu/kontakty/


Перевірити відсутність кнопки повідомлень
  Зайти на сторінку з контактами
  Element Should Not Be Visible  ${button messages}


Зайти на сторінку повідомлень
  Click Element  ${button messages}
  Location Should Contain  /povidomlenya/


Перевірити заголовок сторінки повідомлень
  ${should header}  Set Variable  Повідомлення
  ${is header}  Get Text  xpath=//*[@type='flex']//h1
  Should Be Equal  ${is header}  ${should header}

Порахувати кількість повідомлень
  ${count}  Get Element Count  ${messages block}
  Run Keyword if  '${count}' == '0'  Fail  Де повідомлення?

Переглянути повідемлення
  ${title}  Get Text  (${messages block})[1]
  Click Element  (${messages block})[1]
  Sleep  5
  ${message title}  Get Text  //table//div[contains(text(),'ТЕСТУВАННЯ')]
  Should Be Equal  ${title}  ${message title}


Закрити вікно з повідомленням
	${selector}  Set Variable  //*[@class="ivu-modal-close"]
	Wait Until Page Contains Element  ${selector}
	Click Element  ${selector}
	Wait Until Element Is Not Visible  ${selector}


Перевірити відсутність дзвіночка(повідомлення)
	Run Keyword And Expect Error  Element with locator '${button messages}' not found.  Зайти на сторінку повідомлень


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


Перевірити заголовок, комерційніх торгів
  ${should}  Set variable  Комерційні торги (тендери SmartTender)
  ${is}  Get Text  ${torgy top/bottom tab}(1) ${torgy count tab}(1) p
  Should Be Equal  ${is}  ${should}


Перевірити вкладку комерційніх закупівель
  ${should}  Set variable  Закупівлі
  ${is}  Get Text  ${torgy top/bottom tab}(2) ${torgy count tab}(1)
  Should Be Equal  ${is}  ${should}


Порахувати кількість торгів
  ${count}  Get Element Count  ${first element find tender}
  Run Keyword if  '${count}' == '0'  Fail  Як це нема торгів?!


Перевірити вкладку комерційних продаж
  Click Element  ${torgy top/bottom tab}(2) ${torgy count tab}(2)
  ${should}  Set variable  Продажі
  ${is}  Get Text  ${torgy top/bottom tab}(2) ${torgy count tab}(2)
  Should Be Equal  ${is}  ${should}


Зайти на сторінку державних закупівель
  Click Element  ${komertsiyni-torgy icon}
  Click Element  ${torgy top/bottom tab}(1) ${torgy count tab}(2)


Перевірити заголовок державних закупівель
  ${should}  Set variable  Публічні (державні) закупівлі PROZORRO
  ${is}  Get Text  ${torgy top/bottom tab}(1) ${torgy count tab}(2)
  Should Be Equal  ${is}  ${should}


Перевірити закладку конкурентні процедури
  ${should}  Set variable  Конкурентні процедури
  ${is}  Get Text  ${torgy top/bottom tab}(2) ${torgy count tab}(1)
  Should Be Equal  ${is}  ${should}


Перевірити закладку неконкурентні процедури
  Click Element  ${torgy top/bottom tab}(2) ${torgy count tab}(2)
  ${should}  Set variable  Неконкурентні процедури
  ${is}  Get Text  ${torgy top/bottom tab}(2) ${torgy count tab}(2)
  Should Be Equal  ${is}  ${should}


Перевірити закладку закупівлі плани
  Click Element  ${torgy top/bottom tab}(2) ${torgy count tab}(3)
  ${should}  Set variable  Плани закупок ProZorro
  ${is}  Get Text  ${novyny text}
  Should Be Equal  ${is}  ${should}


Порахувати кількість плану
  Select Frame  css=iframe
  ${count}  Get Element Count  ${item plan}
  Run Keyword if  '${count}' == '0'  Fail  Як це ми без плану?!


Перевірити закладку закупівлі договори
  Click Element  ${torgy top/bottom tab}(2) ${torgy count tab}(4)
  ${should}  Set variable  Комерційні торги та публічні закупівлі в системі ProZorro - Договори
  ${is}  Get Text  ${novyny text}
  Should Be Equal  ${is}  ${should}


Порахувати кількість договорів
  ${count}  Get Element Count  ${item dogovory}
  Run Keyword if  '${count}' == '0'  Fail  Як це нема торгів?!


Отримати id першого договору
  Wait Until Page Contains Element  ${item dogovory}//h4  10
  ${id}  get text  ${item dogovory}//h4
  [Return]  ${id}


Перевірити заголовок договору для закупок
  [Arguments]  ${id}
  ${get}  Get Text  //h1
  Should Contain  ${get}  Договір
  Should Contain  ${get}  ${id}


Зайти на сторінку аукціони на продаж активів банків
  Click Element  ${komertsiyni-torgy icon}
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
  Click Element  ${komertsiyni-torgy icon}
  Click Element  ${torgy top/bottom tab}(1) ${torgy count tab}(4)


Перевірити заголовок аукціони на продаж активів держпідприємств
  ${should}  Set variable  Аукціони на продаж активів держпідприємств
  ${is}  Get Text  ${torgy top/bottom tab}(1) ${torgy count tab}(4)
  Should Be Equal  ${is}  ${should}


Порахувати кількусть торгів Аукціони на продаж активів держпідприємств
  ${count}  Get Element Count  ${auction active items}
  Run Keyword if  '${count}' == '0'  Fail  Як це нема торгів?!


Зайти на сторінку RIALTO
  Click Element  ${komertsiyni-torgy icon}
  Click Element  ${torgy top/bottom tab}(1) ${torgy count tab}(5)


Перевірити заголовок RIALTO
  ${should}  Set variable  Торги RIALTO
  ${is}  Get Text  ${torgy top/bottom tab}(1) ${torgy count tab}(5)
  Should Be Equal  ${is}  ${should}


Порахувати кількість торгів RIALTO
  ${count}  Get Element Count  ${auction active items}
  Run Keyword if  '${count}' == '0'  Fail  Як це нема торгів?!


Відкрити вікно договору
  Click Element  ${button dogovir}
  Sleep  3


Перевірити заголовок договору
  ${should header}  Set Variable  Договір
  ${is header}  Get Text  css=#ui-id-2
  Should Be Equal  ${is header}  ${should header}


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


Відфільтрувати по статусу торгів
  [Arguments]  ${status}
  Click Element  ${dropdown menu for bid statuses}
  Click Element  xpath=//li[text()='${status}']


Перевірити тип процедури
  [Arguments]  ${selector}  ${type}=${TESTNAME}
  Wait Until Keyword Succeeds  20  1  Wait Until Page Contains Element  ${selector}
  Sleep  .5
  ${is}  Get Text  ${selector}
  Should Contain  ${is}  ${type}


Перевірити тип процедури за зразком
  [Arguments]  ${selector}  ${should}
  Дочекатись закінчення загрузки сторінки(skeleton)
  Wait Until Page Contains Element  ${selector}
  Sleep  .5
  ${is}  Get Text  ${selector}
  Should Contain  ${is}  ${should}


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


Перевірити тендерний документ
  Run Keyword If  '${site}' == 'prod'  Run Keyword
  ...  Run Keyword If  '${IP}' == ''  Перевірити тендерний документ не для IP


Перевірити тендерний документ не для IP
  ${commercial}  Run Keyword And Return Status  Location Should Contain  /komertsiyni-torgy
  Run Keyword If  "${commercial}" == "True"  Перевірити тендерний документ для commercial
  ...  ELSE  Перевірити тендерний документ для procurement


Перевірити тендерний документ для commercial
  ${status}  Перевірити наявність документа для commercial
  Run Keyword If  '${status}' == '${True}'  Run Keywords
  ...  Mouse over  ${tender doc exept EDS commercial}
  ...  AND  Wait Until Page Contains Element  //*[contains(@class, 'filename')]//a[@href][1]
  ...  AND  Open Button  //*[contains(@class, 'filename')]//a[@href][1]  not_ip
  ...  AND  Check document for error


Перевірити тендерний документ для procurement
  ${status}  Перевірити наявність документа
  Run Keyword If  '${status}' == '${True}'  Run Keywords
  ...  Mouse over  ${tender doc exept EDS}
  ...  AND  Wait Until Page Contains Element  (//*[@class="ivu-poptip-content"]//a[@href and contains(text(), "Переглянути")])[1]  5
  ...  AND  Open Button  (//*[@class="ivu-poptip-content"]//a[@href and contains(text(), "Переглянути")])[1]  not_ip
  ...  AND  Check document for error


Check document for error
  Run Keyword And Expect Error  *  Location Should Contain  error
  Run Keyword And Expect Error  *  Page Should Contain  an error
  Go Back


Перевірити наявність документа
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${tender doc exept EDS}
  [Return]  ${status}


Перевірити наявність документа для commercial
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${tender doc exept EDS commercial}
  [Return]  ${status}


Відкрити особистий кабінет
  Page Should Contain Element  ${personal account}
  Click Element  ${personal account}
  Location Should Contain  /webparts/
  Page Should Contain Element  css=.sidebar-menu
  Page Should Contain Element  css=.main-content


Відкрити особистий кабінет webcliend
  Page Should Contain Element  ${personal account}
  Click Element  ${personal account}
  Location Should Contain  /webclient/


Відкрити особистий кабінет для ssp_tender_owner
  Page Should Contain Element  ${personal account}
  Click Element  ${personal account}
  Location Should Contain  /cabinet/registry/privatization-objects
  Page Should Contain Element  css=.action-block [type="button"]
  Page Should Contain Element  css=.content-block .asset-card


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


Відкрити сторінку аналітики
  Go to  ${start_page}${analytics_page}
  Дочекатись закінчення загрузки сторінки
  ${value}=  Get text  xpath=//*[@class="text-center"]/h3
  Should Contain  'Публічні закупівлі'  ${value}


Вибрати інший період аукціону
  [Arguments]  ${period}
  Click Element  xpath=//*[contains(@class, 'calendar')]
  Click Element  xpath=//div[contains(text(), '${period}')]
  Дочекатись закінчення загрузки сторінки


Перевірити наявність діаграми та таблиці
  ${diag}  Set Variable  xpath=(//*[@class="echarts"]//canvas)[1]
  ${table}  Set Variable  xpath=//*[@class="ivu-table-header"]//tr
  Element Should Be Visible  ${diag}
  Element Should Be Visible  ${table}


Перевірити роботу кругової діаграми
  ${tenders_before}  Get Text  ${num_of_tenders}
  ${tenders_before}  Evaluate  int(${tenders_before})
  Element Should Be Visible  xpath=(//*[@class="echarts"]//canvas)[2]
  Click Element At Coordinates  xpath=(//*[@class="echarts"]//canvas)[2]  80  0
  Дочекатись закінчення загрузки сторінки
  Wait Until Keyword Succeeds  1m  5s  Element Should Be Visible  xpath=//*[contains(@class, 'tag-checked')]
  ${tenders_after}  Get Text  ${num_of_tenders}
  ${tenders_after}  Evaluate  int(${tenders_after})
  Run Keyword if  ${tenders_before} < ${tenders_after}  Fail  Не працює кругова діаграма


Перевірити зміну періоду
  ${tenders_before}  Get Text  ${num_of_tenders}
  ${tenders_before}  Evaluate  int(${tenders_before})
  Вибрати інший період аукціону  Поточний рік
  ${tenders_after}  Get Text  ${num_of_tenders}
  ${tenders_after}  get_number  ${tenders_after}
  ${tenders_after}  Evaluate  int(${tenders_after})
  Run Keyword if  ${tenders_before} > ${tenders_after}  Fail  Не працює фільтрація по періоду


Перевірити вкладку мала приватизація
  Sleep  1
  Click Element  ${torgy top/bottom tab}(2) ${torgy count tab}(2)
  Дочекатись закінчення загрузки сторінки(skeleton)
  Location Should Contain  /small-privatization/


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


Перевірка гарантійного внеску
  ${data}  Отримати дані тендеру з cdb по id
  Set Global Variable  ${data}
  ${multiple_status}  Run Keyword And Return Status  Get From Dictionary  ${data['data']['lots'][1]}  title
  ${multiple_status_guarantee}  Run Keyword And Return Status  Get From Dictionary  ${data['data']['lots'][1]}  guarantee
  Run Keyword If  "${multiple_status_guarantee}" == "True"  Перевірка гарантійного внеску для мультилоту
  ...  ELSE IF  "${multiple_status}" == "False"  Перевірка гарантійного внеску для не мультилоту


Перевірка гарантійного внеску для мультилоту
  ${status}  Перевірити необхідність наявності кнопки гарантійного внеску для мультилоту
  ${location}  Get Location
  Run Keyword If  "${status}" == "True"  Run Keywords
  ...  Open Button  ${first lot}
  ...  AND  Select Frame  css=iframe
  ...  AND  Відкрити сторінку гарантійного внеску
  ...  AND  Go To  ${location}


Перевірити необхідність наявності кнопки гарантійного внеску для мультилоту
  ${status}  Run Keyword And Return Status  Get From Dictionary  ${data['data']['lots'][0]}  guarantee
  ${value}  Run Keyword If  "${status}" == "True"  Get From Dictionary  ${data['data']['lots'][0]['guarantee']}  amount
  ${ret}  Run Keyword If  "${status}" == "True" and "${value}" != "0.0"  Set Variable  True  ELSE  Set Variable  False
  [Return]  ${ret}


Перевірка гарантійного внеску для не мультилоту
  ${status}  Перевірити необхідність наявності кнопки гарантійного внеску
  Run Keyword If  "${status}" == "True"  Run Keywords
  ...  Відкрити сторінку гарантійного внеску
  ...  AND  Go Back


Перевірити необхідність наявності кнопки гарантійного внеску
  ${status}  Run Keyword And Return Status  Get From Dictionary  ${data['data']}  guarantee
  ${value}  Run Keyword If  "${status}" == "True"  Get From Dictionary  ${data['data']['guarantee']}  amount
  ${ret}  Run Keyword If  "${status}" == "True" and "${value}" != "0.0"  Set Variable  True  ELSE  Set Variable  False
  [Return]  ${ret}


Отримати дані тендеру з cdb по id
  ${id}  Get Text  //*[@data-qa="prozorro-id"]//div[2]//span|//*[@class="info_idcbd"]
  Run Keyword If  "${site}" == "test"
  ...  Create Session  api  https://lb.api-sandbox.openprocurement.org/api/2.4/tenders/${id}
  Run Keyword If  "${site}" == "prod"
  ...  Create Session  api  https://public-api-sandbox.prozorro.gov.ua/api/0/tenders/${id}
  ${data}  Get Request  api  \
  ${data}  Set Variable  ${data.json()}
  [Return]  ${data}


Відкрити сторінку гарантійного внеску
  Open Button  //*[@id="guarantee"]//a
  Run Keyword If  "${role}" != "viewer"  Run Keywords
  ...       Element Should Be Visible  //h4[contains(text(), "Оформлення заявки на тендерне забезпечення")]
  ...  AND  Location Should Contain  /GuaranteePage/
  ...  ELSE  Run Keywords
  ...       Location Should Contain  .biz/Errors/
  ...  AND  Element Should Contain  //h1/following-sibling::h2  Для просмотра страницы необходимо войти на сайт!


Перевірити сторінку прозорро Плани
  Location Should Contain  /publichni-zakupivli-prozorro-plany/
  Select Frame  css=iFrame
  Page Should Contain Element  css=#main-section .title-plan


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
  Click Element  ${elastic search clean filter}
  Дочекатись закінчення загрузки сторінки(skeleton)
  Wait Until Element Is Not Visible  ${elastic search clean filter}


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


Розкрити меню в особистому кабінеті
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${not collapsed menu button your account}
  Run Keyword If  "${status}" != "True"  Click Element  ${collapsed menu button your account}


Відкрити сторінку рахунка фактури
  Click Element  //*[contains(text(), "Сформувати рахунок-фактуру")]/ancestor::a
  Location Should Contain  /invoicepage/


Сгенерувати та ввести суму до оплати
  Wait Until Page Contains Element  //*[@class="ivu-card-body"]//input  60
  ${n}  random_number  1  1000
  ${amount}  Evaluate  ${n}*17
  Input Text  //*[@class="ivu-card-body"]//input  ${amount}
  ${get}  Get Element Attribute  //*[@class="ivu-card-body"]//input  value
  Run Keyword If  "${get}" == ""  Сгенерувати та ввести суму до оплати
  [Return]  ${amount}


Натиснути сформувати рахунок
  ${selector}  Set Variable  //*[@class="ivu-card-body"]//button
  Click Element  ${selector}
  Дочекатись закінчення загрузки сторінки
  Wait Until Page Does Not Contain  ${selector}


Перевірити валідаційне повідомлення для сформованого рахунку
  Element Should Contain  css=.ivu-alert-desc  Рахунок сформований і відправлений на електронну адресу Вашої компанії
  Page Should Contain Element  //*[@class="ivu-alert-desc"]//a[contains(@href, 'it')]


Перевірити email рахунок-фактуру
  [Arguments]  ${amount}
  email precondition  ${user}
  Відкрити перший лист Рахунок за Надання послуг
  Звірити дані в pdf файлі  ${amount}
  Close Browser
  Switch Browser  1


Відкрити перший лист Рахунок за Надання послуг
  Wait Until Keyword Succeeds  60  2
  ...  Click Element  //td[@id]//span[contains(text(), "SmartTender - Рахунок за Надання послуг")]


Звірити дані в pdf файлі
  [Arguments]  ${amount}
  Mouse Over  //a[contains(., 'Рахунок')]
  Click Element  //a[contains(., 'Рахунок')]
  ${text}  Evaluate  str(${amount})
  Wait Until Page Contains  ${text}  30


Відкрити сторінку налаштування підписки
  Click Element  //*[contains(text(), "Налаштування підписки")]/ancestor::a
  Location Should Contain  /Subscription/


Перевірити блок запиту допомоги з налаштування підписки
  Click Element  css=.btn-shadow.ivu-btn-success
  ${header}  Set Variable  //*[@class="ivu-modal-mask" and not(contains(@style, "display: none"))]/following-sibling::*//*[@class="ivu-modal-header-inner"]
  Wait Until Page Contains Element  ${header}
  Sleep  2
  Element Should Contain  ${header}  Запит налаштування підписки
  ${close button}  Set Variable  //*[@class="ivu-modal-mask" and not(contains(@style, "display: none"))]/following-sibling::*//*[contains(@class, "ivu-icon-ios-close-empty")]
  Click Element  ${close button}
  Wait Until Page Does Not Contain Element  ${close button}


Перевірити блок Персональне запрошення організатора
  Перевірити заголовок Персональне запрошення організатора
  Перевірити перемикач Персональне запрошення організатора


Перевірити заголовок Персональне запрошення організатора
  ${element}  Set Variable  (//h4)[2]
  Element Should Contain  ${element}  Персональне запрошення організатора


Перевірити перемикач Персональне запрошення організатора
  ${switcher}  Set Variable  //*[@class="ivu-card-body" and contains(., "Персональне запрошення організатора")]//*[@tabindex]
  ${status}  Get Element Attribute  ${switcher}/input  Value
  Click Element  ${switcher}
  ${new_status}  Get Element Attribute  ${switcher}/input  Value
  Should Not Be Equal  ${new_status}  ${status}


Перевірити блок E-mail адреси для дублювання всіх розсилок
  Перевірити заголовок E-mail адреси для дублювання всіх розсилок
  Перевірити поле вводу E-mail адреси для дублювання всіх розсилок
  Перевірити поле вводу E-mail адреси для дублювання всіх розсилок(negative)


Перевірити заголовок E-mail адреси для дублювання всіх розсилок
  ${element}  Set Variable  (//h4)[3]
  Element Should Contain  ${element}  E-mail адреси для дублювання всіх розсилок


Перевірити поле вводу E-mail адреси для дублювання всіх розсилок
  ${input field}  Set Variable  //*[@class="ivu-card-body" and contains(., "E-mail адреси для дублювання всіх розсилок")]
  ${mail}  create_e-mail
  Input Text  ${input field}//input  ${mail}
  Click Element  ${input field}//button
  Page Should Contain  ${mail}
  ${close button}  Set Variable  //*[contains(text(), "${mail}")]/following-sibling::*
  Click Element  ${close button}
  Wait Until Page Does Not Contain Element  ${close button}


Перевірити поле вводу E-mail адреси для дублювання всіх розсилок(negative)
  ${element}  Set Variable  //*[@class="ivu-card-body" and contains(., "E-mail адреси для дублювання всіх розсилок")]
  ${n}  random_number  4  20
  ${name}  Generate Random String  ${n}  [LOWER]
  Input Text  ${element}//input  ${name}
  Click Element  ${element}//button
  Wait Until Keyword Succeeds  20  2
  ...  Element Should Contain  css=.ivu-message-notice span  Неправильний формат електронної пошти


create_e-mail
  ${n}  random_number  4  12
  ${name}  Generate Random String  ${n}  [LOWER]
  [Return]  ${name}@gmail.com


Перевірити вкладки підписки для закупівель
  Перевірити наявність всіх елементів в блоці категорії
  Вибрати вкладку для підписки  Публічні закупівлі
  Перевірити наявність всіх елементів в блоці категорії
  Вибрати вкладку для підписки  RIALTO.Закупівлі
  Перевірити наявність всіх елементів в блоці категорії


Перевірити вкладки підписки на продаж
  Активувати тип торгів для підписки  на продаж
  Перевірити наявність всіх елементів в блоці категорії
  Вибрати вкладку для підписки  Аукціони на продаж активів банків
  Перевірити наявність всіх елементів в блоці категорії
  Вибрати вкладку для підписки  Аукціони на продаж активів держпідприємств
  Перевірити наявність всіх елементів в блоці категорії


Активувати тип торгів для підписки
  [Arguments]  ${type}
  ${n}  Run Keyword If  "${type}" == "на продаж"  Set Variable  2
  ...  ELSE IF  "${type}" == "на закупівлю"  Set Variable  1
  ${element}  Set Variable  //*[contains(@class, "ivu-row-flex-space-between")]//label[${n}]
  Click Element  ${element}
  ${status}  Run Keyword And Return Status
  ...  Page Should Contain Element  ${element}[contains(@class, "checked")]
  Run Keyword If  "${status}" != "True"  Активувати тип торгів для підписки  ${type}


Перевірити наявність перемикача для активування сповіщень
  ${element}  Set Variable  //*[@class="ivu-row" and contains(., "Періодичність оповіщення про публікацію")]//span[contains(@class, "ivu-switch")]
  Page Should Contain Element  ${element}


Перевірити наявність блоку підписки
  [Arguments]  ${text}
  Page Should Contain Element  (//*[@class="ivu-card-body" and contains(., "${text}")])[last()]


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


Вибрати вкладку для підписки
  [Arguments]  ${text}
  ${selector}  Set Variable  //*[contains(@class, "ivu-tabs-nav")]//div[contains(@class, "ivu-tabs-tab")]
  ${n}  Run Keyword If  "${text}" == "Публічні закупівлі" or "${text}" == "Аукціони на продаж активів банків"
  ...  Set Variable  2
  ...  ELSE IF  "${text}" == "RIALTO.Закупівлі" or "${text}" == "Аукціони на продаж активів держпідприємств"
  ...  Set Variable  3
  Click Element  ${selector}[${n}]
  ${status}  Run Keyword And Return Status
  ...  Page Should Contain Element  ${selector}[${n}][contains(@class, "active")]
  Run Keyword If  "${status}" != "True"  Вибрати вкладку для підписки  ${text}


Перевірити наявність всіх елементів в блоці категорії
  Перевірити наявність перемикача для активування сповіщень
  Перевірити наявність блоку підписки  Категорії
  Перевірити наявність блоку підписки  Ключові слова
  Перевірити наявність блоку підписки  Мінус-слова
  Перевірити наявність блоку підписки  Додаткові реквізити
  Перевірити наявність блоку підписки  Реквізити організатора


Розгорнути перший лот
  Run Keyword If  '${multiple status}' == 'multiple'  Click Element  ${block}[2]//button


Додати файл до openeu
  Run Keyword If  '${multiple status}' == 'multiple'  Створити та додати PDF файл  2
  ...  ELSE  Створити та додати PDF файл  1


Відкрити сторінку Заявки на отримання тендерного забезпечення
  Click Element  //*[contains(text(), "Платні сервіси")]/ancestor::a
  Sleep  1
  Click Element  //*[contains(text(), "Тендерне забезпечення")]/ancestor::a
  Sleep  1


Перевірити сторінку Заявки на отримання тендерного забезпечення
  Wait Until Page Contains Element  //h1  30
  Element Should Contain  //h1  Заявки на отримання тендерного забезпечення
  Page Should Contain Element  //img[@src="/Images/Guarantee/guarantee-button.png"]


Перевірити вкладку Отримати юридичну допомогу
  Click Element  //*[contains(text(), "Платні сервіси")]/ancestor::a
  Sleep  1
  Click Element  //*[contains(text(), "Юридична допомога")]/ancestor::a
  Sleep  1
  Select frame  css=div.main-content iFrame
  Wait Until Page Contains Element  //*[@class="ivu-card-head"]//h4  30
  Element Should Contain  //*[@class="ivu-card-head"]//h4  Отримати юридичну допомогу
  Page Should Contain Element  css=.ivu-card-body>button[type="button"]


Перевірити вкладку Профіль компанії
  Click Element  //*[contains(text(), "Особисті дані")]/ancestor::a
  Sleep  1
  Click Element  //*[contains(text(), "Профіль компанії")]/ancestor::a
  Sleep  1
  Select frame  css=div.main-content iFrame
  Wait Until Page Contains Element  css=#FormLayout_1_0  30
  Element Should Contain  css=#FormLayout_1_0  Основна інформація
  Element Should Contain  css=#FormLayout_1_1  Додаткова інформація
  Page Should Contain Element  css=#BTSUBMIT_CD


Перевірити вкладку Змінити пароль
  Click Element  //*[contains(text(), "Особисті дані")]/ancestor::a
  Sleep  1
  Click Element  //*[contains(text(), "Змінити пароль")]/ancestor::a
  Sleep  1
  Location Should Contain  /ChangePassword/
  Wait Until Page Contains Element  //h2  30
  Element Should Contain  //h2  Зміна пароля
  Element Should Contain  (//*[@class="ivu-form-item-label"])[1]  Поточний пароль
  Element Should Contain  (//*[@class="ivu-form-item-label"])[2]  Новий пароль
  Page Should Contain Element  //button[@type="button" and contains(., "Змінити пароль")]


Перевірити вкладку Управління користувачами
  Click Element  //*[contains(text(), "Особисті дані")]/ancestor::a
  Sleep  1
  Click Element  //*[contains(text(), "Управління користувачами")]/ancestor::a
  Sleep  1
  Location Should Contain  /UserManagement/
  Wait Until Page Contains Element  //h1  30
  Element Should Contain  //h1  Структура підприємства
  Element Should Contain  //h5  Управління користувачами
  ${tr for user}  Set Variable  css=.ivu-table-body .ivu-table-row
  Page Should Contain Element  ${tr for user}


Відкрити сторінку Звіти
  Click Element  //*[contains(text(), "Звіти")]/ancestor::a
  Sleep  1
  Location Should Contain  /Reports
  Wait Until Page Contains Element  //h1  30
  Element Should Contain  //h1  Звіти


Перевірити наявність звітів
  Page Should Contain Element  css=.ivu-card-body .favoriteStar


Додати в обрані випадковій звіт та вернути назву
  ${count}  Get Element Count  ${report}
  ${n}  random_number  1  ${count}
  Click Element  (${report})[${n}]
  ${name}  Get Text  (${report})[${n}]/following-sibling::*//*[@title]
  Sleep  3
  [Return]  ${name}


Перевірити фильтр Тільки обрані звіти
  [Arguments]  ${name}
  Натиснути на фільтр Тільки обрані звіти  увімкнути
  ${count}  Get Element Count  ${report}
  Should Be Equal  "${count}"  "1"
  ${report name}  Get Text  ${report}/following-sibling::*//*[@title]
  Should Be Equal  ${report name}  ${name}
  Натиснути на фільтр Тільки обрані звіти  вимкнути
  ${count}  Get Element Count  ${report}
  Run Keyword if  ${count} < 2  Fail  Маловато будет(Отчетов)


Натиснути на фільтр Тільки обрані звіти
  [Arguments]  ${action}
  ${switcher}  Set Variable  css=.ivu-switch
  ${status}  Get Element Attribute  ${switcher} [value]  value
  Run Keyword If  "${status}" == "false" and "${action}" == "увімкнути"
  ...  Click Element  ${switcher}
  Run Keyword If  "${status}" == "true" and "${action}" == "вимкнути"
  ...  Click Element  ${switcher}
  Sleep  3


Прибрати з обраних усі звіти
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${report}//*[@class="fa fa-star"]
  Run Keyword If  ${status} == ${True}  Click Element  ${report}//*[@class="fa fa-star"]
  Sleep  5
  Run Keyword If  ${status} == ${True}  Прибрати з обраних усі звіти

Отримати UAID на сторінці з тендером
  ${id}  Get Text  ${prozorro-number}
  [Return]  ${id}

Сформувати пряме посилання на тендер
  [Arguments]  ${id}
  ${link to tender}  Set Variable  ${start page}/publichni-zakupivli-prozorro/${id}
  [Return]  ${link to tender}

Перевірити відкриття тендера за посиланням
  [Arguments]  ${link to tender}
  Go To  ${link to tender}
  Дочекатись закінчення загрузки сторінки(skeleton)
  Отримати UAID на сторінці з тендером
