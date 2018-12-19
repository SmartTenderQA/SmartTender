*** Settings ***
Variables	dzk_variables.py
Library		dzk_common.py


*** Variables ***
${notice message}			//*[@class='ivu-notice-desc']

*** Keywords ***
###########################################################################
################################## STEPS ##################################
###########################################################################
Заповнити всі обов'язкові поля
	dzk_auction.Заповнити lotIdentifier
	dzk_auction.Заповнити title
	dzk_auction.Заповнити description
	dzk_auction.Заповнити lotHolder.identifier.legalName
	dzk_auction.Заповнити lotHolder.identifier.id
	dzk_auction.Заповнити lotHolder.address.postalCode
	dzk_auction.Заповнити lotHolder.address.locality
	dzk_auction.Заповнити lotHolder.address.streetAddress
	dzk_auction.Заповнити lotHolder.contactPoint.name
	dzk_auction.Заповнити lotHolder.contactPoint.email
	dzk_auction.Заповнити auctionPeriod.shouldStartAfter
	dzk_auction.Заповнити tenderAttempts
	dzk_auction.Заповнити minNumberOfQualifiedBids
	dzk_auction.Заповнити contractTerms.leaseTerms.years
	dzk_auction.Заповнити contractTerms.leaseTerms.months
	dzk_auction.Заповнити value.amount
	dzk_auction.Заповнити minimalStep.amount
	dzk_auction.Заповнити guarantee.amount
	dzk_auction.Заповнити budgetSpent.amount
	dzk_auction.Заповнити registrationFee.amount
	dzk_auction.Заповнити bankAccount.bankName
	dzk_auction.Заповнити bankAccount.accountIdentification.0.description
	dzk_auction.Заповнити bankAccount.accountIdentification.(num).id
	dzk_auction.Заповнити items.0.description
	dzk_auction.Заповнити items.0.additionalClassifications.1.id
	dzk_auction.Заповнити items.0.classification.description
	dzk_auction.Заповнити items.0.additionalClassifications.description
	dzk_auction.Заповнити items.0.quantity
	dzk_auction.Заповнити items.0.unit.name
	dzk_auction.Заповнити items.0.address.postalCode
	dzk_auction.Заповнити items.0.address.locality
	dzk_auction.Заповнити items.0.address.streetAddress


Перевірити всі обов'язкові поля в цбд
	dzk_auction.Перевірити дані в ЦБД для  ['auctionID']
	dzk_auction.Перевірити дані в ЦБД для  ['lotIdentifier']
	#todo hz 4to tut delat`
	#dzk_auction.Перевірити дані в ЦБД для  ['title']
	dzk_auction.Перевірити дані в ЦБД для  ['description']
	dzk_auction.Перевірити дані в ЦБД для  ['lotHolder']['identifier']['legalName']
	dzk_auction.Перевірити дані в ЦБД для  ['lotHolder']['identifier']['id']
	dzk_auction.Перевірити дані в ЦБД для  ['lotHolder']['address']['postalCode']
	dzk_auction.Перевірити дані в ЦБД для  ['lotHolder']['address']['region']
	dzk_auction.Перевірити дані в ЦБД для  ['lotHolder']['address']['locality']
	dzk_auction.Перевірити дані в ЦБД для  ['lotHolder']['address']['streetAddress']
	dzk_auction.Перевірити дані в ЦБД для  ['lotHolder']['contactPoint']['name']
	dzk_auction.Перевірити дані в ЦБД для  ['lotHolder']['contactPoint']['email']
	#todo hz 4e tut delat`
	#dzk_auction.Перевірити дані в ЦБД для  ['auctionPeriod']['shouldStartAfter']
	#todo v cbd idet ne to zna4eniie
	#dzk_auction.Перевірити дані в ЦБД для  ['tenderAttempts']
	dzk_auction.Перевірити дані в ЦБД для  ['minNumberOfQualifiedBids']
	dzk_auction.Перевірити дані в ЦБД для  ['contractTerms']['leaseTerms']['leaseDuration']
	dzk_auction.Перевірити дані в ЦБД для  ['value']['amount']
	dzk_auction.Перевірити дані в ЦБД для  ['minimalStep']['amount']
	dzk_auction.Перевірити дані в ЦБД для  ['guarantee']['amount']
	dzk_auction.Перевірити дані в ЦБД для  ['budgetSpent']['amount']
	dzk_auction.Перевірити дані в ЦБД для  ['registrationFee']['amount']
	dzk_auction.Перевірити дані в ЦБД для  ['bankAccount']['bankName']
	#todo hz 4to tut delat`
	#dzk_auction.Перевірити дані в ЦБД для  ['bankAccount']['accountIdentification'][0]['description']
	: FOR  ${i}  IN RANGE  0  9
    \  dzk_auction.Перевірити дані в ЦБД для  ['bankAccount']['accountIdentification'][${i}]['id']
	dzk_auction.Перевірити дані в ЦБД для  ['items'][0]['description']
	dzk_auction.Перевірити дані в ЦБД для  ['items'][0]['additionalClassifications'][1]['id']
	dzk_auction.Перевірити дані в ЦБД для  ['items'][0]['classification']['description']
	dzk_auction.Перевірити дані в ЦБД для  ['items'][0]['additionalClassifications'][0]['description']
	dzk_auction.Перевірити дані в ЦБД для  ['items'][0]['quantity']
	#todo hz 4to tut delat`
	#dzk_auction.Перевірити дані в ЦБД для  ['items'][0]['unit']['name']
	dzk_auction.Перевірити дані в ЦБД для  ['items'][0]['address']['postalCode']
	dzk_auction.Перевірити дані в ЦБД для  ['items'][0]['address']['locality']
	dzk_auction.Перевірити дані в ЦБД для  ['items'][0]['address']['streetAddress']


