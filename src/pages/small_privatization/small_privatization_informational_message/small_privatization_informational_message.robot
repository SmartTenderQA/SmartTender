*** Settings ***


*** Variables ***
${auction locator}			(//a[contains(text(),'Перейти до аукціону')])



*** Keywords ***
Перевірити всі обов'язкові поля в цбд
	compare_data.Порівняти введені дані з даними в ЦБД  ['decisions'][0]['decisionID']
	compare_data.Порівняти введені дані з даними в ЦБД  ['decisions'][0]['decisionDate']  m
	compare_data.Порівняти введені дані з даними в ЦБД  ['auctions'][0]['auctionPeriod']['startDate']  s
	:FOR  ${i}  IN RANGE  1  3
	\  compare_data.Порівняти введені дані з даними в ЦБД  ['auctions'][${i}]['tenderingDuration']
	compare_data.Порівняти введені дані з даними в ЦБД  ['auctions'][0]['value']['amount']
	compare_data.Порівняти введені дані з даними в ЦБД  ['auctions'][0]['minimalStep']['amount']
	compare_data.Порівняти введені дані з даними в ЦБД  ['auctions'][0]['guarantee']['amount']
	compare_data.Порівняти введені дані з даними в ЦБД  ['auctions'][0]['registrationFee']['amount']
	compare_data.Порівняти введені дані з даними в ЦБД  ['auctions'][2]['auctionParameters']['dutchSteps']
	:FOR  ${i}  IN RANGE  0  3
	\  compare_data.Порівняти введені дані з даними в ЦБД  ['auctions'][${i}]['bankAccount']['bankName']
	\  compare_data.Порівняти введені дані з даними в ЦБД  ['auctions'][${i}]['bankAccount']['accountIdentification'][0]['scheme']
	\  compare_data.Порівняти введені дані з даними в ЦБД  ['auctions'][${i}]['bankAccount']['accountIdentification'][0]['id']
	\  compare_data.Порівняти введені дані з даними в ЦБД  ['auctions'][${i}]['bankAccount']['accountIdentification'][0]['description']


Перевірити відображення всіх обов'язкових полів на сторінці аукціону
	compare_data.Порівняти відображені дані з даними в ЦБД  ['lotID']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['title']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['description']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['decisions'][0]['decisionID']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['decisions'][0]['decisionDate']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['decisions'][1]['title']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['decisions'][1]['decisionID']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['decisions'][1]['decisionDate']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['auctions'][0]['auctionPeriod']['startDate']
	:FOR  ${i}  IN RANGE  0  3
	\  compare_data.Порівняти відображені дані з даними в ЦБД  ['auctions'][${i}]['value']['amount']
	\  compare_data.Порівняти відображені дані з даними в ЦБД  ['auctions'][${i}]['value']['valueAddedTaxIncluded']
	\  compare_data.Порівняти відображені дані з даними в ЦБД  ['auctions'][${i}]['guarantee']['amount']
	\  compare_data.Порівняти відображені дані з даними в ЦБД  ['auctions'][${i}]['registrationFee']['amount']
	:FOR  ${i}  IN RANGE  0  2
	\  compare_data.Порівняти відображені дані з даними в ЦБД  ['auctions'][${i}]['minimalStep']['amount']
	\  compare_data.Порівняти відображені дані з даними в ЦБД  ['auctions'][${i}]['minimalStep']['valueAddedTaxIncluded']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['auctions'][2]['auctionParameters']['dutchSteps']
	:FOR  ${i}  IN RANGE  0  3
	\  compare_data.Порівняти відображені дані з даними в ЦБД  ['auctions'][${i}]['bankAccount']['bankName']
	\  compare_data.Порівняти відображені дані з даними в ЦБД  ['auctions'][${i}]['bankAccount']['accountIdentification'][0]['id']
	\  compare_data.Порівняти відображені дані з даними в ЦБД  ['auctions'][${i}]['bankAccount']['accountIdentification'][0]['scheme']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['lotCustodian']['identifier']['legalName']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['lotCustodian']['identifier']['id']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['lotCustodian']['identifier']['scheme']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['lotCustodian']['contactPoint']['name']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['lotCustodian']['contactPoint']['telephone']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['lotCustodian']['contactPoint']['email']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['description']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['classification']['description']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['classification']['id']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['classification']['scheme']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['quantity']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['unit']['name']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['address']['postalCode']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['address']['countryName']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['address']['region']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['address']['locality']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['address']['streetAddress']


Зберегти чернетку інформаційного повідомлення
	${save btn}  Set variable  //div[@class='ivu-col ivu-col-span-6']//button[@type='button']
    Scroll Page To Element XPATH  ${save btn}
    Click Element  ${save btn}
    Wait Until Element Is Visible  ${notice message}  15
    ${notice text}  Get Text  ${notice message}
	Should Contain  ${notice text}  було
	Wait Until Element Is Not Visible  ${notice message}


Опублікувати інформаційне повідомлення у реєстрі
	${publish btn}  Set Variable  //*[@data-qa='button-publish-information-message']
	Wait Until Element Is Visible  ${publish btn}  10
   	Wait Until Element Is Not Visible  //*[@class='ivu-message']  10
	Scroll Page To Element XPATH  ${publish btn}
	Click Element  ${publish btn}
	Wait Until Element Is Visible  ${notice message}  15
    ${notice text}  Get Text  ${notice message}
	Should Contain  ${notice text}  було опубліковано
	Wait Until Element Is Not Visible  ${notice message}


Ввести унікальний код об'єкту
	[Arguments]  ${text}
	${selector}  small_privatization.Отримати локатор по назві поля  ['assetID']
    Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити decisions.0.decisionID
	[Arguments]  ${text}
	${selector}  small_privatization.Отримати локатор по назві поля  ['decisions'][0]['decisionID']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити decisions.0.decisionDate
	[Arguments]  ${text}
	${selector}  small_privatization.Отримати локатор по назві поля  ['decisions'][0]['decisionDate']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Прикріпити документ
	${selector}  Set Variable  //div[@class='ivu-card-body']/div[@class='margin-bottom-20']
	${doc}  Створити та додати файл  ${selector}//input
	Element Should Contain  ${selector}  ${doc[1]}
	Set To Dictionary  ${data['message']}  document-name  ${doc[1]}


Перейти до Коригування інформації
	${edit btn}  Set Variable  //*[@data-qa='button-to-edit-page']
   	Wait Until Element Is Visible  ${edit btn}
   	Wait Until Page Does Not Contain Element  //*[@class='ivu-message']  10
    Scroll Page To Element XPATH  ${edit btn}
	Click Element  ${edit btn}
    Дочекатись Закінчення Загрузки Сторінки


Заповнити auctions.0.auctionPeriod.startDate
	[Arguments]  ${text}
	${selector}  small_privatization.Отримати локатор по назві поля  ['auctions'][0]['auctionPeriod']['startDate']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}
	Click Element  //*[contains(text(),'Дата проведення аукціону')]
	Sleep  .5


