*** Settings ***
Variables  dzk_variables.py


*** Variables ***


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
	debug
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
	Перевірити дані в ЦБД для  ['auctionID']
	Перевірити дані в ЦБД для  ['lotIdentifier']
	Перевірити дані в ЦБД для  ['title']
	Перевірити дані в ЦБД для  ['description']
	Перевірити дані в ЦБД для  ['lotHolder']['identifier']['legalName']
	Перевірити дані в ЦБД для  ['lotHolder']['identifier']['id']
	Перевірити дані в ЦБД для  ['lotHolder']['address']['postalCode']
	Перевірити дані в ЦБД для  ['lotHolder']['address']['region']
	Перевірити дані в ЦБД для  ['lotHolder']['address']['locality']
	Перевірити дані в ЦБД для  ['lotHolder']['address']['streetAddress']
	Перевірити дані в ЦБД для  ['lotHolder']['contactPoint']['name']
	Перевірити дані в ЦБД для  ['lotHolder']['contactPoint']['email']
	#todo proverit` date
	Перевірити дані в ЦБД для  ['auctionPeriod']['shouldStartAfter'] #todo need cast date
	Перевірити дані в ЦБД для  ['tenderAttempts']
	Перевірити дані в ЦБД для  ['minNumberOfQualifiedBids']
	#todo proverit` leaseDuration
	Перевірити дані в ЦБД для  ['contractTerms']['leaseTerms']['leaseDuration']
	Перевірити дані в ЦБД для  ['value']['amount']
	Перевірити дані в ЦБД для  ['minimalStep']['amount']
	Перевірити дані в ЦБД для  ['guarantee']['amount']
	Перевірити дані в ЦБД для  ['budgetSpent']['amount']
	Перевірити дані в ЦБД для  ['registrationFee']['amount']
	Перевірити дані в ЦБД для  ['bankAccount']['bankName']
	#todo proverit` kostil
	Перевірити дані в ЦБД для  ['bankAccount']['accountIdentification'][0]['description']
	: FOR  ${i}  IN RANGE  0  9
    \  Перевірити дані в ЦБД для  ['bankAccount']['accountIdentification'][${i}]['id']
	Перевірити дані в ЦБД для  ['items'][0]['description']
	Перевірити дані в ЦБД для  ['items'][0]['additionalClassifications'][1]['id']
	Перевірити дані в ЦБД для  ['items'][0]['classification']['description']
	Перевірити дані в ЦБД для  ['items'][0]['additionalClassifications'][0]['description']
	Перевірити дані в ЦБД для  ['items'][0]['quantity']
	Перевірити дані в ЦБД для  ['items'][0]['unit']['name']
	Перевірити дані в ЦБД для  ['items'][0]['address']['postalCode']
	Перевірити дані в ЦБД для  ['items'][0]['address']['locality']
	Перевірити дані в ЦБД для  ['items'][0]['address']['streetAddress']
###########################################################################
################################# /STEPS ##################################
###########################################################################




###########################################################################
################################# COMMON ##################################
###########################################################################
Натиснути створити аукціон
	Click Element  //*[@data-qa='button-create-auction']
	Дочекатись закінчення загрузки сторінки(skeleton)


Натиснути кнопку зберегти
	${save btn}  Set variable  //*[@data-qa='button-success']
    Scroll Page To Element XPATH  ${save btn}
    Click Element  ${save btn}
    Sleep  3
    Дочекатись закінчення загрузки сторінки(skeleton)


Опублікувати аукціон у реєстрі
	${publish btn}  Set Variable  //button[contains(.,'Опублікувати')]
	Wait Until Element Is Visible  ${publish btn}  10
   	Wait Until Element Is Not Visible  //*[@class='ivu-message']  10
	Scroll Page To Element XPATH  ${publish btn}
	Click Element  ${publish btn}
	Sleep  2
	Capture Page Screenshot
    Дочекатись Закінчення Загрузки Сторінки


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
	${date now}  Evaluate  '{:%Y-%m-%d}'.format(datetime.datetime.now())  modules=datetime
	${UAID should}  Set Variable  UA-PS-${date now}
	Should Contain  ${UAID is}  ${UAID should}


