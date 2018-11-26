*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Postcondition

Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${save btn locator}     //*[@data-qa='button-success']

#Запуск
#robot --consolecolors on -L TRACE:INFO -d test_output -v user:ssp_tender_owner -v hub:None suites/small_privatization/suite.robot
*** Test Cases ***
Перейти до створення об'єкта малої приватизації
    Перейти на сторінку реєстру приватизації
    Натиснути кнопку створити об'єкт малої приватизації


Перевірити неможливість створити об'єкт без заповнення жодного поля
    Click Element  ${save btn locator}
    Element Should Be Visible  //div[@class='ivu-message']


Заповнити необхідні поля
    Ввести унікальний код об'єкту

 	Заповнити title
    Заповнити description

    Заповнити decision.title
    Заповнити decision.number
    Заповнити decision.date

    Заповнити object.description
    Заповнити object.kind
    Заповнити object.count
    Заповнити object.unit
    Заповнити object.postalcode
    Заповнити object.country
    Заповнити object.city
    Заповнити object.address

    Створити об'єкт у реєстрі


Перевірити збережену інформацію
    Перевірити title
    Перевірити description

    Перевірити decision

    Перевірити object.description
    Перевірити object.kind
    Перевірити object.amount
    Перевірити object.address


*** Keywords ***
Precondition
	${data}  Create Dictionary
	Set Global Variable  ${data}
    Start in grid  ${user}
    Go To  ${start_page}


Postcondition
    Log  ${data}
    Close All Browsers


