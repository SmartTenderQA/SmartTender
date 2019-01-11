*** Settings ***


*** Variables ***
${notice message}			//*[@class='ivu-notice-desc']

*** Keywords ***
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
    Wait Until Element Is Visible  ${notice message}  30
    ${notice text}  Get Text  ${notice message}
	Should Be Equal  ${notice text}  Аукціон було успішно опубліковано
	Wait Until Page Does Not Contain Element  ${notice message}


Отримати UAID та href для Аукціону
	Reload Page
	${selector}  Set Variable  ${view_locators['auctionID']}
    Wait Until Element Is Visible  ${selector}  10
    Wait Until Element Is Not Visible  //*[@class='ivu-message']  10
	${UAID}  Get Text  ${selector}
	${correct status}  Run Keyword And Return Status  Перевірити коректність UAID для Аукціону  ${UAID}
	Run Keyword If  ${correct status} == ${False}  Отримати UAID для Аукціону
    Set To Dictionary  ${data}  auctionID  ${UAID}
    ${tender_href}  Get Location
    Set To Dictionary  ${data}  tender_href  ${tender_href}


Перевірити коректність UAID для Аукціону
	[Arguments]  ${UAID is}
	${date now}  Evaluate  '{:%Y-%m-%d}'.format(datetime.datetime.now())  datetime
	${UAID should}  Set Variable  UA-PS-${date now}
	Should Contain  ${UAID is}  ${UAID should}


Отримати ID у цбд
    ${cdb locator}  Set Variable  //*[text()='Перейти']
    Wait Until Element Is Visible  ${cdb locator}  120
    ${cdb href}  Get Element Attribute  ${cdb locator}  href
    ${cdb id}  Evaluate  (re.findall(r'[a-z0-9]{32}','${cdb href}'))[0]  re
    Set To Dictionary  ${data}  id  ${cdb id}
###########################################################################
################################# /COMMON #################################
###########################################################################


#########################################################region#########################################################
#                                                    Заповнити поля                                                    #
########################################################################################################################
Заповнити lotIdentifier
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['lotIdentifier']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити title
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['title']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити description
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['description']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити lotHolder.identifier.legalName
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['lotHolder']['identifier']['legalName']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити lotHolder.identifier.id
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['lotHolder']['identifier']['id']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити lotHolder.address.postalCode
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['lotHolder']['address']['postalCode']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити lotHolder.address.locality
	${selector}  sale_keywords.Отримати локатор по назві поля  ['lotHolder']['address']['locality']
    ${locality}  Wait Until Keyword Succeeds  30  3  sale_keywords.Вибрати та повернути елемент з випадаючого списку  ${selector}
	[Return]  ${locality}


Заповнити lotHolder.address.streetAddress
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['lotHolder']['address']['streetAddress']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити lotHolder.contactPoint.name
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['lotHolder']['contactPoint']['name']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити lotHolder.contactPoint.email
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['lotHolder']['contactPoint']['email']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити auctionPeriod.shouldStartAfter
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['auctionPeriod']['startDate']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}
	Click Element  ${selector}/ancestor::*[contains(@class,'item-content')]
	Sleep  .5


Заповнити tenderAttempts
	${selector}  sale_keywords.Отримати локатор по назві поля  ['tenderAttempts']
    ${tenderAttempts}  Wait Until Keyword Succeeds  30  3  sale_keywords.Вибрати та повернути елемент з випадаючого списку  ${selector}
	[Return]  ${tenderAttempts}


Заповнити minNumberOfQualifiedBids
	${selector}  sale_keywords.Отримати локатор по назві поля  ['minNumberOfQualifiedBids']
    ${minNumberOfQualifiedBids}  Wait Until Keyword Succeeds  30  3  sale_keywords.Вибрати та повернути елемент з випадаючого списку  ${selector}
	[Return]  ${minNumberOfQualifiedBids}


Заповнити contractTerms.leaseTerms.years
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['contractTerms']['leaseTerms']['years']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити contractTerms.leaseTerms.months
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['contractTerms']['leaseTerms']['months']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити value.amount
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['value']['amount']
	sale_keywords.Заповнити та перевірити поле з вартістю  ${selector}  ${text}


Заповнити minimalStep.amount
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['minimalStep']['amount']
	sale_keywords.Заповнити та перевірити поле з вартістю  ${selector}  ${text}


Заповнити guarantee.amount
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['guarantee']['amount']
	sale_keywords.Заповнити та перевірити поле з вартістю  ${selector}  ${text}


Заповнити budgetSpent.amount
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['budgetSpent']['amount']
	sale_keywords.Заповнити та перевірити поле з вартістю  ${selector}  ${text}


Заповнити registrationFee.amount
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['registrationFee']['amount']
	sale_keywords.Заповнити та перевірити поле з вартістю  ${selector}  ${text}


Заповнити bankAccount.bankName
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['bankAccount']['bankName']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити bankAccount.accountIdentification.0.description
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['bankAccount']['accountIdentification'][0]['description']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити bankAccount.accountIdentification.(num).id
	[Arguments]  ${text}  ${i}
    ${selector}  sale_keywords.Отримати локатор по назві поля  ['bankAccount']['accountIdentification'][${i}]['id']
    Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити items.0.description
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['items'][0]['description']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити items.0.additionalClassifications.1.id
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['items'][0]['additionalClassifications'][1]['id']
	Input Text  ${selector}  ${text}
	${cadastralNumber}  Get Element Attribute  ${selector}  value
	[Return]  ${cadastralNumber}


Заповнити items.0.classification.description
	${selector}  sale_keywords.Отримати локатор по назві поля  ['items'][0]['classification']['description']
	${description}  Wait Until Keyword Succeeds  30  3  sale_keywords.Вибрати та повернути випадковий елемент з класифікації  ${selector}
	[Return]  ${description}


Заповнити items.0.additionalClassifications.description
	${selector}  sale_keywords.Отримати локатор по назві поля  ['items'][0]['additionalClassifications'][0]['description']
	${description}  Wait Until Keyword Succeeds  30  3  sale_keywords.Вибрати та повернути випадковий елемент з класифікації  ${selector}
	[Return]  ${description}


Заповнити items.0.quantity
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['items'][0]['quantity']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити items.0.unit.name
	${selector}  sale_keywords.Отримати локатор по назві поля  ['items'][0]['unit']['name']
    ${name}  Wait Until Keyword Succeeds  30  3  sale_keywords.Вибрати та повернути елемент з випадаючого списку  ${selector}
	[Return]  ${name}


Заповнити items.0.address.postalCode
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['items'][0]['address']['postalCode']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити items.0.address.locality
	${selector}  sale_keywords.Отримати локатор по назві поля  ['items'][0]['address']['locality']
    ${locality}  Wait Until Keyword Succeeds  30  3  sale_keywords.Вибрати та повернути елемент з випадаючого списку  ${selector}
	[Return]  ${locality}


Заповнити items.0.address.streetAddress
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['items'][0]['address']['streetAddress']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}
#######################################################end-region#######################################################
#                                                    Заповнити поля                                                    #
########################################################################################################################