Отримати ID у цбд
    ${cdb locator}  Set Variable  //*[text()='Перейти']
    ${cdb href}  Get Element Attribute  ${cdb locator}  href
    ${cdb id}  do_regex  find  [a-z0-9]{32}  ${cdb href}
	#todo delete
    #Evaluate  re.sub(r'.*(auctions/)', '', re.sub(r'[?].*', '', '${cdb href}'))  modules=re #tod smell like shit)
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
	${lotNumber}  random_number  10000  1000000
	${selector}  dzk_auction.Отримати локатор по назві поля  ['lotIdentifier']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${lotNumber}
	Set To Dictionary  ${dzk_data}  lotIdentifier  ${lotNumber}


Заповнити title
	${title}  create_sentence  5
	${selector}  dzk_auction.Отримати локатор по назві поля  ['title']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${title}
	Set To Dictionary  ${dzk_data}  title  [ТЕСТУВАННЯ] ${title}


Заповнити description
	${description}  create_sentence  20
	${selector}  dzk_auction.Отримати локатор по назві поля  ['description']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${description}
	Set To Dictionary  ${dzk_data}  description  ${description}


Заповнити lotHolder.identifier.legalName
	${legalName}  create_sentence  2
	${selector}  dzk_auction.Отримати локатор по назві поля  ['lotHolder']['identifier']['legalName']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${legalName}
	Set To Dictionary  ${dzk_data['lotHolder']['identifier']}  legalName  ${legalName}


Заповнити lotHolder.identifier.id
	${id}  random_number  10000  100000
	${selector}  dzk_auction.Отримати локатор по назві поля  ['lotHolder']['identifier']['id']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${id}
	Set To Dictionary  ${dzk_data['lotHolder']['identifier']}  id  ${id}


Заповнити lotHolder.address.postalCode
	${postalCode}  random_number  10000  99999
	${selector}  dzk_auction.Отримати локатор по назві поля  ['lotHolder']['address']['postalCode']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${postalCode}
	Set To Dictionary  ${dzk_data['lotHolder']['address']}  postalCode  ${postalCode}


