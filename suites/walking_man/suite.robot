*** Settings ***
Resource  ../../src/src.robot
Test Teardown  Test Postcondition
Suite Teardown  Suite Postcondition

*** Variables ***
${button pro-kompaniyu}              css=.with-drop>a[href='/pro-kompaniyu/']
${button kontakty}                   css=.menu a[href='/pro-kompaniyu/kontakty/']
${button taryfy}                     css=#MenuList a[href='/taryfy/']
${button podii}                      css=#LoginDiv [href='/podii/']
${button dogovir}                    css=#ContractButton
${dropdown navigation}               css=#MenuList div.dropdown li>a
${pro-kompaniyu text}                xpath=//div[@itemscope='itemscope']//div[1]/*[@class='ivu-card-body']/div[2]/div[1]
${header text}                       css=div[itemscope=itemscope] h1
${novyny text}                       css=[class="row content"] h1
${news block}                        css=.ivu-card-body [type=flex]
${news search input}                 css=.ivu-card-body input
${news search button}                css=.ivu-card-body button
${kontakty text}                     css=div[itemscope=itemscope]>div.ivu-card:nth-child(1) span
${kontakty block}                    css=div[itemscope=itemscope]>div.ivu-card
${nashi-klienty text}                xpath=(//*[@class="row text-center"]//b)[1]
${nashi-klienty text1}               xpath=(//*[@class="row text-center"]//b)[2]
${vakansii text}                     css=.container>div.row>div
${taryfy text}                       css=.body-content ul[class="nav nav-pills nav-justified"] li
${torgy top/bottom tab}              css=#MainMenuTenders ul:nth-child   #up-1 bottom-2
${torgy count tab}                   li:nth-child
${client banner}                     css=.container .row .ivu-card-body
${item plan}                         css=tr[data-planid] a
${item dogovory}                     css=.plans-table td>a
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
${info form2}                        css=.info_form
${info form for sales}               xpath=//h5[@class='label-key' and contains(text(), 'Тип процедури')]/following-sibling::p
${info form4}                        xpath=//*[contains(text(), 'Тип активу')]/../following-sibling::div
${first found element}               css=#tenders tbody>.head a.linkSubjTrading
${last found element}                xpath=(//*[@id='tenders']//tbody/*[@class='head']//a[@class='linkSubjTrading'])[last()]
${last found multiple element}       xpath=(//*[@id='tenders']//*[@class='head']//span[@class='Multilots']/../..//a[@class='linkSubjTrading'])[last()]
${first lot}                         css=.table-row-value>a.hyperlink
${tender doc exept EDS}              xpath=//a[@class='fileLink'][not(contains(text(), 'sign.p7s'))]
${personal account}                  xpath=//*[@id='MenuList']//*[contains(@class, 'loginButton')]//a[@id='LoginAnchor' and not(@class)]
${count multiple lot checked}        0
${num_of_tenders}                    xpath=(//*[@class="num"])[3]
${analytics_page}                    https://smarttender.biz/ParticipationAnalytic/?segment=3&organizationId=226
*** Test Cases ***
Відкрити головну сторінку SmartTender.biz під роллю ${role}
  [Tags]  site
  ...  commercial
  ...  procurement
  ...  sales
  ...  rialto
  Run Keyword If  '${IP}' != ''  Change Start Page
  Start
  Run Keyword if  '${role}' != 'viewer'  Login  ${role}

Подати пропозицію учасником на тестові торги Допорогові закупівлі
  [Tags]  proposal  procurement
  Run Keyword If  "${role}" != "test_it.ua"  Pass execution  Only for provider, prod, test_tender
  Відкрити сторінку тестових торгів
  Відфільтрувати по формі торгів  Допорогові закупівлі
  Відфільтрувати по статусу торгів  Прийом пропозицій
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form2}  Допорогові закупівлі
  Перевірити кнопку подачі пропозиції
  Скасувати пропозицію за необхідністю
  Заповнити поле з ціною  1  1
  Подати пропозицію

#Подати пропозицію учасником на тестові торги Відкриті торги з публікацією англійською мовою
#  [Tags]  proposal  procurement
#  Run Keyword If  "${role}" != "test_it.ua"  Pass execution  Only for provider, prod, test_tender
#  Відкрити сторінку тестових торгів
#  Відфільтрувати по формі торгів  Відкриті торги з публікацією англійською мовою
#  Відфільтрувати по статусу торгів  Прийом пропозицій
#  Виконати пошук тендера
#  Перейти по результату пошуку  ${last found element}
#  Перевірити тип процедури  ${info form2}  Відкриті торги з публікацією англійською мовою
#  Перевірити кнопку подачі пропозиції
#  Скасувати пропозицію за необхідністю
#  debug
#  #Заповнити поле з ціною  1  1
#  Подати пропозицію
#  [Teardown]  Test Postcondition

Особистий кабінет
  [Tags]  site
  Run Keyword If  '${role}' == 'viewer' or '${role}' == 'tender_owner'
  ...  Run Keyword And Expect Error  *  Відкрити особистий кабінет
  ...  ELSE IF  '${role}' == 'Bened'  Відкрити особистий кабінет webcliend
  ...  ELSE  Відкрити особистий кабінет

Аналітика участі
  [Tags]  site
  ...  analytic
  Run Keyword If  '${role}' == 'test_it.ua'  Run Keywords
  ...  Відкрити сторінку аналітики
  ...  AND  Перевірити наявність діаграми та таблиці
  ...  AND  Перевірити роботу кругової діаграми
  ...  AND  Перевірити зміну періоду
  ...  ELSE  No Operation

Договір
  [Tags]  site
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

Комерційні торги Закупівлі
  [Tags]  commercial
  Зайти на сторінку комерційніх торгів
  Перевірити заголовок, комерційніх торгів
  Перевірити вкладку комерційніх закупівель
  Порахувати кількість торгів
  Розгорнути розширений пошук та випадаючий список видів торгів  Відкриті торги. Аукціон
  [Teardown]  Run Keyword If Test Failed  Capture Page Screenshot

Перевірити наявність всіх видів торгів в випадаючому списку
  [Tags]  commercial
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
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form1}
  Перевірити тендерний документ

Відкриті торги. Аналіз пропозицій
  [Tags]  commercial  skip_for_test
  Зайти на сторінку комерційніх торгів
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form1}
  Перевірити тендерний документ

Запит пропозицій
  [Tags]  commercial  skip_for_test
  Зайти на сторінку комерційніх торгів
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form1}
  Перевірити тендерний документ

Відкриті торги. Аналіз ринку
  [Tags]  commercial  skip_for_test
  Зайти на сторінку комерційніх торгів
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form1}
  Перевірити тендерний документ