Перевірити відображення всіх обов'язкових полів на сторінці аукціону
	dzk_auction.Переірити відображення для  ['auctionID']
	dzk_auction.Переірити відображення для  ['lotIdentifier']
	dzk_auction.Переірити відображення для  ['title']
	dzk_auction.Переірити відображення для  ['description']
	dzk_auction.Переірити відображення для  ['lotHolder']['identifier']['legalName']
	dzk_auction.Переірити відображення для  ['lotHolder']['identifier']['id']
	dzk_auction.Переірити відображення для  ['lotHolder']['address']['postalCode']
	dzk_auction.Переірити відображення для  ['lotHolder']['address']['region']
	dzk_auction.Переірити відображення для  ['lotHolder']['address']['locality']
	dzk_auction.Переірити відображення для  ['lotHolder']['address']['streetAddress']
	dzk_auction.Переірити відображення для  ['lotHolder']['contactPoint']['name']
	dzk_auction.Переірити відображення для  ['lotHolder']['contactPoint']['email']
	dzk_auction.Переірити відображення для  ['auctionPeriod']['shouldStartAfter']
	#todo hz 4to tut delat`
	#dzk_auction.Переірити відображення для  ['tenderAttempts']
	#
	dzk_auction.Переірити відображення для  ['minNumberOfQualifiedBids']
	dzk_auction.Переірити відображення для  ['contractTerms']['leaseTerms']['years']
	dzk_auction.Переірити відображення для  ['contractTerms']['leaseTerms']['months']
	dzk_auction.Переірити відображення для  ['value']['amount']
	dzk_auction.Переірити відображення для  ['minimalStep']['amount']
	dzk_auction.Переірити відображення для  ['guarantee']['amount']
	dzk_auction.Переірити відображення для  ['budgetSpent']['amount']
	dzk_auction.Переірити відображення для  ['registrationFee']['amount']
	dzk_auction.Переірити відображення для  ['bankAccount']['bankName']
	dzk_auction.Переірити відображення для  ['bankAccount']['accountIdentification'][0]['description']
	: FOR  ${i}  IN RANGE  0  9
    \  dzk_auction.Переірити відображення для  ['bankAccount']['accountIdentification'][${i}]['id']
	dzk_auction.Переірити відображення для  ['items'][0]['description']
	dzk_auction.Переірити відображення для  ['items'][0]['additionalClassifications'][1]['id']
	dzk_auction.Переірити відображення для  ['items'][0]['classification']['id']
	dzk_auction.Переірити відображення для  ['items'][0]['classification']['description']
	dzk_auction.Переірити відображення для  ['items'][0]['additionalClassifications'][0]['id']
	dzk_auction.Переірити відображення для  ['items'][0]['additionalClassifications'][0]['description']
	dzk_auction.Переірити відображення для  ['items'][0]['quantity']
	#todo hz 4to tut delat`
	#dzk_auction.Переірити відображення для  ['items'][0]['unit']['name']
	dzk_auction.Переірити відображення для  ['items'][0]['address']['postalCode']
	dzk_auction.Переірити відображення для  ['items'][0]['address']['region']
	dzk_auction.Переірити відображення для  ['items'][0]['address']['locality']
	dzk_auction.Переірити відображення для  ['items'][0]['address']['streetAddress']






###########################################################################
################################# /STEPS ##################################
###########################################################################




