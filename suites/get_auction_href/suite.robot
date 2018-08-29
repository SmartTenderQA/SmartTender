*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Відкрити вікна для всіх користувачів
Suite Teardown  Suite Postcondition
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${tender}                           Простой однолотовый
${prepared_tender}                  xpath=//tr[@class='head']/td/a[contains(text(), '${tender}') and @href]
${make proposal link}               xpath=//div[@class='row']//a[contains(@class, 'button')]
${start_page}                       http://smarttender.biz
${webClient loading}                id=LoadingPanel


*** Test Cases ***
Створити тендер
  [Tags]  create_tender
  Switch Browser  tender_owner
  Sleep  2
  Відкрити сторінку для створення аукціону на продаж
  Відкрити вікно створення тендеру
  Wait Until Keyword Succeeds  30  3  Вибрати тип процедури  Голландський аукціон
  Заповнити auctionPeriod.startDate
  Заповнити value.amount
  Заповнити minimalStep.percent
  Заповнити dgfDecisionID
  Заповнити dgfDecisionDate
  Заповнити title
  Заповнити dgfID
  Заповнити description
  Заповнити guarantee.amount
  Заповнити items.description
  Заповнити items.quantity
  Заповнити items.unit.name
  Заповнити items.classification.description
  Заповнити procuringEntity.contactPoint.name
  Зберегти чернетку
  Оголосити тендер
  Отримати та зберегти auctionID
  Звебегти дані в файл


If skipped create tender
  [Tags]  get_tender_data
  ${json}  Get File  ${OUTPUTDIR}/artifact.json
  ${data}  conver json to dict  ${json}
  Set Global Variable  ${data}


Знайти тендер усіма користувачами
  [Tags]  find_tender
  [Template]  Знайти тендер користувачем
  tender_owner
  viewer
  provider1


#Перевірити посилання на перегляд аукціону усіма користувачами
#  [Tags]  get_auction_view_link
#  [Template]  Перевірити посилання на перегляд аукціону
#  tender_owner
#  viewer
#  provider1


#Неможливість отримати посилання на участь в аукціоні без поданої пропозиції



Подати пропозицію учасником
  Switch Browser  provider1
  Sleep  2
  debug
  Пройти кваліфікацію для подачі пропозиції  ${data['auctionID']}
  Відкрити сторінку подачі пропозиції
  Заповнити value.amount для подачі пропозиції
  Подати пропозицію



Отримати поcилання на участь в аукціоні учасником



*** Keywords ***
Відкрити вікна для всіх користувачів
  Open Browser  ${start_page}  ${browser}  alias=tender_owner
  Login  fgv_prod_owner
  Go Back
  Open Browser  ${start_page}  ${browser}  alias=viewer
  Open Browser  ${start_page}  ${browser}  alias=provider1
  Login  test_it.ua
  ${data}  Create Dictionary
  Set Global Variable  ${data}


Отримати та зберегти auctionID
  ${auctionID}  Get Element Attribute  xpath=(//a[@href])[2]  text
  Set To Dictionary  ${data}  auctionID=${auctionID}


Звебегти дані в файл
  ${json}  conver dict to json  ${data}
  Create File  ${OUTPUTDIR}/artifact.json  ${json}


Знайти тендер користувачем
  [Arguments]  ${role}
  Switch Browser  ${role}
  Sleep  2
  Відкрити сторінку тестових торгів
  Знайти тендер по auctionID  ${data['auctionID']}


Перевірити посилання на перегляд аукціону
  [Arguments]  ${role}
  Switch Browser  ${role}
  Sleep  2
  Перейти на сторінку перегляду аукціону


Перейти на сторінку перегляду аукціону
  ${href}  Get Element Attribute


Пройти кваліфікацію для подачі пропозиції
  [Arguments]  ${tender_uaid}
  Відкрити бланк подачі заявки
  Додати файл для подачі заявки
  Ввести ім'я для подачі заявки
  Підтвердити відповідність для подачі заявки
  Відправити заявку для подачі пропозиції та закрити валідаційне вікно
  Підтвердити заявку  ${tender_uaid}
