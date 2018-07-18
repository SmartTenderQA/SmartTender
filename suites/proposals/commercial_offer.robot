*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${tender}                           Простой однолотовый
${prepared_tender}                  xpath=//tr[@class='head']/td/a[contains(text(), '${tender}') and @href]
${make proposal link}               xpath=//*[@data-qa='tender-divSubmit-btnSubmit']


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
  Натиснути кнопку подачі пропозиції  ${make proposal link}
  ${location}  Get Location
  Set To Dictionary  ${data}  tender_url=${location}
  Заповтини поле з ціною
  Змінити кількість одиниць
  Заповнити поле Інф. учасника
  Заповнити поле додаткова інформація
  Видалити файл при наявності
  @{file}  Створити файл
  Додати файл  @{file}
  Надіслати пропозицію


Перевірити дані у поданій пропозиції
  Sleep  180
  Go To  ${data.tender_url}
  Перевірити ціну
  Перевірити кількість
  Перевірити Опис
  Перевірити ім'я файла
  #Перевірити вміст файлу

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


Заповнити поле додаткова інформація
  ${text}  create_sentence  25
  Input Text  xpath=//h4[contains(text(), 'Додаткова інформація')]/following-sibling::textarea  ${text}
  Set To Dictionary  ${data}  additional_information=${text}


Надіслати пропозицію
  Натиснути надіслати пропозицію
  Wait Until Page Contains  Ваша пропозиція прийнята!  20


Натиснути надіслати пропозицію
  Click Element At Coordinates  xpath=//*[contains(text(), 'Надіслати пропозицію')]  -10  0
  ${status}  Run Keyword And Return Status  Page Should Not Contain Element  xpath=//*[contains(text(), 'Надіслати пропозицію')]
  Run keyword If  '${status}' == '${False}'   Натиснути надіслати пропозицію


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


Перевірити додаткову інформацію
  ${value}  Get Element Attribute  xpath=//h4[contains(text(), 'Додаткова інформація')]/following-sibling::textarea  value
  Should Be Equal  ${value}  ${data.additional_information}


Видалити файл при наявності
  ${selector}  Set Variable  css=a.remove-original
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${selector}
  Run Keyword If  '${status}' == 'True'  Click Element  ${selector}
  Page Should Not Contain Element  ${selector}


Створити файл
  ${path}  ${name}  ${content}  create_fake_doc  30
  [Return]  ${path}  ${name}  ${content}


Додати файл
  [Arguments]  ${path}  ${name}  ${content}
  Choose File  xpath=//*[contains(text(), 'Додати')]/../following-sibling::input[1]  ${path}
  ${file}  Create Dictionary
  Set To Dictionary  ${data}  file=${file}
  Set To Dictionary  ${data.file}  path=${path}
  Set To Dictionary  ${data.file}  name=${name}
  Set To Dictionary  ${data.file}  content=${content}


Перевірити ім'я файла
  ${value}  Get Text  xpath=//*[contains(text(), 'Список завантажених файлів')]/..//td[1]
  Should Be Equal  ${value}  ${data.file.name}

Перевірити вміст файлу
  ${href}  Get Element Attribute  xpath=//*[contains(text(), 'Список завантажених файлів')]/..//td[2]//a  href
  ${content}  download_file_and_return_content  ${href}
  Should Be Equal  ${content}  ${data.file.content}

Натиснути кнопку подачі пропозиції
  [Arguments]  ${selector}
  Page Should Contain Element  ${selector}
  Click Element  ${selector}
  Wait Until Keyword Succeeds  10  3s  Location Should Contain  /edit/