Комерційні торги Продажі
  [Tags]  commercial  skip_for_test
  Зайти на сторінку комерційніх торгів
  Перевірити вкладку комерційних продаж
  Порахувати кількість торгів
  Розгорнути розширений пошук та випадаючий список видів торгів  Аукціон на продаж. Відкриті торги
  [Teardown]  Run Keyword If Test Failed  Capture Page Screenshot

Перевірити список доступних торгів для Комерційні торги Продажі
  [Tags]  commercial  skip_for_test
  [Template]  Перевірити наявність тексту в випадаючому списку
  Тендер на продаж. Відкриті торги
  Аукціон на продаж. Відкриті торги
  Аукціон на продаж. Обмежений список
  Аукціон на продаж. За рейтингом
  Тендер на продаж. Обмежений список

Аукціон на продаж. Відкриті торги
  [Tags]  commercial  skip_for_test
  Зайти на сторінку комерційніх торгів
  Перевірити вкладку комерційних продаж
  Порахувати кількість торгів
  Розгорнути розширений пошук та випадаючий список видів торгів

Державні закупівлі прозорро Конкурентні процедури
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Перевірити заголовок державних закупівель
  Перевірити закладку конкурентні процедури
  Порахувати кількість торгів
  Розгорнути розширений пошук та випадаючий список видів торгів  Допорогові закупівлі
  [Teardown]  Run Keyword If Test Failed  Capture Page Screenshot