Перейти на сторінку реєстру приватизації
    Click Element  (//div[@id='main']/div[@class='link-image']/*)[2]
    Click Element  link=Аукціони на продаж активів держпідприємств
    Дочекатись закінчення загрузки сторінки
    Click Element  //*[@data-qa='registry']
    Дочекатись закінчення загрузки сторінки
    Click Element  //span[contains(text(),'Кабінет')]


Натиснути кнопку створити об'єкт малої приватизації
    Click Element  //*[@data-qa='button-create-privatization-object']
    Дочекатись закінчення загрузки сторінки


Ввести унікальний код об'єкту
    ${id}  random_number  1000  10000
 	Set To Dictionary  ${data}  id  ${id}
 	Sleep  0.5
    ${locator}  Set Variable  //*[@data-qa='input-check-exists-assets']/input
    Input Text  ${locator}  ${id}
    Click Element  //*[@data-qa='button-asset-checking']
    Дочекатись закінчення загрузки сторінки
    ${status}  Run Keyword And Return Status  Page Should Not Contain Element  ${locator}
    Run Keyword If  ${status} == ${False}  Ввести унікальний код об'єкту


Заповнити title
	${text}  create_sentence  5
	${title}  Set Variable  [ТЕСТУВАННЯ] ${text}
	${selector}  Set Variable  xpath=//*[@data-qa='input-title']//*[@autocomplete="off"]
	Заповнити текстове поле  ${selector}  ${title}
	Set To Dictionary  ${data}  title=${title}


Заповнити description
	${description}  create_sentence  20
	${selector}  Set Variable  xpath=//*[@data-qa='input-description']//*[@autocomplete="off"]
	Заповнити текстове поле  ${selector}  ${description}
	Set To Dictionary  ${data}  description=${description}


Заповнити decision.title
	${title}  create_sentence  5
	${selector}  Set Variable  xpath=//*[@data-qa='input-decision-title']//*[@autocomplete="off"]
	Заповнити текстове поле  ${selector}  ${title}
	${dict}  Create Dictionary  title=${title}
	Set To Dictionary  ${data}  decision  ${dict}


Заповнити decision.number
	${first}  random_number  1000  10000
	${second}  random_number  100  1000
	${number}  Set Variable  ${first}/${second}-${first}
	${selector}  Set Variable  xpath=//*[@data-qa='input-decision-number']//*[@autocomplete="off"]
	Заповнити текстове поле  ${selector}  ${number}
	Set To Dictionary  ${data['decision']}  number  ${number}


Заповнити decision.date
	${date}  smart_get_time  0  m
	${selector}  Set Variable  xpath=//*[@data-qa='datepicker-decision-date']//*[@autocomplete="off"]
	Заповнити текстове поле  ${selector}  ${date}
	Set To Dictionary  ${data['decision']}  date  ${date}


Заповнити object.description
	${description}  create_sentence  20
	${selector}  Set Variable  xpath=//*[@data-qa='input-items-description']//*[@autocomplete="off"]
	Заповнити текстове поле  ${selector}  ${description}
	${dict}  Create Dictionary  description=${description}
	Set To Dictionary  ${data}  object  ${dict}


Заповнити object.kind
    ${selector}  Set Variable  xpath=//*[@data-qa='select-items-object-kind']
    Scroll Page To Element XPATH  ${selector}
    Click Element  ${selector}
    Sleep  .5
    Click Element  ${selector}/div[@class='ivu-select-dropdown']//*[contains(text(),'102')]
    ${kind}  Get Text  ${selector}//*[@class='ivu-select-selected-value']
   	Should Not Be Empty  ${kind}
	Set To Dictionary  ${data['object']}  kind  ${kind}


Заповнити object.count
	${first}  random_number  1  100000
	${second}  random_number  1  1000
    ${count}  Evaluate  str(round(float(${first})/float(${second}), 5))
	${selector}  Set Variable  xpath=//*[@data-qa='input-item-count']//*[@autocomplete="off"]
	Input Text  ${selector}  ${count}
	Set To Dictionary  ${data['object']}  count  ${count}


Заповнити object.unit
    ${selector}  Set Variable  xpath=//*[@data-qa='select-item-unit']
    Scroll Page To Element XPATH  ${selector}
	${unit}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент з випадаючого списка  ${selector}  метри квадратні
	Set To Dictionary  ${data['object']}  unit  ${unit}


Заповнити object.postalcode
	${postalcode}  random_number  10000  99999
	${selector}  Set Variable  xpath=//div[contains(@class,'address-label') and not(contains(@class,'offset '))]//input[@type='text']
	Заповнити текстове поле  ${selector}  ${postalcode}
	Set To Dictionary  ${data['object']}  postalcode  ${postalcode}


Заповнити object.country
   	${selector}  Set Variable  xpath=//div[@class='ivu-col ivu-col-span-sm-9']
	Scroll Page To Element XPATH  ${selector}
    ${country}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент з випадаючого списка  ${selector}  Україна
    Set To Dictionary  ${data['object']}  country  ${country}


Заповнити object.city
   	${selector}  Set Variable  xpath=//div[@class='ivu-col ivu-col-span-sm-10']
    ${city}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент з випадаючого списка  ${selector}  Київ
    Set To Dictionary  ${data['object']}  city  ${city}


Заповнити object.address
    ${address}  create_sentence  2
   	${selector}  Set Variable  xpath=//*[@data-qa='component-item-address']/div[contains(@class,'ivu-form-item-required')]//input
   	Заповнити текстове поле  ${selector}  ${address}
    Set To Dictionary  ${data['object']}  address  ${address}


Вибрати та повернути елемент з випадаючого списка
    [Arguments]  ${selector}  ${value}
  	${item}  Set Variable  ${selector}//ul[@class='ivu-select-dropdown-list']//*[contains(text(),'${value}')]
  	${input}  Set Variable  ${selector}//input[@type='text']
    Click Element  ${input}
    Sleep  .5
    Input Text  ${input}  ${value}
    Sleep  .5
    Wait Until Page Contains Element  ${item}
    Click Element  ${item}
    ${text}  Get Element Attribute  ${input}  value
   	Should Not Be Empty  ${text}
    [Return]  ${text}


Створити об'єкт у реєстрі
    Scroll Page To Element XPATH  ${save btn locator}
    Click Element  ${save btn locator}
    Дочекатись Закінчення Загрузки Сторінки


Перевірити title
    ${is}  Get Text  //div[@class='ivu-card-body']//h3
    ${should}  Get From Dictionary  ${data}  title
    Should Be Equal  ${is}  ${should}


Перевірити description
    ${is}  Get Text  //div[@class='ivu-card-body']//*[@class='text-justify']
    ${should}  Get From Dictionary  ${data}  description
    Should Be Equal  ${is}  ${should}


Перевірити decision
    ${is}  Get Text  (//*[@data-qa='value'])[2]
    ${title}  Get From Dictionary  ${data['decision']}  title
    ${number}  Get From Dictionary  ${data['decision']}  number
    ${date}  Get From Dictionary  ${data['decision']}  date
    Should Contain  ${is}  ${title}
    Should Contain  ${is}  ${number}
    Should Contain  ${is}  ${date}


Перевірити object.description
    ${is}  Get Text  (//*[@data-qa='item']//*[@data-qa='value'])[1]
    ${should}  Get From Dictionary  ${data['object']}  description
    Should Be Equal  ${is}  ${should}


Перевірити object.kind
    ${is}  Get Text  (//*[@data-qa='item']//*[@data-qa='value'])[2]
    ${should}  Get From Dictionary  ${data['object']}  kind
    Should Be Equal  ${is}  ${should}


Перевірити object.amount
    ${is}  Get Text  (//*[@data-qa='item']//*[@data-qa='value'])[3]
    ${count}  Get From Dictionary  ${data['object']}  count
    ${unit}  Get From Dictionary  ${data['object']}  unit
    Should Contain  ${is}  ${count}
    Should Contain  ${is}  ${unit}


Перевірити object.address
    ${is}  Get Text  (//*[@data-qa='item']//*[@data-qa='value'])[4]
    ${postalcode}  Get From Dictionary  ${data['object']}  postalcode
    ${country}  Get From Dictionary  ${data['object']}  country
    ${city}  Get From Dictionary  ${data['object']}  city
    ${address}  Get From Dictionary  ${data['object']}  address
    Should Contain  ${is}  ${postalcode}
    Should Contain  ${is}  ${country}
    Should Contain  ${is}  ${city}
    Should Contain  ${is}  ${address}