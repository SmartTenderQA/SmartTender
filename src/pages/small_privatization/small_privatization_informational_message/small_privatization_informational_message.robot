*** Settings ***


*** Variables ***


*** Keywords ***
Заповнити необхідні поля 1 етап
	small_privatization_informational_message.Ввести унікальний код об'єкту
	small_privatization_informational_message.Заповнити decision.title
	small_privatization_informational_message.Заповнити decision.number
	small_privatization_informational_message.Заповнити decision.date
    small_privatization_informational_message.Прикріпити документ


Заповнити необхідні поля 2 етап
	small_privatization_informational_message.Заповнити conditions.date
	small_privatization_informational_message.Заповнити conditions.period
	small_privatization_informational_message.Заповнити conditions.startPrice
	small_privatization_informational_message.Заповнити conditions.step
	small_privatization_informational_message.Заповнити conditions.warrantyFee
	small_privatization_informational_message.Заповнити conditions.registrationFee
	small_privatization_informational_message.Заповнити conditions.stepCount
	small_privatization_informational_message.Заповнити bank.name
	small_privatization_informational_message.Заповнити bank.Requisites.type
	small_privatization_informational_message.Заповнити bank.Requisites.value
	small_privatization_informational_message.Заповнити bank.Requisites.description



Зберегти чернетку повідомлення
	${save btn}  Set variable  //div[@class='ivu-col ivu-col-span-6']//button[@type='button']
    Scroll Page To Element XPATH  ${save btn}
    Click Element  ${save btn}
    Дочекатись Закінчення Загрузки Сторінки


Опублікувати інформаційне повідомлення у реєстрі
	${publish btn}  Set Variable  //*[@data-qa='button-publish-information-message']
	Wait Until Element Is Visible  ${publish btn}
	Scroll Page To Element XPATH  ${publish btn}
	Click Element  ${publish btn}
    Дочекатись Закінчення Загрузки Сторінки


Ввести унікальний код об'єкту
    ${id}  Get From Dictionary  ${data['object']}  UAID
	${selector}  Set Variable  //*[contains(text(),'Унікальний код')]/following-sibling::*//input
    small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${id}


Заповнити decision.title
	${title}  create_sentence  5
	${selector}  Set Variable  //div[@class='ivu-form-item']//input
	small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${title}
	${decision}  Create Dictionary  title  ${title}
	Set To Dictionary  ${data['message']}  decision  ${decision}


Заповнити decision.number
	${first}  random_number  1000  10000
	${second}  random_number  100  1000
	${number}  Set Variable  ${first}/${second}-${first}
	${selector}  Set Variable  //div[@class='ivu-col ivu-col-span-sm-5']//div[@class='ivu-input-wrapper ivu-input-type']//input
	small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${number}
	Set To Dictionary  ${data['message']['decision']}  number  ${number}


Заповнити decision.date
	${date}  smart_get_time  0  m
	${selector}  Set Variable  //div[@class='ivu-input-wrapper ivu-input-type ivu-date-picker-editor']//input
	small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${date}
	Set To Dictionary  ${data['message']['decision']}  date  ${date}


Прикріпити документ
	${selector}  Set Variable  //div[@class='ivu-card-body']/div[@class='margin-bottom-20']
	${doc}  Створити та додати файл  ${selector}//input
	Element Should Contain  ${selector}  ${doc[1]}
	Set To Dictionary  ${data['message']}  document-name  ${doc[1]}


Перейти до Коригування інформації
	${edit btn}  Set Variable  //*[@data-qa='button-to-edit-page']
   	Wait Until Element Is Visible  ${edit btn}
    Scroll Page To Element XPATH  ${edit btn}
	Click Element  ${edit btn}
    Дочекатись Закінчення Загрузки Сторінки


Заповнити conditions.date
	${date + 15 min}  Evaluate  '{:%d.%m.%Y %H:%M:%S}'.format(datetime.datetime.now() + datetime.timedelta(minutes=15))  modules=datetime
	${selector}  Set Variable  //*[contains(text(),'Дата проведення аукціону')]/following-sibling::*//input
	small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${date + 15 min}
	Click Element  //*[contains(text(),'Дата проведення аукціону')]
	Sleep  .5
	${conditions}  Create Dictionary  date  ${date + 15 min}
	Set To Dictionary  ${data['message']}  conditions  ${conditions}