Перевірити список доступних торгів для Державні закупівлі прозорро Конкурентні процедури
  [Tags]  procurement
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
  [Tags]  procurement  skip_for_test
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form2}
  Перевірити тендерний документ
  Перевірити сторінку окремого лота в мультилоті

Відкриті торги
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form2}
  Перевірити тендерний документ
  Перевірити сторінку окремого лота в мультилоті

Відкриті торги з публікацією англійською мовою
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form2}
  Перевірити тендерний документ
  Перевірити сторінку окремого лота в мультилоті

Переговорна процедура для потреб оборони
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form2}
  Перевірити тендерний документ
  Перевірити сторінку окремого лота в мультилоті

Відкриті торги для закупівлі енергосервісу
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form2}
  Перевірити тендерний документ
  Перевірити сторінку окремого лота в мультилоті

Конкурентний діалог 2-ий етап
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form2}
  Перевірити тендерний документ
  Перевірити сторінку окремого лота в мультилоті

Конкурентний діалог з публікацією англійською мовою 2-ий етап
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form2}
  Перевірити тендерний документ
  Перевірити сторінку окремого лота в мультилоті

Конкурентний діалог 1-ий етап
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form2}
  Перевірити тендерний документ
  Перевірити сторінку окремого лота в мультилоті

Конкурентний діалог з публікацією англійською мовою 1-ий етап
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form2}
  Перевірити тендерний документ
  Перевірити сторінку окремого лота в мультилоті

Державні закупівлі прозорро Неконкурентні процедури
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Перевірити заголовок державних закупівель
  Перевірити закладку неконкурентні процедури
  Порахувати кількість торгів
  Розгорнути розширений пошук та випадаючий список видів торгів  Звіт про укладений договір
  [Teardown]  Run Keyword If Test Failed  Capture Page Screenshot

Перевірити список доступних торгів для Державні закупівлі прозорро Неконкурентні процедури
  [Tags]  procurement
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

Звіт про укладений договір
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Перевірити закладку неконкурентні процедури
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form2}

Переговорна процедура
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Перевірити закладку неконкурентні процедури
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form2}

Переговорна процедура (скорочена)
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Перевірити закладку неконкурентні процедури
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form2}

Державні закупівлі прозорро Плани
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Перевірити закладку закупівлі плани
  Порахувати кількість плану
  Перейти по результату пошуку  ${item plan}

Державні закупівлі прозорро Договори
  [Tags]  procurement
  Зайти на сторінку державних закупівель
  Перевірити закладку закупівлі договори
  Порахувати кількість договорів
  Перейти по результату пошуку  ${item dogovory}

Аукціони на продаж активів банків
  [Tags]  sales
  Зайти на сторінку аукціони на продаж активів банків
  Перевірити заголовок аукціони на продаж активів банків
  Перевірити вкладку аукціони на продаж активів банків
  Порахувати кількість аукціонів на продаж
  Розгорнути розширений пошук та випадаючий список видів торгів  Продаж права вимоги за кредитними договорами
  [Teardown]  Run Keyword If Test Failed  Capture Page Screenshot

Перевірити список доступних торгів для Аукціони на продаж активів банків
  [Tags]  sales
  [Template]  Перевірити наявність тексту в випадаючому списку
  Продаж права вимоги за кредитними договорами
  Продаж майна банків, що ліквідуються
  Голландський аукціон

Продаж права вимоги за кредитними договорами
  [Tags]  sales
  Зайти на сторінку аукціони на продаж активів банків
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури за зразком  ${info form for sales}  ${TESTNAME}

Продаж майна банків, що ліквідуються
  [Tags]  sales  non-critical
  Зайти на сторінку аукціони на продаж активів банків
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури за зразком  ${info form for sales}  ${TESTNAME}

