*** Settings ***


*** Variables ***


*** Keywords ***
###########################################################################
################################## STEPS ##################################
###########################################################################
Перевірити всі обов'язкові поля в цбд
	compare_data.Порівняти введені дані з даними в ЦБД  ['title']
	compare_data.Порівняти введені дані з даними в ЦБД  ['description']
	compare_data.Порівняти введені дані з даними в ЦБД  ['decisions'][0]['title']
	compare_data.Порівняти введені дані з даними в ЦБД  ['decisions'][0]['decisionID']
	compare_data.Порівняти введені дані з даними в ЦБД  ['decisions'][0]['decisionDate']  s
	compare_data.Порівняти введені дані з даними в ЦБД  ['items'][0]['description']
	#todo hz 4to eto i za4em ono
	#compare_data.Порівняти введені дані з даними в ЦБД  ['items'][0]['classification']['kind']
	#
	compare_data.Порівняти введені дані з даними в ЦБД  ['items'][0]['classification']['id']
	compare_data.Порівняти введені дані з даними в ЦБД  ['items'][0]['classification']['description']
	compare_data.Порівняти введені дані з даними в ЦБД  ['items'][0]['quantity']
	compare_data.Порівняти введені дані з даними в ЦБД  ['items'][0]['unit']['name']
	compare_data.Порівняти введені дані з даними в ЦБД  ['items'][0]['address']['postalCode']
	compare_data.Порівняти введені дані з даними в ЦБД  ['items'][0]['address']['countryName']
	compare_data.Порівняти введені дані з даними в ЦБД  ['items'][0]['address']['region']
	compare_data.Порівняти введені дані з даними в ЦБД  ['items'][0]['address']['locality']
	compare_data.Порівняти введені дані з даними в ЦБД  ['items'][0]['address']['streetAddress']


Перевірити відображення всіх обов'язкових полів на сторінці об'єкту
	compare_data.Порівняти відображені дані з даними в ЦБД  ['assetID']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['title']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['description']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['decisions'][0]['title']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['decisions'][0]['decisionID']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['decisions'][0]['decisionDate']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['assetCustodian']['identifier']['legalName']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['assetCustodian']['identifier']['id']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['assetCustodian']['identifier']['scheme']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['assetCustodian']['contactPoint']['name']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['assetCustodian']['contactPoint']['telephone']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['assetCustodian']['contactPoint']['email']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['description']
	#todo hz 4to eto i za4em ono
	#compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['classification']['kind']
	#
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['classification']['description']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['classification']['id']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['classification']['scheme']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['address']['postalCode']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['address']['countryName']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['address']['region']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['address']['locality']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['address']['streetAddress']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['quantity']
	compare_data.Порівняти відображені дані з даними в ЦБД  ['items'][0]['unit']['name']
###########################################################################
################################# /STEPS ##################################
###########################################################################



###########################################################################
################################# COMMON ##################################
###########################################################################
Натиснути кнопку "Коригувати об'єкт приватизації"
     ${selector}  Set Variable  //*[@data-qa="button-to-edit-page"]
     Scroll Page To Element XPATH  ${selector}
     Click Element  ${selector}
     Дочекатись закінчення загрузки сторінки(skeleton)
     Location Should Contain  /privatization-objects/edit/


Отримати кілкість документів обєкту приватизації
    ${selector}  Set Variable  //*[@data-qa="file-name"]
    ${count}  Get Element Count  ${selector}
    [Return]  ${count}


Натиснути кнопку зберегти
	${save btn}  Set variable  //*[@data-qa='button-success']
    Scroll Page To Element XPATH  ${save btn}
    Click Element  ${save btn}
    Wait Until Element Is Visible  ${notice message}  15
    ${notice text}  Get Text  ${notice message}
	Should Contain  ${notice text}  успішно
	Wait Until Page Does Not Contain Element  ${notice message}


Опублікувати об'єкт у реєстрі
	${publish btn}  Set Variable  //*[@data-qa='button-publish-asset']
	Wait Until Element Is Visible  ${publish btn}  10
   	Wait Until Element Is Not Visible  //*[@class='ivu-message']  10
	Scroll Page To Element XPATH  ${publish btn}
	Click Element  ${publish btn}
    Wait Until Element Is Visible  ${notice message}  15
    ${notice text}  Get Text  ${notice message}
	Should Contain  ${notice text}  успішно
	Wait Until Page Does Not Contain Element  ${notice message}


Отримати UAID для Об'єкту
	Reload Page
    Wait Until Element Is Visible  //*[@data-qa='cdbNumber']  10
    Wait Until Element Is Not Visible  //*[@class='ivu-message']  10
	${UAID}  Get Text  //*[@data-qa='cdbNumber']
	${correct status}  Run Keyword And Return Status  Перевірити коректність UAID для Об'єкту  ${UAID}
	Run Keyword If  ${correct status} == ${False}  Отримати UAID для Об'єкту
    Set To Dictionary  ${data}  assetID  ${UAID}


Перевірити коректність UAID для Об'єкту
	[Arguments]  ${UAID is}
	${date now}  Evaluate  '{:%Y-%m-%d}'.format(datetime.datetime.now())  modules=datetime
	${UAID should}  Set Variable  UA-AR-P-${date now}
	Should Contain  ${UAID is}  ${UAID should}


