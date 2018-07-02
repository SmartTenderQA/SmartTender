*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${tender}                           Простой однолотовый
${prepared_tender}                  xpath=//tr[@class='head']/td/a[contains(text(), '${tender}') and @href]
${make proposal link}               xpath=//div[@class='row']//a[contains(@class, 'button')]


*** Test Cases ***
Відкрити сторінку з пошуком
  Зайти на сторінку комерційніх торгів


Знайти потрібній тендер
  Відфільтрувати по формі торгів  Відкриті торги. Аналіз пропозицій
  Виконати пошук тендера
  Перейти по результату пошуку  ${prepared_tender}
  ${location}  Get Location
  Set To Dictionary  ${data}  tender_url=${location}


Подати пропозицію
  debug
  Перевірити кнопку подачі пропозиції  ${make proposal link}
  ${location}  Get Location
  Set To Dictionary  ${data}  tender_url=${location}
  Заповтини поле з ціною
  Змінити кількість одиниць
  Заповнити поле Інф. учасника
  Надіслати пропозицію


Перевірити дані у поданій пропозиції
  debug
  Go To  ${data.tender_url}
  Перевірити ціну
  Перевірити кількість
  Перевірити Опис

*** Keywords ***
Precondition
  Start
  Login  user1
  ${data}  Create Dictionary
  Set Global Variable  ${data}


Postcondition
  Close All Browsers


Заповтини поле з ціною
  ${bid}  random_number  1  10000000
  Input Text  xpath=(//label[contains(text(), 'Ціна за одиницю')]/ancestor::tr//input)[1]  ${bid}
  Set To Dictionary  ${data}  bid_value=${bid}


Змінити кількість одиниць
  ${max}  Get Text  xpath=//label[contains(text(), 'Потреба')]/../following-sibling::*
  ${count}  random_number  1  ${max}
  Input Text  xpath=(//label[contains(text(), 'Ціна за одиницю')]/ancestor::tr//input)[2]  ${count}
  Set To Dictionary  ${data}  bid_count=${count}


Заповнити поле Інф. учасника
  ${text}  create_sentence  30
  Input Text  xpath=//label[contains(text(), 'Інф. учасника')]/../following-sibling::*//textarea  ${text}
  Set To Dictionary  ${data}  description=${text}


Надіслати пропозицію
  Click Element  xpath=//*[contains(text(), 'Надіслати пропозицію')]
  Wait Until Page Contains  Ваша пропозиція прийнята!  20


Перевірити ціну
  ${value}  Get Element Attribute  xpath=(//label[contains(text(), 'Ціна за одиницю')]/ancestor::tr//input)[1]  value
  ${value}  Evaluate  '${value}'.replace(" ", "")
  Should Be Equal  ${value}  ${data.bid_value}

Перевірити кількість
  ${value}  Get Element Attribute  xpath=(//label[contains(text(), 'Ціна за одиницю')]/ancestor::tr//input)[2]  value
  Should Be Equal  ${value}  ${data.bid_count}

Перевірити Опис
  ${value}  Get Element Attribute  xpath=//label[contains(text(), 'Інф. учасника')]/../following-sibling::*//textarea  value
  Should Be Equal  ${value}  ${data.description}