###########################################################################
################################# COMMON ##################################
###########################################################################
Натиснути створити аукціон
	Wait Until Element Is Visible  //*[@data-qa='button-create-auction']  15
	Click Element  //*[@data-qa='button-create-auction']
	Дочекатись закінчення загрузки сторінки(skeleton)


Натиснути кнопку зберегти
	${save btn}  Set variable  //*[@data-qa='button-success']
    Scroll Page To Element XPATH  ${save btn}
    Click Element  ${save btn}
    Wait Until Page Contains Element  ${notice message}  15
    ${notice text}  Get Text  ${notice message}
	Should Contain  ${notice text}  Аукціон було успішно
	Wait Until Page Does Not Contain Element  ${notice message}


Опублікувати аукціон у реєстрі
	${publish btn}  Set Variable  //button[contains(.,'Опублікувати')]
	Wait Until Element Is Visible  ${publish btn}  10
   	Wait Until Element Is Not Visible  //*[@class='ivu-message']  10
	Scroll Page To Element XPATH  ${publish btn}
	Click Element  ${publish btn}
    Wait Until Element Is Visible  ${notice message}  15
    ${notice text}  Get Text  ${notice message}
	Should Be Equal  ${notice text}  Аукціон було успішно опубліковано
	Wait Until Page Does Not Contain Element  ${notice message}


Отримати UAID та href для Аукціону
	Reload Page
	${selector}  dzk_auction.Отримати локатор по назві поля  ['auctionID']
    Wait Until Element Is Visible  ${selector}  10
    Wait Until Element Is Not Visible  //*[@class='ivu-message']  10
	${UAID}  Get Text  ${selector}
	${correct status}  Run Keyword And Return Status  Перевірити коректність UAID для Аукціону  ${UAID}
	Run Keyword If  ${correct status} == ${False}  Отримати UAID для Аукціону
    Set To Dictionary  ${dzk_data}  auctionID  ${UAID}
    ${tender_href}  Get Location
    Set To Dictionary  ${dzk_data}  tender_href  ${tender_href}


Перевірити коректність UAID для Аукціону
	[Arguments]  ${UAID is}
	${date now}  Evaluate  '{:%Y-%m-%d}'.format(datetime.datetime.now())  datetime
	${UAID should}  Set Variable  UA-PS-${date now}
	Should Contain  ${UAID is}  ${UAID should}


Отримати ID у цбд
    ${cdb locator}  Set Variable  //*[text()='Перейти']
    ${cdb href}  Get Element Attribute  ${cdb locator}  href
    ${cdb id}  Evaluate  (re.findall(r'[a-z0-9]{32}','${cdb href}'))[0]  re
    Set To Dictionary  ${dzk_data}  id  ${cdb id}
###########################################################################
################################# /COMMON #################################
###########################################################################




###########################################################################
############################ WORK WITH FIELD ##############################
###########################################################################
Вибрати та повернути випадковий елемент з випадаючого списку
    [Arguments]  ${selector}
  	${items}  Set Variable  ${selector}//ul[@class='ivu-select-dropdown-list']//li
	Scroll Page To Element XPATH  ${selector}
    Click Element  ${selector}
    Sleep  .5
    Wait Until Element Is Visible  ${items}
    ${items count}  Get Element Count  ${items}
	${items number}  random_number  1  ${items count}
	${item name}  Get Text  (${items})[${items number}]
    Click Element  (${items})[${items number}]
   	Should Not Be Empty  ${item name}
    [Return]  ${item name}


Розгорнути всі списки
	[Arguments]  ${modal locator}
	${closed li}  Set Variable  ${modal locator}//li[contains(@class,'jstree-closed')]
	: FOR  ${i}  IN RANGE  99999
	\  ${closed li num}  Get Element Count  xpath=${closed li}
	\  Exit For Loop If    ${closed li num} == 0
    \  ${a}  Set Variable  ${closed li}/a
    \  Click Element  xpath=${a}
    \  Sleep  .5


Вибрати та повернути випадковий елемент з класифікації
    [Arguments]  ${selector}
    Click Element  //a${selector}
    ${modal locator}  Set Variable  //div${selector}
	Wait Until Element Is Visible  ${modal locator}
	Sleep  .5
	Розгорнути всі списки  ${modal locator}
	${items}  Set Variable  ${modal locator}//li[contains(@class,'jstree-leaf')]/a
	${items count}  Get Element Count  xpath=${items}
	${random item}  random_number  1  ${items count}
	${item}  Set Variable  xpath=(${items})[${random item}]
	Click Element  ${item}
	${value}  Get Text  ${item}
	Sleep  .5
	Click Element  ${modal locator}//button
	Sleep  1
	[Return]  ${value}