Заповнити conditions.period
	${period}  random_number  20  35
	${selector}  Set Variable  //*[contains(text(),'Період між аукціонами')]/following-sibling::*//input
	small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${period}
	Set To Dictionary  ${data['message']['conditions']}  period  ${period}


Заповнити conditions.startPrice
	${startPrice}  random_number  100000  1000000
	${selector}  Set Variable  //*[contains(text(),'Стартова ціна об’єкта')]/following-sibling::*//input[@type='text']
	small_privatization.Заповнити та перевірити поле з вартістю  ${selector}  ${startPrice}
	Set To Dictionary  ${data['message']['conditions']}  startPrice  ${startPrice}


Заповнити conditions.step
	${step}  random_number  1000  10000
	${selector}  Set Variable  //*[contains(text(),'Крок аукціону')]/following-sibling::*//input[@type='text']
	small_privatization.Заповнити та перевірити поле з вартістю  ${selector}  ${step}
	Set To Dictionary  ${data['message']['conditions']}  step  ${step}


Заповнити conditions.warrantyFee
	${warrantyFee}  random_number  100  5000
	${selector}  Set Variable  //*[contains(text(),'Розмір гарантійного внеску')]/following-sibling::*//input[@type='text']
	small_privatization.Заповнити та перевірити поле з вартістю  ${selector}  ${warrantyFee}
	Set To Dictionary  ${data['message']['conditions']}  warrantyFee  ${warrantyFee}


Заповнити conditions.registrationFee
	${registrationFee}  random_number  100  5000
	${selector}  Set Variable  //*[contains(text(),'Реєстраційний внесок')]/following-sibling::*//input[@type='text']
	small_privatization.Заповнити та перевірити поле з вартістю  ${selector}  ${registrationFee}
	Set To Dictionary  ${data['message']['conditions']}  registrationFee  ${registrationFee}


Заповнити conditions.stepCount
	${stepCount}  random_number  1  99
	${selector}  Set Variable  //*[contains(text(),'Кількість кроків')]/following-sibling::*//input
	small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${stepCount}
	Set To Dictionary  ${data['message']['conditions']}  stepCount  ${stepCount}


Заповнити bank.name
	${bankName}  create_sentence  5
	${selector}  Set Variable  //*[contains(text(),'Найменування банку')]/following-sibling::*//input
	small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${bankName}
	${bank}  Create Dictionary  bankName  ${bankName}
	Set To Dictionary  ${data['message']}  bank  ${bank}


Заповнити bank.Requisites.type
	${selector}  Set Variable  //*[contains(text(),'Тип реквізиту')]/../following-sibling::*
	${type}  Вибрати та повернути елемент з випадаючого списку  ${selector}  Номер рахунку
	${dict}  Create Dictionary  type  ${type}
	${Requisites}  Create Dictionary  type  ${type}
	Set To Dictionary  ${data['message']['bank']}  requisites  ${Requisites}


Заповнити bank.Requisites.value
	${value}  random_number  1000000  9999999
	${selector}  Set Variable  //*[contains(text(),'Значення')]/../following-sibling::*//input
	small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${value}
	Set To Dictionary  ${data['message']['bank']['requisites']}  value  ${value}


Заповнити bank.Requisites.description
	${description}  create_sentence  10
	${selector}  Set Variable  //*[contains(text(),'Опис')]/../following-sibling::*//input
	small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${description}
	Set To Dictionary  ${data['message']['bank']['requisites']}  description  ${description}


Натиснути передати на перевірку
	${send-to-verification btn}  Set Variable  //*[@data-qa='button-send-to-verification']
	Wait Until Element Is Visible  ${send-to-verification btn}
	Scroll Page To Element XPATH  ${send-to-verification btn}
	Click Element  ${send-to-verification btn}
    Дочекатись Закінчення Загрузки Сторінки


Отримати UAID для повідомлення
	Reload Page
    Дочекатись Закінчення Загрузки Сторінки
	${UAID}  Get Text  //*[@data-qa='cdbNumber']
	Run Keyword If  '${UAID}' == ''
	...  Отримати UAID для об'єкту
    Set To Dictionary  ${data['message']}  UAID  ${UAID}
