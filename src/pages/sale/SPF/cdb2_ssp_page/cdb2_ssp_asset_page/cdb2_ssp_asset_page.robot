*** Settings ***


*** Variables ***


*** Keywords ***
###########################################################################
################################# COMMON ##################################
###########################################################################
Активувати перемемик тестового режиму на
	[Documentation]  ${switcher mode} == вкл|викл
	[Arguments]  ${switcher mode}
	${switcher locator}  Set Variable  //*[@data-qa='switch-test-mode']
	${switcher class}  Get Element Attribute  ${switcher locator}  class
	${switcher status}  Set Variable If
	...  'ivu-switch-checked' in '${switcher class}'  вкл  викл
	Run Keyword If  '${switcher status}' != '${switcher mode}'  Click Element  ${switcher locator}
	Дочекатись закінчення загрузки сторінки


Натиснути кнопку "Коригувати об'єкт приватизації"
     ${selector}  Set Variable  //*[@data-qa="button-to-edit-page"]
     Scroll Page To Element XPATH  ${selector}
     Click Element  ${selector}
     Дочекатись закінчення загрузки сторінки
     Location Should Contain  /privatization-objects/edit/


Отримати кілкість документів обєкту приватизації
    ${selector}  Set Variable  //*[@data-qa="file-name"]
    ${count}  Get Element Count  ${selector}
    [Return]  ${count}


Отримати UAID для Об'єкту
	Reload Page
	Дочекатись закінчення загрузки сторінки
    Wait Until Element Is Visible  //*[@data-qa='cdbNumber']  10
    Wait Until Element Is Not Visible  //*[@class='ivu-message']  10
	${UAID}  Get Text  //*[@data-qa='cdbNumber']
	${correct status}  Run Keyword And Return Status  Перевірити коректність UAID для Об'єкту  ${UAID}
	Run Keyword If  ${correct status} == ${False}  Отримати UAID для Об'єкту
    Set Global Variable  ${assetID}  ${UAID}
    Set To Dictionary  ${data}  assetID  ${UAID}


Перевірити коректність UAID для Об'єкту
	[Arguments]  ${UAID is}
	${date now}  Evaluate  '{:%Y-%m-%d}'.format(datetime.datetime.now())  modules=datetime
	${UAID should}  Set Variable  UA-AR-P-${date now}
	Should Contain  ${UAID is}  ${UAID should}


Отримати ID у цбд
    ${cdb locator}  Set Variable If  '${site}' == 'test'  //*[@data-qa='cdbNumber']  //*[text()='Перейти']
    ${cdb href}  Get Element Attribute  ${cdb locator}  href
	${cdb href}  Поправити лінку для IP  ${cdb href}
    ${cdb id}  Evaluate  (re.findall(r'[a-z0-9]{32}','${cdb href}'))[0]  re
    Set To Dictionary  ${data}  id  ${cdb id}



########################
#region#Робота з полями#
########################
Заповнити title
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['title']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити description
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['description']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити decisions.0.title
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['decisions'][0]['title']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}



Заповнити decisions.0.decisionID
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['decisions'][0]['decisionID']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}



Заповнити decisions.0.decisionDate
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['decisions'][0]['decisionDate']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити items.0.description
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['items'][0]['description']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}



Заповнити items.0.classification.kind
	[Arguments]  ${text}=''
	${selector}  sale_keywords.Отримати локатор по назві поля  ['items'][0]['classification']['kind']
	${kind}  Wait Until Keyword Succeeds  30  3  sale_keywords.Вибрати та повернути елемент з випадаючого списку  ${selector}  ${text}
	[Return]  ${kind}


Заповнити items.0.classification.description
	${selector}  sale_keywords.Отримати локатор по назві поля  ['items'][0]['classification']['description']
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
   	[Arguments]  ${text}=''
	${selector}  sale_keywords.Отримати локатор по назві поля  ['items'][0]['address']['locality']
	${locality}  Wait Until Keyword Succeeds  30  3  sale_keywords.Вибрати та повернути елемент з випадаючого списку  ${selector}  ${text}
	[Return]  ${locality}


Заповнити items.0.address.streetAddress
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['items'][0]['address']['streetAddress']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Прикріпити документ
	${selector}  Set Variable  //*[@data-qa='component-documents']
	${doc}  Створити та додати файл  ${selector}//input
	Element Should Contain  ${selector}  ${doc[1]}
	Set To Dictionary  ${data}  document-name  ${doc[1]}


###########################################################################
############################## INPUT FIELD ################################
###########################################################################