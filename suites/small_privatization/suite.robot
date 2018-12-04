*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***

#Запуск
#robot --consolecolors on -L TRACE:INFO -d test_output -v user:ssp_tender_owner -v hub:None suites/small_privatization/suite.robot
*** Test Cases ***
Створити об'єкт МП
	small_privatization.Перейти на сторінку реєстру приватизації
    small_privatization.Перейти до створення об'єкта малої приватизації
	small_privatization_object.Заповнити необхідні поля
	small_privatization_object.Зберегти чернетку об'єкту
	small_privatization_object.Опублікувати об'єкт у реєстрі
	small_privatization_object.Отримати UAID для об'єкту


Створити інформаційне повідомлення МП
	Go To  ${start page}
	small_privatization.Перейти на сторінку реєстру приватизації
	small_privatization.Перейти до створення інформаційного повідомлення
	small_privatization_informational_message.Заповнити необхідні поля 1 етап
	small_privatization_informational_message.Зберегти чернетку повідомлення
	small_privatization_informational_message.Опублікувати інформаційне повідомлення у реєстрі
	small_privatization_informational_message.Перейти до коригування інформації
	small_privatization_informational_message.Заповнити необхідні поля 2 етап
	small_privatization_informational_message.Зберегти чернетку повідомлення
	debug
	small_privatization_informational_message.Натиснути передати на перевірку
	small_privatization_informational_message.Отримати UAID для повідомлення
	Зберегти словник у файл  ${data}  data


	debug


*** Keywords ***
Precondition
	${data}  Create Dictionary
	${object}  Create Dictionary
	${message}  Create Dictionary
	Set To Dictionary  ${data}  object  ${object}
	Set To Dictionary  ${data}  message  ${message}
	Set Global Variable  ${data}
    Start in grid  ${user}
    Go To  ${start_page}


Postcondition
    Log  ${data}
    Close All Browsers


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