Голландський аукціон
  [Tags]  sales
  Зайти на сторінку аукціони на продаж активів банків
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури за зразком  ${info form for sales}  ${TESTNAME}

Аукціони на продаж активів банків Активи
  [Tags]  sales
  Зайти на сторінку аукціони на продаж активів банків
  Перевірити вкладку активи
  Порахувати кількість прав
  [Teardown]  Run Keyword If Test Failed  Capture Page Screenshot

Майно
  [Tags]  sales
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

Аукціони на продаж активів держпідприємств
  [Tags]  sales
  Зайти на сторінку аукціони на продаж активів держпідприємств
  Перевірити заголовок аукціони на продаж активів держпідприємств
  Порахувати кількусть торгів Аукціони на продаж активів держпідприємств
  [Teardown]  Run Keyword If Test Failed  Capture Page Screenshot

Оренда майна
  [Tags]  sales
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури за зразком  ${info form for sales}  ${TESTNAME}

Продаж майна
  [Tags]  sales
  Зайти на сторінку аукціони на продаж активів держпідприємств
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури за зразком  ${info form for sales}  ${TESTNAME}

Торги RIALTO
  [Tags]  rialto
  Зайти на сторінку RIALTO
  Перевірити заголовок RIALTO
  Порахувати кількість торгів RIALTO
  [Teardown]  Run Keyword If Test Failed  Capture Page Screenshot

Запит цінових пропозицій
  [Tags]  skip_for_test  rialto
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form2}

Простий тендер
  [Tags]  rialto
  Зайти на сторінку RIALTO
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form2}

Двохетапний тендер
  [Tags]  rialto
  Зайти на сторінку RIALTO
  Відфільтрувати по формі торгів  ${TESTNAME}
  Виконати пошук тендера
  Перейти по результату пошуку  ${last found element}
  Перевірити тип процедури  ${info form2}

Реєстрація
  [Tags]  site
  Run Keyword if  '${role}' != 'viewer'  Pass Execution  only for viewer
  Зайти на сторінку реєстрації
  Перевірити заголовок сторінки реєстрації
  Перевірити підзаголовок сторінки реєстрації

Інструкції
  [Tags]  site  non-critical
  Перейти на сторонку інструкції
  Перевірити заголовок сторінки інструкцій
  Порахувати кількість інструкцій

Інструкції2
  [Tags]  site
  ${location}  Get Location
  Go To  ${location}TenderInstruction/
  ${should}  Set variable  Інструкції
  ${is}  Get Text  css=h1
  Should Be Equal  ${is}  ${should}

Зворотній зв'язок
  [Tags]  site
  Зайти на сторінку зворотній зв'язок
  Перевірити заголовок сторінки зворотній зв'язок
  Перевірити наявність кнопки відправити на сторінці зворотній зв'язок

Карта сайту
  [Tags]  site
  Перейти на сторінку карти сайту
  Перевірити заголовок сторінки карта сайта
  Порахувати кількість єлементів сторінки карта сайту

Питання та відповіді
  [Tags]  site
  Перейти на сторінку запитань
  Перевірити заголовок сторінки запитань
  Порахувати кількість запитань

Курси валют
  [Tags]  skip_for_test  site
  Відкрити вікно курсів валют
  Перевірити шлях курсів валют
  Перевірити заголовок курсів валют
  Перевірити лінки курсів валют

Перевірка результатів тесту
  [Tags]  non-critical  procurement  check
  Log  ${count multiple lot checked}
  Run Keyword if  '${count multiple lot checked}' == '0'  Fail  Didn't check any lot in multiplelot tender
  [Teardown]  No Operation

*** Keywords ***

#######################################################
#######                                      ##########
#######               Keywords               ##########
#######                                      ##########
#######################################################
Test Postcondition
  Run Keyword If Test Failed  Capture Page Screenshot
  Go To  ${start_page}
  Run Keyword If  "${role}" != "viewer" and "${role}" != "Bened"  Перевірити користувача

