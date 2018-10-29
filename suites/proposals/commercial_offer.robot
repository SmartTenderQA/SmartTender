*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Teardown  Run Keywords
...  Log Location
...  AND  Run Keyword If Test Failed  Capture Page Screenshot



*** Variables ***
${tender}                           Простой однолотовый
${prepared_tender}                  xpath=//tr[@class='head']/td/a[contains(text(), '${tender}') and @href]
${make proposal link}               xpath=//*[@data-qa='tender-divSubmit-btnSubmit']

${delivery_term_field}              xpath=(//label[contains(text(), 'Термін поставки')]/ancestor::tr//input)[1]
${guaranty_field}                   //label[contains(text(), 'Гарантія(років)')]/ancestor::tr//input
${terms_of_payment_field}           xpath=//label[contains(text(), 'Умови оплати')]/../following-sibling::*//textarea
${terms_of_delivery_field}          xpath=//label[contains(text(), 'Умови доставки')]/../following-sibling::*//textarea


*** Test Cases ***
Відкрити сторінку з пошуком
	Зайти на сторінку комерційніх торгів


Знайти потрібній тендер
	Відфільтрувати по формі торгів  Відкриті торги. Аналіз пропозицій
	Виконати пошук тендера
	Перейти по результату пошуку  ${prepared_tender}
	${location}  Get Location
	Log  ${location}  WARN
	Set To Dictionary  ${data}  tender_url=${location}


Подати пропозицію
	Wait Until Keyword Succeeds  60  3  Натиснути кнопку подачі пропозиції  ${make proposal link}
	${location}  Get Location
	Set To Dictionary  ${data}  tender_url=${location}
	Заповтини поле з ціною
	Змінити кількість одиниць
	Заповнити поле Інф. учасника
	Заповнити поле додаткова інформація
	Заповнити поле термін поставки
	Заповнити поле гарантія(років)
	Заповнити поле умови оплати
	Заповнити поле умови доставки
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
	Перевірити термін поставки
	Перевірити гарантію(років)
	Перевірити Умови оплати
	Перевірити умови доставки
	#Перевірити вміст файлу


*** Keywords ***
Precondition
	Start  user1
	${data}  Create Dictionary
	Set Global Variable  ${data}


Postcondition
	Log  ${data}
	Close All Browsers


Заповтини поле з ціною
  ${max price selector}  Set Variable  //*[contains(text(), "Краща ціна")]/../following-sibling::*//span
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${max price selector}
  ${max}  Run Keyword If  ${status} == ${True}  Get Text  ${max price selector}
  ...  ELSE  Set Variable  10000000
  ${amount}  Evaluate  '${max}'.replace(" ", "")
  ${float}  Evaluate  float(${amount})
  ${min}  Evaluate  str(float(${amount})//2)
  #${bid}  random_number  ${min}  ${float}
  Input Text  xpath=(//label[contains(text(), 'Ціна за одиницю')]/ancestor::tr//input)[1]  ${float}
  Set To Dictionary  ${data}  bid_value=${float}


Змінити кількість одиниць
  ${max}  Get Text  xpath=//label[contains(text(), 'Потреба')]/../following-sibling::*
  ${count}  random_number  1  ${max}
  Input Text  xpath=(//label[contains(text(), 'Кількість')]/ancestor::tr//input)[last()]  ${count}
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
  ${value}  Get Element Attribute  xpath=(//label[contains(text(), 'Ціна за одиницю')]/ancestor::tr//input)[last()]  value
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


Перевірити термін поставки
  ${value}  Get Element Attribute  ${delivery_term_field}  value
  Should Be Equal  "${value}"  "${data.delivery_term}"


Перевірити гарантію(років)
  ${value}  Get Element Attribute  ${guaranty_field}  value
  Should Be Equal  "${value}"  "${data.guaranty}"


Перевірити Умови оплати
  ${value}  Get Text  ${terms_of_payment_field}
  Should Be Equal  "${value}"  "${data.terms_of_payment}"


Перевірити умови доставки
  ${value}  Get Text  ${terms_of_delivery_field}
  Should Be Equal  "${value}"  "${data.terms_of_delivery}"


Перевірити вміст файлу
  ${href}  Get Element Attribute  xpath=//*[contains(text(), 'Список завантажених файлів')]/..//td[2]//a  href
  ${content}  download_file_and_return_content  ${href}
  Should Be Equal  ${content}  ${data.file.content}


Натиснути кнопку подачі пропозиції
  [Arguments]  ${selector}
  Run Keyword And Ignore Error  Page Should Contain Element  ${selector}
  Run Keyword And Ignore Error  Click Element  ${selector}
  Location Should Contain  /edit/


Заповнити поле термін поставки
  ${days}  random_number  1  28
  Input Text  ${delivery_term_field}  ${days}
  Set To Dictionary  ${data}  delivery_term=${days}


Заповнити поле гарантія(років)
  ${guaranty}  random_number  1  12
  Input Text  ${guaranty_field}  ${guaranty}
  Set To Dictionary  ${data}  guaranty=${guaranty}


Заповнити поле умови оплати
  ${text}  create_sentence  10
  Input Text  ${terms_of_payment_field}  ${text}
  Set To Dictionary  ${data}  terms_of_payment=${text}


Заповнити поле умови доставки
  ${text}  create_sentence  10
  Input Text  ${terms_of_delivery_field}  ${text}
  Set To Dictionary  ${data}  terms_of_delivery=${text}