Заповнити auctions.1.tenderingDuration
	[Arguments]  ${text}
	${selector}  small_privatization.Отримати локатор по назві поля  ['auctions'][1]['tenderingDuration']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити auctions.0.value.amount
	[Arguments]  ${text}
	${selector}  small_privatization.Отримати локатор по назві поля  ['auctions'][0]['value']['amount']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити поле з вартістю  ${selector}  ${text}


Заповнити auctions.0.minimalStep.amount
	[Arguments]  ${text}
	${selector}  small_privatization.Отримати локатор по назві поля  ['auctions'][0]['minimalStep']['amount']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити поле з вартістю  ${selector}  ${text}


Заповнити auctions.0.guarantee.amount
	[Arguments]  ${text}
	${selector}  small_privatization.Отримати локатор по назві поля  ['auctions'][0]['guarantee']['amount']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити поле з вартістю  ${selector}  ${text}


Заповнити auctions.0.registrationFee.amount
	[Arguments]  ${text}
	${selector}  small_privatization.Отримати локатор по назві поля  ['auctions'][0]['registrationFee']['amount']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити поле з вартістю  ${selector}  ${text}


Заповнити auctions.1.auctionParameters.dutchSteps
	[Arguments]  ${text}
	${selector}  small_privatization.Отримати локатор по назві поля  ['auctions'][1]['auctionParameters']['dutchSteps']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити auctions.0.bankAccount.bankName
	[Arguments]  ${text}
	${selector}  small_privatization.Отримати локатор по назві поля  ['auctions'][0]['bankAccount']['bankName']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити auctions.0.bankAccount.accountIdentification.0.scheme
	${selector}  small_privatization.Отримати локатор по назві поля  ['auctions'][0]['bankAccount']['accountIdentification'][0]['scheme']
	${type}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути елемент з випадаючого списку  ${selector}
	[Return]  ${type}