Вибрати та повернути елемент з класифікації за назвою
    [Arguments]  ${selector}  ${text}
    Click Element  //a${selector}
    ${modal locator}  Set Variable  //div${selector}
	Wait Until Element Is Visible  ${modal locator}
	Sleep  .5
	${input}  Set Variable  ${modal locator}//input
	Input Text  ${input}  ${text}
	Sleep  1.5
	${item}  Set Variable  ${modal locator}//a[contains(text(),'${text}')]
	Click Element  ${item}
	${value}  Get Text  ${item}
	Sleep  .5
	Click Element  ${modal locator}//button
	Sleep  1
	[Return]  ${value}
###########################################################################
########################### /WORK WITH FIELD ##############################
###########################################################################




###########################################################################
############################## INPUT FIELD ################################
###########################################################################
Заповнити lotIdentifier
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['lotIdentifier']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити title
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['title']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити description
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['description']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити lotHolder.identifier.legalName
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['lotHolder']['identifier']['legalName']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити lotHolder.identifier.id
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['lotHolder']['identifier']['id']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити lotHolder.address.postalCode
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['lotHolder']['address']['postalCode']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити lotHolder.address.locality
	${selector}  dzk_auction.Отримати локатор по назві поля  ['lotHolder']['address']['locality']
    ${locality}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути випадковий елемент з випадаючого списку  ${text}
	[Return]  ${locality}


Заповнити lotHolder.address.streetAddress
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['lotHolder']['address']['streetAddress']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити lotHolder.contactPoint.name
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['lotHolder']['contactPoint']['name']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити lotHolder.contactPoint.email
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['lotHolder']['contactPoint']['email']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити auctionPeriod.shouldStartAfter
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['auctionPeriod']['shouldStartAfter']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}
	Click Element  ${selector}/ancestor::*[contains(@class,'item-content')]
	Sleep  .5


Заповнити tenderAttempts
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['tenderAttempts']
    ${tenderAttempts}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути випадковий елемент з випадаючого списку  ${text}
	[Return]  ${tenderAttempts}



Заповнити minNumberOfQualifiedBids
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['minNumberOfQualifiedBids']
    ${minNumberOfQualifiedBids}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути випадковий елемент з випадаючого списку  ${selector}
	[Return]  ${minNumberOfQualifiedBids}


Заповнити contractTerms.leaseTerms.years
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['contractTerms']['leaseTerms']['years']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити contractTerms.leaseTerms.months
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['contractTerms']['leaseTerms']['months']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити value.amount
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['value']['amount']
	small_privatization.Заповнити та перевірити поле з вартістю  ${selector}  ${text}


Заповнити minimalStep.amount
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['minimalStep']['amount']
	small_privatization.Заповнити та перевірити поле з вартістю  ${selector}  ${text}


Заповнити guarantee.amount
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['guarantee']['amount']
	small_privatization.Заповнити та перевірити поле з вартістю  ${selector}  ${text}


Заповнити budgetSpent.amount
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['budgetSpent']['amount']
	small_privatization.Заповнити та перевірити поле з вартістю  ${selector}  ${text}


Заповнити registrationFee.amount
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['registrationFee']['amount']
	small_privatization.Заповнити та перевірити поле з вартістю  ${selector}  ${text}


Заповнити bankAccount.bankName
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['bankAccount']['bankName']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити bankAccount.accountIdentification.0.description
	[Arguments]  ${text}
	${description}  create_sentence  3
	${selector}  dzk_auction.Отримати локатор по назві поля  ['bankAccount']['accountIdentification'][0]['description']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}
	Set To Dictionary  ${dzk_data['bankAccount']['accountIdentification'][0]}  description  ${description}


Заповнити bankAccount.accountIdentification.(num).id
	[Arguments]  ${text}
	: FOR  ${i}  IN RANGE  0  9
    \  ${id}  Generate Random String  10  [LETTERS][NUMBERS]
    \  ${selector}  dzk_auction.Отримати локатор по назві поля  ['bankAccount']['accountIdentification'][${i}]['id']
    \  Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}
    \  Set To Dictionary  ${dzk_data['bankAccount']['accountIdentification'][${i}]}  id  ${id}


Заповнити items.0.description
	[Arguments]  ${text}
	${description}  create_sentence  20
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['description']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}
	Set To Dictionary  ${dzk_data['items'][0]}  description  ${description}


