*** Settings ***
Resource  ../../src/src.robot
Test Teardown   Run Keyword If Test Failed  Run Keywords
...                                         Log Location  AND
...                                         Capture Page Screenshot
Suite Teardown  Close All Browsers


*** Variables ***
${tender_body}                      //*[@class='panel-body']
${search field}                     //*[@data-qa='search-phrase']//input
${search button}                    //*[@data-qa='search-phrase']//button

${select status button}             //*[@data-qa='search-tenderStatuses']
${select type bidding button}       //*[@data-qa='search-biddingTypes']
${search-organizers}                //*[@data-qa="search-organizers"]
${negative result}                  css=h5
${bidding type block}               //*[@data-qa="procedure-type"]|//*[@data-qa="tender-header-detail-biddingForm"]//*[@data-qa]


#zapusk
#robot --consolecolors on -L TRACE:INFO -d test_output -i $env -v env:$env suites/mirror/suite.robot
*** Test Cases ***
Відкрити стартову сторінку
	[Tags]  test  pre_prod  utg  ukroboronprom  uspa
	${start_page}  Set Variable If
	...  '${env}' == 'test'                 http://test.smarttender.biz/TenderMirror/?mirrorId=1
	...  '${env}' == 'utg'                  http://utg.ua/utg/purchases/prozorro.html
	...  '${env}' == 'ukroboronprom'        https://smarttender.biz/TenderMirror/?mirrorId=5804
	...  '${env}' == 'pre_prod'             http://iis8.smarttender.biz.int//TenderMirror/?mirrorId=5804
	...  '${env}' == 'uspa'                 http://www.uspa.gov.ua/ru/gosudarstvennye-zakupki/elektronnaya-ploshchadka-smarttender-biz
	Set Global Variable  ${start_page}
	Run Keyword  Відкрити браузер ${browser.lower()}  ${env}
	Set Window Size  1280  1024
	Run Keyword And Ignore Error  Виділити портрібний iFrame(за необхідністю)
	Дочекатись закінчення загрузки сторінки(skeleton)
	Sleep  1


Переконатися в наявності тендерів
	[Tags]  test  pre_prod  utg  ukroboronprom  uspa
	${count}  Отримати кількість тендерів на сторінці
	Run Keyword if  '${count}' == '0'  Fail  Oops! На сторінці немає жодного тендера


Перевірити наявність компонентів в панелі пошуку
	[Tags]  test  pre_prod  utg  ukroboronprom  uspa
	Page Should Contain Element  ${search field}
	Page Should Contain Element  ${search button}
	Run Keyword If  '${env}' != 'ukroboronprom' and '${env}' != 'pre_prod'
	...  Page Should Contain Element  ${select status button}
	Page Should Contain Element  ${select type bidding button}
	Page Should Contain Element  ${search-organizers}


Виконати негативний пошук
	[Tags]  test  pre_prod  utg  ukroboronprom  uspa
	Input text  ${search field}  Тендернезнайдено.Тадам!
	Click Element  ${search button}
	Дочекатись закінчення загрузки сторінки(skeleton)
	elements.Дочекатися відображення елемента на сторінці  ${negative result}
	${is}  Get Text  ${negative result}
	Should Be Equal  ${is}  За Вашим запитом нічого не знайдено


Перевірити роботу фільтра статус
	[Tags]  test  utg  uspa
	[Template]  Перевірити тендер зі статусом
	Період уточнень
	Прийом пропозицій
	Прекваліфікація
	Прекваліфікація. Період очікування
	Аукціон
	Кваліфікація
	Пропозиції розглянуті
	Опубліковано намір укласти договір
	Очікування рішення організатора
	Очікування стадії 2
	Завершено
	Закупівля не відбулась
	Закупівля відмінена


Перевірити роботу фільтра вид торгів
	[Tags]  test
	[Template]  Перевірити тендер
	Допорогові закупівлі
	Відкриті торги
	Відкриті торги з публікацією англійською мовою
	Переговорна процедура для потреб оборони
	Відкриті торги для закупівлі енергосервісу
	Конкурентний діалог 2-ий етап
	Конкурентний діалог з публікацією англійською мовою 2-ий етап
	Укладання рамкової угоди
	Відбір для закупівлі за рамковою угодою
	Звіт про укладений договір
	Переговорна процедура
	Переговорна процедура (скорочена)
	Конкурентний діалог 1-ий етап


