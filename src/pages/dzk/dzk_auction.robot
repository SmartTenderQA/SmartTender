*** Settings ***
Variables  dzk_variables.py


*** Variables ***


*** Keywords ***
Заповнити всі обов'язкові поля
	dzk_auction.Заповнити lotIdentifier
	dzk_auction.Заповнити title
	dzk_auction.Заповнити description
	dzk_auction.Заповнити lotHolder.identifier.legalName
	dzk_auction.Заповнити lotHolder.identifier.id
	dzk_auction.Заповнити lotHolder.address.postalCode
	dzk_auction.Заповнити lotHolder.address.locality
	dzk_auction.Заповнити lotHolder.address.streetAddress
	debug
	dzk_auction.


Натиснути створити аукціон
	Click Element  //*[@data-qa='button-create-auction']
	Дочекатись закінчення загрузки сторінки(skeleton)


Натиснути кнопку зберегти
	${save btn}  Set variable  //*[@data-qa='button-success']
    Scroll Page To Element XPATH  ${save btn}
    Click Element  ${save btn}
    Sleep  3
    Дочекатись Закінчення Загрузки Сторінки


Опублікувати об'єкт у реєстрі
	${publish btn}  Set Variable  //*[@data-qa='button-publish-asset']
	Wait Until Element Is Visible  ${publish btn}  10
   	Wait Until Element Is Not Visible  //*[@class='ivu-message']  10
	Scroll Page To Element XPATH  ${publish btn}
	Click Element  ${publish btn}
    Дочекатись Закінчення Загрузки Сторінки


Заповнити lotIdentifier
	${field}  Set Variable  ['lotIdentifier']
	${lotNumber}  random_number  10000  1000000
	${selector}  dzk_auction.Отримати локатор по назві поля  ${field}
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${lotNumber}
	${dzk_data['lotIdentifier']}  Set Variable  ${lotNumber}


Заповнити title
	${field}  Set Variable  ['title']
	${title}  create_sentence  5
	${selector}  dzk_auction.Отримати локатор по назві поля  ${field}
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${title}
	${dzk_data${field}}  Set Variable  ${title}


Заповнити description
	${field}  Set Variable  ['description']
	${description}  create_sentence  20
	${selector}  dzk_auction.Отримати локатор по назві поля  ${field}
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${description}
	${dzk_data${field}}  Set Variable  ${description}


Заповнити lotHolder.identifier.legalName
	${field}  Set Variable  ['lotHolder']['identifier']['legalName']
	${legalName}  create_sentence  2
	${selector}  dzk_auction.Отримати локатор по назві поля  ${field}
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${legalName}
	${dzk_data${field}}  Set Variable  ${legalName}


Заповнити lotHolder.identifier.id
	${field}  Set Variable  ['lotHolder']['identifier']['id']
	${id}  random_number  10000  100000
	${selector}  dzk_auction.Отримати локатор по назві поля  ${field}
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${id}
	${dzk_data${field}}  Set Variable  ${id}


Заповнити lotHolder.address.postalCode
	${field}  Set Variable  ['lotHolder']['address']['postalCode']
	${postalCode}  random_number  10000  99999
	${selector}  dzk_auction.Отримати локатор по назві поля  ${field}
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${postalCode}
	${dzk_data${field}}  Set Variable  ${postalCode}


Заповнити lotHolder.address.locality
	${field}  Set Variable  ['lotHolder']['address']['locality']
	${selector}  dzk_auction.Отримати локатор по назві поля  ${field}
    ${locality}  Wait Until Keyword Succeeds  30  3  small_privatization.Вибрати та повернути випадковий елемент з випадаючого списку  ${selector}
	${dzk_data${field}}  Set Variable  ${locality}


Заповнити lotHolder.address.streetAddress
	${field}  Set Variable  ['lotHolder']['address']['streetAddress']
	${streetAddress}  get_some_uuid
	${selector}  dzk_auction.Отримати локатор по назві поля  ${field}
	Wait Until Keyword Succeeds  30  3  small_privatization.Заповнити та перевірити текстове поле  ${selector}  ${streetAddress}
	${dzk_data${field}}  Set Variable  ${streetAddress}






Отримати локатор по назві поля
	[Arguments]  ${field}
	${selector}  Set Variable  ${dzk_locators${field}}
	[Return]  ${selector}