Заповнити items.0.additionalClassifications.1.id
	[Arguments]  ${text}
	${cadastralNumber}  random_number  1000000000000000000  9999999999999999999
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['additionalClassifications'][1]['id']
	Input Text  ${selector}  ${cadastralNumber}
	${cadastralNumber}  Get Element Attribute  ${selector}  value
	Set To Dictionary  ${dzk_data['items'][0]['additionalClassifications'][1]}  id  ${cadastralNumber}


Заповнити items.0.classification.description
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['classification']['description']
	${description}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути випадковий елемент з класифікації  ${text}
	${id}  Evaluate  (re.findall(r'[0-9]*[-][0-9]*', "${description}"))[0]  re
	Set To Dictionary  ${dzk_data['items'][0]['classification']}  id  ${id}
	${description}  Evaluate  re.sub(r'[0-9]*[-][0-9]*.', '', "${description}", 1)  re
	Set To Dictionary  ${dzk_data['items'][0]['classification']}  description  ${description}


Заповнити items.0.additionalClassifications.description
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['additionalClassifications'][0]['description']
	${description}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути випадковий елемент з класифікації  ${text}
	${id}  Evaluate  ((re.findall(r'[0-9]*[.][0-9]*', "${description}"))[0])  re
	Set To Dictionary  ${dzk_data['items'][0]['additionalClassifications'][0]}  id  ${id}
	${description}  Evaluate  re.sub(r'[0-9]*[.][0-9]*.', '', "${description}", 1)  re
	Set To Dictionary  ${dzk_data['items'][0]['additionalClassifications'][0]}  description  ${description}


Заповнити items.0.quantity
	[Arguments]  ${text}
	${first}  random_number  1  1000
	${second}  random_number  1  100
    ${quantity}  Evaluate  str(round(float(${first})/float(${second}), 3))
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['quantity']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}
	Set To Dictionary  ${dzk_data['items'][0]}  quantity  ${quantity}


Заповнити items.0.unit.name
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['unit']['name']
    ${name}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути випадковий елемент з випадаючого списку  ${text}
	Set To Dictionary  ${dzk_data['items'][0]['unit']}  name  ${name}


Заповнити items.0.address.postalCode
	[Arguments]  ${text}
	${postalCode}  random_number  10000  99999
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['address']['postalCode']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}
	Set To Dictionary  ${dzk_data['items'][0]['address']}  postalCode  ${postalCode}


Заповнити items.0.address.locality
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['address']['locality']
    ${locality}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути випадковий елемент з випадаючого списку  ${text}
	${region}  Evaluate  (re.findall(r'[А-я][^(]+[.]','${locality}'))[0]  re
	Set To Dictionary  ${dzk_data['items'][0]['address']}  region  ${region}
	${locality}  Evaluate  re.sub(r'.[(].*','','${locality}')  re
	Set To Dictionary  ${dzk_data['items'][0]['address']}  locality  ${locality}


Заповнити items.0.address.streetAddress
	[Arguments]  ${text}
	${streetAddress}  get_some_uuid
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['address']['streetAddress']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}
	Set To Dictionary  ${dzk_data['items'][0]['address']}  streetAddress  ${streetAddress}
###########################################################################
############################# /INPUT FIELD ################################
###########################################################################




###########################################################################
################################## CHECK ##################################
###########################################################################
Отримати локатор по назві поля
	[Arguments]  ${field}
	${selector}  Set Variable  ${dzk_edit_locators${field}}
	[Return]  ${selector}


Отритами дані зі сторінки
 	[Arguments]  ${field}
 	${selector}  Set Variable  ${dzk_view_locators${field}}
 	Wait Until Element Is Visible  ${selector}  10
 	${value}  Get Text  ${selector}
 	${field value}  get_page_values  ${field}  ${value}
 	[Return]  ${field value}


Переірити відображення для
 	[Arguments]  ${field}
 	${value should}  Set Variable  ${dzk_data${field}}
 	${value is}  dzk_auction.Отритами дані зі сторінки  ${field}
	Should Be Equal  ${value is}  ${value should}


Перевірити дані в ЦБД для
	[Arguments]  ${field}
	${value should}  Set Variable  ${cdb_data${field}}
	${value is}  Set Variable  ${dzk_data${field}}
	Порівняти дані  ${value is}  ${value should}


Порівняти дані
	[Arguments]  ${is}  ${should}
	${is equal}  compare_values  ${is}  ${should}
	Run Keyword If  ${is equal} == ${False}
	...  Fail  Oops, перепуталися дані!!!{${should} != ${is}}

###########################################################################
################################# /CHECK ##################################
###########################################################################