Перевірити роботу фільтра вид торгів
	[Tags]  utg
	[Template]  Перевірити тендер
	Допорогові закупівлі
	Відкриті торги
	Відкриті торги з публікацією англійською мовою
	Відкриті торги для закупівлі енергосервісу
	Конкурентний діалог 2-ий етап
	Конкурентний діалог з публікацією англійською мовою 2-ий етап
	Укладання рамкової угоди
	Звіт про укладений договір
	Переговорна процедура
	Переговорна процедура (скорочена)
	Конкурентний діалог 1-ий етап
	Конкурентний діалог з публікацією англійською мовою 1-ий етап



Перевірити роботу фільтра вид торгів
	[Tags]  ukroboronprom  pre_prod
	[Template]  Перевірити тендер
	Відкриті торги. Аукціон
	Відкриті торги. Аналіз пропозицій
	Відкриті торги. Неформалізована оцінка
	Відкриті торги. Аналіз ринку


Перевірити роботу фільтра вид торгів
	[Tags]  uspa
	[Template]  Перевірити тендер
	Допорогові закупівлі
	Відкриті торги
	Відкриті торги з публікацією англійською мовою
	Відкриті торги для закупівлі енергосервісу
	Конкурентний діалог 2-ий етап
	Конкурентний діалог з публікацією англійською мовою 2-ий етап
	Укладання рамкової угоди
	Звіт про укладений договір
	Переговорна процедура
	Переговорна процедура (скорочена)
	Конкурентний діалог 1-ий етап
	Конкурентний діалог з публікацією англійською мовою 1-ий етап


*** Keywords ***
Перевірити тендер зі статусом
	[Arguments]  ${tender_status}
	Встановити фільтр  статус  ${tender_status}
	${tender_count}  Отримати кількість тендерів на сторінці
	Run Keyword If  ${tender_count} == 0
	...  Залогувати дані про відсутність тендерів  Статус торгів - ${tender_status}
	...  ELSE  Run Keywords
	...  Element Should Contain  ${tender_body}  ${tender_status}                   AND
	...  Перейти по результату пошуку за номером  1                                 AND
	...  Element Should Contain  //*[@data-qa="status"]  ${tender_status}           AND
	...  Go Back                                                                    AND
	...  Run Keyword And Ignore Error  Виділити портрібний iFrame(за необхідністю)  AND
	...  Дочекатись закінчення загрузки сторінки(skeleton)


Перевірити тендер
	[Arguments]  ${tender_type}
	Встановити фільтр  вид торгів  ${tender_type}
	${tender_count}  Отримати кількість тендерів на сторінці
	Run Keyword If  ${tender_count} == 0
	...  Залогувати дані про відсутність тендерів  Вид торгів - ${tender_type}
	...  ELSE  Run Keywords
	...  Element Should Contain  ${tender_body}/..  ${tender_type}                  AND
	...  Перейти по результату пошуку за номером  1                                 AND
	...  Element Should Contain  ${bidding type block}  ${tender_type}              AND
	...  Go Back                                                                    AND
	...  Run Keyword And Ignore Error  Виділити портрібний iFrame(за необхідністю)  AND
	...  Дочекатись закінчення загрузки сторінки(skeleton)


Залогувати дані про відсутність тендерів
	[Arguments]  ${text}
	Log  Oops! Немає підходящого тендера! ${text}  WARN
	Capture Page Screenshot


Встановити фільтр
	[Documentation]  ${filter_name}=статус/вид торгів
	[Arguments]  ${filter_name}  ${filter_value}
	new_search.Очистити фільтр пошуку
	${filter locator}  Set Variable If
	...  '${filter_name}' == 'статус'  ${select status button}
	...  '${filter_name}' == 'вид торгів'  ${select type bidding button}
	Click Element  ${filter locator}
	${item}  Set Variable  //li[text()='${filter_value}']
	Sleep  1
	Wait Until Keyword Succeeds  10s  1s  Click Element  ${item}
	Sleep  .5
	Click Element  ${filter locator}//i[contains(@class,'arrow-down-b')]
	Дочекатись закінчення загрузки сторінки(skeleton)


Отримати кількість тендерів на сторінці
	${tender_count}  Get Element Count  ${tender_body}
	[Return]  ${tender_count}


Перейти по результату пошуку за номером
	[Arguments]  ${n}
	${selector}  Set Variable  xpath=(${tender_body}//h5/a)[${n}]
	elements.Дочекатися Відображення Елемента На Сторінці  ${selector}
	${href}  Get Element Attribute  ${selector}  href
	${href}  Поправити лінку для IP  ${href}
	Go To  ${href}
	Дочекатись закінчення загрузки сторінки(skeleton)


Виділити портрібний iFrame(за необхідністю)
	Select Frame  //iframe[contains(@src,'smarttender.biz')]