Отримати ID у цбд
    ${cdb locator}  Set Variable  //*[@data-qa='cdbNumber']
    ${cdb href}  Get Element Attribute  ${cdb locator}  href
    ${cdb id}  Evaluate  (re.findall(r'[a-z0-9]{32}','${cdb href}'))[0]  re
    Set To Dictionary  ${data}  id  ${cdb id}



########################
#region#Робота з полями#
########################
Заповнити title
	[Arguments]  ${text}
	${selector}  small_privatization_object.Отримати локатор по назві поля  ['title']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити description
	[Arguments]  ${text}
	${selector}  small_privatization_object.Отримати локатор по назві поля  ['description']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити decisions.0.title
	[Arguments]  ${text}
	${selector}  small_privatization_object.Отримати локатор по назві поля  ['decisions'][0]['title']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}



Заповнити decisions.0.decisionID
	[Arguments]  ${text}
	${selector}  small_privatization_object.Отримати локатор по назві поля  ['decisions'][0]['decisionID']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}



Заповнити decisions.0.decisionDate
	[Arguments]  ${text}
	${selector}  small_privatization_object.Отримати локатор по назві поля  ['decisions'][0]['decisionDate']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити items.0.description
	[Arguments]  ${text}
	${selector}  small_privatization_object.Отримати локатор по назві поля  ['items'][0]['description']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}



Заповнити items.0.classification.kind
	[Arguments]  ${text}=''
	${selector}  small_privatization_object.Отримати локатор по назві поля  ['items'][0]['classification']['kind']
	${kind}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути елемент з випадаючого списку  ${selector}  ${text}
	[Return]  ${kind}


Заповнити items.0.classification.description
	${selector}  small_privatization_object.Отримати локатор по назві поля  ['items'][0]['classification']['description']
	${description}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути випадковий елемент з класифікації  ${selector}
	[Return]  ${description}


Заповнити items.0.quantity
	[Arguments]  ${text}
	${selector}  small_privatization_object.Отримати локатор по назві поля  ['items'][0]['quantity']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити items.0.unit.name
	${selector}  small_privatization_object.Отримати локатор по назві поля  ['items'][0]['unit']['name']
	${name}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути елемент з випадаючого списку  ${selector}
	[Return]  ${name}


Заповнити items.0.address.postalCode
	[Arguments]  ${text}
	${selector}  small_privatization_object.Отримати локатор по назві поля  ['items'][0]['address']['postalCode']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}



Заповнити items.0.address.countryName
   	[Arguments]  ${text}=''
	${selector}  small_privatization_object.Отримати локатор по назві поля  ['items'][0]['address']['countryName']
	${countryName}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути елемент з випадаючого списку  ${selector}  ${text}
	[Return]  ${countryName}


Заповнити items.0.address.locality
   	[Arguments]  ${text}=''
	${selector}  small_privatization_object.Отримати локатор по назві поля  ['items'][0]['address']['locality']
	${locality}  Wait Until Keyword Succeeds  30  3  dzk_auction.Вибрати та повернути елемент з випадаючого списку  ${selector}  ${text}
	[Return]  ${locality}


Заповнити items.0.address.streetAddress
	[Arguments]  ${text}
	${selector}  small_privatization_object.Отримати локатор по назві поля  ['items'][0]['address']['streetAddress']
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${text}


Прикріпити документ
	${selector}  Set Variable  //*[@data-qa='component-documents']
	${doc}  Створити та додати файл  ${selector}//input
	Element Should Contain  ${selector}  ${doc[1]}
	Set To Dictionary  ${data}  document-name  ${doc[1]}


###########################################################################
############################## INPUT FIELD ################################
###########################################################################



###########################################################################
################################## CHECK ##################################
###########################################################################
Отримати локатор по назві поля
	[Arguments]  ${field}
	${selector}  Set Variable  ${edit_locators${field}}
	[Return]  ${selector}


Отритами дані зі сторінки
 	[Arguments]  ${field}
 	${selector}  Set Variable  ${view_locators${field}}
 	Wait Until Element Is Visible  ${selector}  10
 	${value}  Get Text  ${selector}
 	${field value}  small_privatization_object_common.get_page_values  ${field}  ${value}
 	[Return]  ${field value}


Переірити відображення для
 	[Arguments]  ${field}
 	${value should}  Set Variable  ${data${field}}
 	${value is}  small_privatization_object.Отритами дані зі сторінки  ${field}
	Should Be Equal  ${value is}  ${value should}  Oops! Відображаються не ті дані для ${field}


Перевірити дані в ЦБД для
	[Arguments]  ${field}
	${value should}  Set Variable  ${data${field}}
	${value cdb}  Set Variable  ${cdb_data${field}}
 	${is equal}  small_privatization_object_common.get_cdb_values  ${value cdb}  ${value should}
	Should Be Equal  ${is equal}  ${True}  Oops! В ЦБД не ті дані для ${field}
###########################################################################
################################# /CHECK ##################################
###########################################################################