Заповнити lotHolder.address.locality
	${selector}  dzk_auction.Отримати локатор по назві поля  ['lotHolder']['address']['locality']
    ${locality}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути випадковий елемент з випадаючого списку  ${selector}
	${region}  do_regex  find  \((.*?)\)  ${locality}
	Set To Dictionary  ${dzk_data['lotHolder']['address']}  region  ${region}
	#todo Delete
	#Evaluate  ((re.findall(r'[(].+[^)]', '${locality}'))[0]).replace('(','')  modules=re #todo need code reviewe
	${locality}  go_regex  sub  .\(.*  ${locality}
	Set To Dictionary  ${dzk_data['lotHolder']['address']}  locality  ${locality}
	#Evaluate  ((re.findall(r'.*[(]', '${locality}'))[0]).replace(' (','')  modules=re #todo need code review


Заповнити lotHolder.address.streetAddress
	${streetAddress}  get_some_uuid
	${selector}  dzk_auction.Отримати локатор по назві поля  ['lotHolder']['address']['streetAddress']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${streetAddress}
	Set To Dictionary  ${dzk_data['lotHolder']['address']}  streetAddress  ${streetAddress}


Заповнити lotHolder.contactPoint.name
	${name}  create_sentence  3
	${selector}  dzk_auction.Отримати локатор по назві поля  ['lotHolder']['contactPoint']['name']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${name}
	Set To Dictionary  ${dzk_data['lotHolder']['contactPoint']}  name  ${name}


Заповнити lotHolder.contactPoint.email
	${text}  Generate Random String  6  [LETTERS][NUMBERS]
	${email}  Set Variable  ${text}@gmail.com
	${selector}  dzk_auction.Отримати локатор по назві поля  ['lotHolder']['contactPoint']['email']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${email}
	Set To Dictionary  ${dzk_data['lotHolder']['contactPoint']}  email  ${email}


Заповнити auctionPeriod.shouldStartAfter
	${delta minutes}  Set Variable  33
	${endDate}  Evaluate  '{:%d.%m.%Y %H:%M:%S}'.format(datetime.datetime.now() + datetime.timedelta(minutes=int(${delta minutes})))  modules=datetime
	${selector}  dzk_auction.Отримати локатор по назві поля  ['auctionPeriod']['shouldStartAfter']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${endDate}
	Click Element  ${selector}/ancestor::*[contains(@class,'item-content')]
	Sleep  .5
	Set To Dictionary  ${dzk_data['auctionPeriod']}  shouldStartAfter  ${endDate}


Заповнити tenderAttempts
	${selector}  dzk_auction.Отримати локатор по назві поля  ['tenderAttempts']
    ${tenderAttempts}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути випадковий елемент з випадаючого списку  ${selector}
	Set To Dictionary  ${dzk_data}  tenderAttempts  ${tenderAttempts}


Заповнити minNumberOfQualifiedBids
	${selector}  dzk_auction.Отримати локатор по назві поля  ['minNumberOfQualifiedBids']
    ${minNumberOfQualifiedBids}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути випадковий елемент з випадаючого списку  ${selector}
	Set To Dictionary  ${dzk_data}  minNumberOfQualifiedBids  ${minNumberOfQualifiedBids}


Заповнити contractTerms.leaseTerms.years
	${years}  random_number  1  100
	${selector}  dzk_auction.Отримати локатор по назві поля  ['contractTerms']['leaseTerms']['years']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${years}
	Set To Dictionary  ${dzk_data['contractTerms']['leaseTerms']}  years  ${years}
	${leaseDuration}  Set Variable If
	...  '${dzk_data['contractTerms']['leaseTerms']['leaseDuration']}' == ''  P0Y0M
	...  '${dzk_data['contractTerms']['leaseTerms']['leaseDuration']}' != ''  ${dzk_data['contractTerms']['leaseTerms']['leaseDuration']}
	#todo ${leaseDuration}  Evaluate  re.sub(r'P[0-9]*Y', 'P${years}Y', "${leaseDuration}")  modules=re
	${leaseDuration}  do_regex  sub  P[0-9]*Y  ${leaseDuration}  'P${years}Y'


Заповнити contractTerms.leaseTerms.months
	${months}  random_number  1  100
	${selector}  dzk_auction.Отримати локатор по назві поля  ['contractTerms']['leaseTerms']['months']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${months}
	Set To Dictionary  ${dzk_data['contractTerms']['leaseTerms']}  months  ${months}
	${leaseDuration}  Set Variable If
	...  '${dzk_data['contractTerms']['leaseTerms']['leaseDuration']}' == ''  P0Y0M
	...  '${dzk_data['contractTerms']['leaseTerms']['leaseDuration']}' != ''  ${dzk_data['contractTerms']['leaseTerms']['leaseDuration']}
	#todo ${leaseDuration}  Evaluate  re.sub(r'Y[0-9]*M', 'Y${months}M', "${leaseDuration}")  modules=re
	${leaseDuration}  do_regex  sub  Y[0-9]*M  ${leaseDuration}  'Y${months}M'



Заповнити value.amount
	${value}  random_number  1000000  10000000
	${selector}  dzk_auction.Отримати локатор по назві поля  ['value']['amount']
	small_privatization.Заповнити та перевірити поле з вартістю  ${selector}  ${value}
	Set To Dictionary  ${dzk_data['value']}  amount  ${value}


Заповнити minimalStep.amount
	${minimalStep}  random_number  10000  1000000
	${selector}  dzk_auction.Отримати локатор по назві поля  ['minimalStep']['amount']
	small_privatization.Заповнити та перевірити поле з вартістю  ${selector}  ${minimalStep}
	Set To Dictionary  ${dzk_data['minimalStep']}  amount  ${minimalStep}


Заповнити guarantee.amount
	${guarantee}  random_number  100  1000
	${selector}  dzk_auction.Отримати локатор по назві поля  ['guarantee']['amount']
	small_privatization.Заповнити та перевірити поле з вартістю  ${selector}  ${guarantee}
	Set To Dictionary  ${dzk_data['guarantee']}  amount  ${guarantee}


Заповнити budgetSpent.amount
	${budgetSpent}  random_number  100  1000
	${selector}  dzk_auction.Отримати локатор по назві поля  ['budgetSpent']['amount']
	small_privatization.Заповнити та перевірити поле з вартістю  ${selector}  ${budgetSpent}
	Set To Dictionary  ${dzk_data['budgetSpent']}  amount  ${budgetSpent}


Заповнити registrationFee.amount
	${registrationFee}  random_number  100  1000
	${selector}  dzk_auction.Отримати локатор по назві поля  ['registrationFee']['amount']
	small_privatization.Заповнити та перевірити поле з вартістю  ${selector}  ${registrationFee}
	Set To Dictionary  ${dzk_data['registrationFee']}  amount  ${registrationFee}


Заповнити bankAccount.bankName
	${bankName}  create_sentence  5
	${selector}  dzk_auction.Отримати локатор по назві поля  ['bankAccount']['bankName']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${bankName}
	Set To Dictionary  ${dzk_data['bankAccount']}  bankName  ${bankName}


Заповнити bankAccount.accountIdentification.0.description
	${description}  create_sentence  3
	${selector}  dzk_auction.Отримати локатор по назві поля  ['bankAccount']['accountIdentification'][0]['description']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${description}
	Set To Dictionary  ${dzk_data['bankAccount']['accountIdentification'][0]}  [Реквізити рахунку (рахунків) виконавця для сплати винагороди та/або витрат на підготовку] description  ${description}


Заповнити bankAccount.accountIdentification.(num).id
	: FOR  ${i}  IN RANGE  0  9
    \  ${id}  Generate Random String  10  [LETTERS][NUMBERS]
    \  ${selector}  dzk_auction.Отримати локатор по назві поля  ['bankAccount']['accountIdentification'][${i}]['id']
    \  Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${id}
    \  Set To Dictionary  ${dzk_data['bankAccount']['accountIdentification'][${i}]}  id  ${id}


Заповнити items.0.description
	${description}  create_sentence  20
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['description']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${description}
	Set To Dictionary  ${dzk_data['items'][0]}  description  ${description}


Заповнити items.0.additionalClassifications.1.id
	${cadastralNumber}  random_number  1000000000000000000  9999999999999999999
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['additionalClassifications'][1]['id']
	Input Text  ${selector}  ${cadastralNumber}
	${cadastralNumber}  Get Element Attribute  ${selector}  value
	Set To Dictionary  ${dzk_data['items'][0]['additionalClassifications'][1]}  id  ${cadastralNumber}


Заповнити items.0.classification.description
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['classification']['description']
	${description}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути випадковий елемент з класифікації  ${selector}
	#todo ${id}  Evaluate  (re.findall(r'[0-9]*[-][0-9]*', "${description}"))[0]  modules=re
	${id}  do_regex  find  [0-9]*[-][0-9]*  ${description}
	Set To Dictionary  ${dzk_data['items'][0]['classification']}  id  ${id}
	#todo ${description}  Evaluate  re.sub(r'[0-9]*[-][0-9]*.', '', "${description}")  modules=re
	${description}  do_regex  sub  [0-9]*[-][0-9]*.  ${description}
	Set To Dictionary  ${dzk_data['items'][0]['classification']}  description  ${description}


Заповнити items.0.additionalClassifications.description
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['additionalClassifications'][0]['description']
	${description}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути випадковий елемент з класифікації  ${selector}
	#todo ${id}  Evaluate  ((re.findall(r'[0-9]*[.][0-9]*', "${description}"))[0])  modules=re
	${id}  do_regex  find  [0-9]*[.][0-9]*  ${description}
	Set To Dictionary  ${dzk_data['items'][0]['additionalClassifications'][0]}  id  ${id}
	#todo ${description}  Evaluate  re.sub(r'[0-9]*[.][0-9]*.', '', "${description}", 0)  modules=re
	${description}  do_regex  sub  [0-9]*[.][0-9]*.  ${description}
	Set To Dictionary  ${dzk_data['items'][0]['additionalClassifications'][0]}  description  ${description}


Заповнити items.0.quantity
	${first}  random_number  1  100000
	${second}  random_number  1  1000
    ${quantity}  Evaluate  str(round(float(${first})/float(${second}), 3))
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['quantity']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${quantity}
	Set To Dictionary  ${dzk_data['items'][0]}  quantity  ${quantity}


Заповнити items.0.unit.name
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['unit']['name']
    ${name}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути випадковий елемент з випадаючого списку  ${selector}
	Set To Dictionary  ${dzk_data['items'][0]['unit']}  name  ${name}


Заповнити items.0.address.postalCode
	${postalCode}  random_number  10000  99999
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['address']['postalCode']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${postalCode}
	Set To Dictionary  ${dzk_data['items'][0]['address']}  postalCode  ${postalCode}


Заповнити items.0.address.locality
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['address']['locality']
    ${locality}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути випадковий елемент з випадаючого списку  ${selector}
	#todo ${region}  Evaluate  ((re.findall(r'[(].+[^)]', '${locality}'))[0]).replace('(','')  modules=re
	${region}  do_regex  find  \((.*?)\)  ${locality}
	Set To Dictionary  ${dzk_data['items'][0]['address']}  region  ${region}
	#${locality}  Evaluate  ((re.findall(r'.*[(]', '${locality}'))[0]).replace(' (','')  modules=re
	${locality}  go_regex  sub  .\(.*  ${locality}
	Set To Dictionary  ${dzk_data['items'][0]['address']}  locality  ${locality}


Заповнити items.0.address.streetAddress
	${streetAddress}  get_some_uuid
	${selector}  dzk_auction.Отримати локатор по назві поля  ['items'][0]['address']['streetAddress']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${streetAddress}
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



# Отритами дані зі сторінки
# 	[Arguments]  ${field}
# 	${selector}  dzk_auction.Отримати локатор по назві поля	${field}
# 	Wait Until Element Is Visible  ${selector}  10
# 	${value}  Get Text  ${selector}
# 	${field value}  Парсінг за необхідністью  ${field}  ${value}
# 	[Return]  ${field value}
#
#
# Переірити відображення для
# 	[Arguments]  ${field}
# 	${value should}  Set Variable  ${dzk_data${field}}
# 	${value is}  Отритами дані зі сторінки  ${field}
# 	Should Be Equal  ${value should}  ${value is}
#
#
Перевірити дані в ЦБД для
	[Arguments]  ${field}
	${value should}  Set Variable  ${cdb_data${field}}
	${value is}  Set Variable  ${dzk_data${field}}
	${is equal}  Порівняти дані  ${value is}  ${value should}
	Run Keyword If  ${is equal} == ${False}
	...  Fail  Oops, в ЦБД пішли не ті дані!!!


Порівняти дані
	[Arguments]  ${is}  ${should}
	${result}  Set Variable  ${False}
	${result}  Evaluate  ${result} or ("${is}" == "${should}")
	${result}  Evaluate  ${result} or (float(${is}) == float(${should}))
	Run Keyword If  ${result} == ${False}
	...  Run Keyword And Ignore Error  ${is}  Конвертувати дату в формат ЦБД  ${is}
	...  ${result}  Evaluate  ${result} or (${is}  in  ${should})
	[Return]  ${result}

###########################################################################
################################# /CHECK ##################################
###########################################################################
Конвертувати дату в формат ЦБД
	[Arguments]  ${date}
	${years}  do_regex  find  [0-9]{4}  ${date}
	${months}  do_regex  find  \.([0-9]{2})\.  ${date}
	${days}  do_regex  find  ^[0-9]{2}  ${date}
	${hours}  do_regex  find  \ ([0-9]{2})\:  ${date}
	${minutes}  do_regex  find  \:([0-9]{2})\:  ${date}
	${seconds}  do_regex  find  [0-9]{2}$  ${date}
	[Return]  ${years}-${months}-${days}T${hours}:${minutes}:${seconds}