Заповнити auctions.0.bankAccount.accountIdentification.0.id
	[Arguments]  ${text}
	${selector}  small_privatization.Отримати локатор по назві поля  ['auctions'][0]['bankAccount']['accountIdentification'][0]['id']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити auctions.0.bankAccount.accountIdentification.0.description
	[Arguments]  ${text}
	${selector}  small_privatization.Отримати локатор по назві поля  ['auctions'][0]['bankAccount']['accountIdentification'][0]['description']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Передати на перевірку інформаційне повідомлення
	${send-to-verification btn}  Set Variable  //*[@data-qa='button-send-to-verification']
	Wait Until Element Is Visible  ${send-to-verification btn}  10
   	Wait Until Element Is Not Visible  //*[@class='ivu-message']  10
	Scroll Page To Element XPATH  ${send-to-verification btn}
	Click Element  ${send-to-verification btn}
    Wait Until Element Is Visible  ${notice message}  15
    ${notice text}  Get Text  ${notice message}
	Should Contain  ${notice text}  було передано на перевірку
	Wait Until Element Is Not Visible  ${notice message}


Дочекатися опублікування посилання на лот
	[Arguments]  ${time}
	Wait Until Keyword Succeeds  ${time}  30 sec  Run Keywords
    ...  Reload Page  												AND
    ...  Дочекатись закінчення загрузки сторінки(skeleton)  		AND
    ...  Page Should Contain Element  ${auction locator}[1]


Перейти до аукціону
	Scroll Page To Element XPATH  ${auction locator}[1]
	Click Element  ${auction locator}[1]
	Дочекатись Закінчення Загрузки Сторінки


Отримати UAID для Повідомлення
	Wait Until Element Is Visible  //*[@data-qa='cdbNumber']  10
	Wait Until Element Is Not Visible  //*[@class='ivu-message']  10
	${UAID}  Get Text  //*[@data-qa='cdbNumber']
	${correct status}  Run Keyword And Return Status  Перевірити коректність UAID для Повідомлення  ${UAID}
	Run Keyword If  ${correct status} == ${False}  Отримати UAID для Повідомлення
    Set To Dictionary  ${data['message']}  UAID  ${UAID}


Перевірити коректність UAID для Повідомлення
	[Arguments]  ${UAID is}
	${date now}  Evaluate  '{:%Y-%m-%d}'.format(datetime.datetime.now())  modules=datetime
	${UAID should}  Set Variable  UA-LR-SSP-${date now}
	Should Contain  ${UAID is}  ${UAID should}


Дочекатися статусу повідомлення
	[Arguments]  ${message status}  ${time}
    Wait Until Keyword Succeeds  ${time}  30 sec  Run Keywords
    ...  Reload Page  												AND
    ...  Дочекатись закінчення загрузки сторінки(skeleton)  		AND
    ...  Статус повідомлення повинен бути  ${message status}


Статус повідомлення повинен бути
	[Arguments]  ${message status should}
	${message status is}  Отримати статус повідомлення
	Should Be Equal  ${message status should}  ${message status is}


Отримати статус повідомлення
	${message status locator}  Set Variable  //h4[contains(@class,'action-block-item')]
	${message status is}  Get Text  ${message status locator}
	[Return]  ${message status is}