Перевірити користувача
  ${status}  Run Keyword And Return Status  Wait Until Page Contains  ${name}  10
  Run Keyword If  "${status}" == "False"  Fatal Error  We have lost user

Suite Postcondition
  Close All Browsers

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

Перейти на сторонку інструкції
  Click Element  ${instruktsii link}
  Location Should Contain  /instruktсii/

Перевірити заголовок сторінки інструкцій
  ${should}  Set variable  Інструкції
  ${is}  Get Text  ${h1 header text}
  Should Be Equal  ${is}  ${should}

Порахувати кількість інструкцій
  ${count}  Get Element Count  css=.item
  Run Keyword if  '${count}' == '0'  Fail  Хто сховав Інструкції?!

Зайти на сторінку зворотній зв'язок
  Open button  ${feedback link}
  Location Should Contain  /zvorotniy-zvyazok/

Перевірити заголовок сторінки зворотній зв'язок
  ${should}  Set variable  Зворотній зв'язок
  ${is}  Get Text  ${h1 header text}
  Should Be Equal  ${is}  ${should}

Перевірити наявність кнопки відправити на сторінці зворотній зв'язок
  Page Should Contain Element  css=#MainContent_MainContent_MainContent_submitBtn

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

Перевірити заголовок сторінки запитань
  ${should}  Set variable  Питання та відповіді
  ${is}  Get Text  ${novyny text}
  Should Be Equal  ${is}  ${should}

Порахувати кількість запитань
  Select Frame  css=iframe
  ${count}  Get Element Count  css=#faqGroupTree>div>div.hover-div
  Run Keyword if  '${count}' > '5'  Fail  Хто сховав Питання та відповіді?!

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
  Select Frame  css=iframe
  ${count}  Get Element Count  ${item dogovory}
  Run Keyword if  '${count}' == '0'  Fail  Як це нема торгів?!

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
  Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${loading}
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
  ${should link1}  Set Variable  https://smarttender.biz/instruktsii/dogovir-oferta-so-2015-003-pro-nadannya-informatsiynyh-poslug-pid-chas-provedennya-protsedur-publichnyh-zakupivel-prozorro-ta-zakupivel-rialto/
  ${should link2}  Set Variable  https://smarttender.biz/instruktsii/dogovir-oferta-so-2016-001-pro-nadannya-poslug-z-organizatsii-ta-provedennya-vidkrytyh-elektronnyh-torgiv-auktsioniv-prozorro-prodazhi/
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
  Run Keyword If  "${selector}" == "css=.info_form"  Select Frame  css=iframe
  Wait Until Page Contains Element  ${selector}
  Sleep  .5
  ${is}  Get Text  ${selector}
  Should Contain  ${is}  ${type}

Перевірити тип процедури за зразком
  [Arguments]  ${selector}  ${should}
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
  Sleep  1
  Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${loading}
  Sleep  1

Зайти на сторінку тарифів
  Click Element  ${button taryfy}
  Location Should Contain  /taryfy/

Перевірити кількість закладок
  Select Frame  css=iframe
  ${count}  Get Element Count  ${taryfy text}
  Run Keyword if  '${count}' != '4'  Fail  Не вірна кількість закладок тарифів

Закладка Публічні закупівлі
  Click Element  ${taryfy text}:nth-child(1)
  ${should}  Set variable   Публічні закупівлі ProZorro та торги RIALTO
  ${is}  Get Text  ${taryfy text}:nth-child(1)
  Should Be Equal  ${is}  ${should}

Закладка Комерційні торги
  Click Element  ${taryfy text}:nth-child(2)
  ${should}  Set variable    Комерційні торги
  ${is}  Get Text  ${taryfy text}:nth-child(2)
  Should Be Equal  ${is}  ${should}

