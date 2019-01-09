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


Розгорнути детальну інформацію по всіх полях (за необхідністю)
	${read more btn}  Set Variable  //*[contains(@class,'second')]//a[not(@href) and contains(text(),'Детальніше')]
	${is contain}  Run Keyword And Return Status  Page Should Contain Element  {read more btn}
	Run Keyword If  ${is contain} == ${True}  Run Keywords
	...  Click Element  {read more btn}
	...  AND  Sleep  .5
	...  AND  Розгорнути детальну інформацію по всіх полях (за необхідністю)


###########################################################################
################################# /COMMON #################################
###########################################################################




###########################################################################
############################ WORK WITH FIELD ##############################
###########################################################################
Вибрати та повернути елемент з випадаючого списку
    [Arguments]  ${selector}  ${text}=''
  	${items}  Set Variable  ${selector}//ul[@class='ivu-select-dropdown-list']//li
	Scroll Page To Element XPATH  ${selector}
    Click Element  ${selector}
    Sleep  .5
    Run Keyword If  "${text}" != "''"  Run Keywords
    ...  Run Keyword And Ignore Error  Input Text  ${selector}//input[@type='text']  ${text}
    ...  AND  Sleep  1.5
    Wait Until Element Is Visible  ${items}
    ${items count}  Get Element Count  ${items}
	${items number}  random_number  1  ${items count}
	${item name}  Get Text  (${items})[${items number}]
    Click Element  (${items})[${items number}]
    Sleep  .5
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
	Sleep  1.5
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




#########################################################region#########################################################
#                                                    Заповнити поля                                                    #
########################################################################################################################
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
    ${locality}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути елемент з випадаючого списку  ${selector}
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
	${selector}  dzk_auction.Отримати локатор по назві поля  ['auctionPeriod']['startDate']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}
	Click Element  ${selector}/ancestor::*[contains(@class,'item-content')]
	Sleep  .5


Заповнити tenderAttempts
	${selector}  dzk_auction.Отримати локатор по назві поля  ['tenderAttempts']
    ${tenderAttempts}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути елемент з випадаючого списку  ${selector}
	[Return]  ${tenderAttempts}


Заповнити minNumberOfQualifiedBids
	${selector}  dzk_auction.Отримати локатор по назві поля  ['minNumberOfQualifiedBids']
    ${minNumberOfQualifiedBids}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути елемент з випадаючого списку  ${selector}
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
	${selector}  dzk_auction.Отримати локатор по назві поля  ['bankAccount']['accountIdentification'][0]['description']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити bankAccount.accountIdentification.(num).id
	[Arguments]  ${text}  ${i}
    ${selector}  dzk_auction.Отримати локатор по назві поля  ['bankAccount']['accountIdentification'][${i}]['id']
    Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити items.0.description
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['description']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити items.0.additionalClassifications.1.id
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['additionalClassifications'][1]['id']
	Input Text  ${selector}  ${text}
	${cadastralNumber}  Get Element Attribute  ${selector}  value
	[Return]  ${cadastralNumber}


Заповнити items.0.classification.description
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['classification']['description']
	${description}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути випадковий елемент з класифікації  ${selector}
	[Return]  ${description}


Заповнити items.0.additionalClassifications.description
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['additionalClassifications'][0]['description']
	${description}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути випадковий елемент з класифікації  ${selector}
	[Return]  ${description}


Заповнити items.0.quantity
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['quantity']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити items.0.unit.name
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['unit']['name']
    ${name}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути елемент з випадаючого списку  ${selector}
	[Return]  ${name}


Заповнити items.0.address.postalCode
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['address']['postalCode']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити items.0.address.locality
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['address']['locality']
    ${locality}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути елемент з випадаючого списку  ${selector}
	[Return]  ${locality}


Заповнити items.0.address.streetAddress
	[Arguments]  ${text}
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['address']['streetAddress']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}
#######################################################end-region#######################################################
#                                                    Заповнити поля                                                    #
########################################################################################################################



Отримати локатор по назві поля
	[Arguments]  ${field}
	${selector}  Set Variable  ${edit_locators${field}}
	[Return]  ${selector}