Закладка Продаж активів банків, що ліквідуються (ФГВФО)
  Click Element  ${taryfy text}:nth-child(3)
  ${should}  Set variable    Продаж активів банків, що ліквідуються (ФГВФО)
  ${is}  Get Text  ${taryfy text}:nth-child(3)
  Should Be Equal  ${is}  ${should}

Закладка Продаж і оренда майна/активів Державних підприємств
  Click Element  ${taryfy text}:nth-child(4)
  ${should}  Set variable    Продаж і оренда майна/активів Державних підприємств
  ${is}  Get Text  ${taryfy text}:nth-child(4)
  Should Be Equal  ${is}  ${should}

Перевірити тендерний документ
  Run Keyword If  '${IP}' == ''  Перевірити тендерний документ не для IP
  ...  ELSE  Run Keywords
  ...  Go Back

Перевірити тендерний документ не для IP
  ${status}  Перевірити наявність документа
  Run Keyword If  '${status}' == '${True}'  Run Keywords
  ...  Open Button  ${tender doc exept EDS}
  ...  AND  Run Keyword And Expect Error  *  Location Should Contain  error
  ...  AND  Run Keyword And Expect Error  *  Page Should Contain  an error
  ...  AND  Go Back
  ...  AND  Go Back

Перевірити наявність документа
  # for commercial doc
  # xpath=//a[@class='fileLink'][not(contains(text(), 'sign.p7s'))]
  # |//*[@data-qa='tender-tabs-info-attachments']//a
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${tender doc exept EDS}
  [Return]  ${status}

Change Start Page
  ${start_page}  Set Variable  ${IP}
  Set Global Variable  ${start_page}

Відкрити особистий кабінет
  Page Should Contain Element  ${personal account}
  Click Element  ${personal account}
  ${status}  Run Keyword And Return Status  Location Should Contain  test
  Run Keyword If  "${status}" == "False"  Location Should Contain  /webparts/
  ...  ELSE  Location Should Contain  /WEBPARTS/
  Page Should Contain Element  css=.sidebar-menu
  Page Should Contain Element  css=.main-content

Відкрити особистий кабінет webcliend
  Page Should Contain Element  ${personal account}
  Click Element  ${personal account}
  Location Should Contain  /webclient/
  Go To  ${start_page}

Перевірити сторінку окремого лота в мультилоті
  ${status}  Run Keyword And Ignore Error  Перейти по результату пошуку  ${last found multiple element}
  Run Keyword If  '${status[0]}' == 'PASS'  Перевірити лот в мультилоті за наявністю
  ...  ELSE  Pass Execution  Tender with multiple lots doesn't present on the page

Перевірити лот в мультилоті за наявністю
  Select Frame  css=iframe
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${first lot}
  Run Keyword If  '${status}' == 'True'  Перевірити лот в мультилоті
  ...  ELSE  Pass Execution  It's one lot tender

Перевірити лот в мультилоті
  ${lot name}  Get Text  ${first lot}
  Open Button  ${first lot}
  Select Frame  css=iframe
  ${text}  Get Text  css=.title-lot h1
  Should Contain  ${text}  ${lotname[:-3]}
  Page Should Contain Element  css=a[class='button-lot show-control']
  ${count multiple lot checked}  Evaluate  ${count multiple lot checked} + 1
  Set Global Variable  ${count multiple lot checked}

Відкрити сторінку аналітики
  Go to  ${analytics_page}
  Дочекатись закінчення загрузки сторінки
  ${value}=  Get text  xpath=//*[@class="text-center"]/h3
  Should Contain  'Публічні закупівлі'  ${value}

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
  Click Element  xpath=//*[contains(@class, 'calendar')]
  Click Element  xpath=//div[contains(text(), 'Поточний рік')]
  Дочекатись закінчення загрузки сторінки
  ${tenders_after}  Get Text  ${num_of_tenders}
  ${tenders_after}  Evaluate  int(${tenders_after})
  Run Keyword if  ${tenders_before} > ${tenders_after}  Fail  Не працює фільтрація по періоду


