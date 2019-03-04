*** Settings ***
Resource  				../../src/src.robot

Suite Setup  			Preconditions
Suite Teardown  		Close All Browsers
Test Teardown  			Run Keywords
						...  Log Location  AND
						...  Run Keyword If Test Failed  Capture Element Screenshot  //body

#robot --consolecolors on -L TRACE:INFO -d test_output -i $tag -v suite:$tag -v where:$where suites/other/balance_replenishment.robot


*** Test Cases ***
Обрати тип оплати Рахунок-фактура(ідентифікований користувач)
    [Tags]  identified-invoice
    invoice.Обрати тип оплати  Рахунок-фактура
    invoice.Перевірити що підказок на сторінці  1
    invoice.Перевірити що підказка містить текст  Сума до оплати має бути кратною
    ${amount}  Спробувати поповнити баланс з сумою та без
#    invoice.Перевірити підтвердження формування рахунку-фактури
    Перевірити email рахунок-фактуру  ${amount}


Обрати тип оплати Картка(ідентифікований користувач)
    [Tags]  identified-card
    invoice.Обрати тип оплати  Карткою
    invoice.Перевірити що підказок на сторінці  2
    invoice.Перевірити що підказка містить текст  Сума до оплати має бути кратною
    invoice.Перевірити що підказка містить текст  У разі сплати карткою Visa/MasterCard
    ${amount}  Спробувати поповнити баланс з сумою та без
    Wait Until Keyword Succeeds  60  5  invoice.Перевірити перехід на сторінку Platon
    Перевірити суму на сторінці Platon  ${amount}



Сформувати рахунок-фактуру(неідентифікований користувач)
    [Tags]  unidentified
    invoice.Перевірити що підказка містить текст  Сума до оплати має бути кратною
    invoice.Перевірити що підказка містить текст  Ваша компанія повинна пройти ідентифікацію
    invoice.Перевірити що на сторінці стільки типів оплати  1
    invoice.Перевірити що на сторінці є тип оплати  Сформувати рахунок-фактуру для оплати


*** Keywords ***
Preconditions
	${site}  Set Variable If  '${where}' == 'test'  test  prod
	${user}  Run Keyword If  'prod' in '${site}'  Set Variable If
	...  "identified-invoice" == "${suite}"		new_provider
	...  "identified-card" == "${suite}"		new_provider
	...  "unidentified" == "${suite}"			prod_provider1
	...  ELSE  Set Variable If
	...  "identified-invoice" == "${suite}"		user4
	...  "identified-card" == "${suite}"		user4
	...  "unidentified == ${suite}"				user3
   	Set Global Variable  ${user}  ${user}
	Open Browser In Grid  ${user}
	Авторизуватися  ${user}
    Навести мишку на іконку з заголовку  Баланс
    balance.Натиснути сформувати Invoice
    Дочекатись закінчення загрузки сторінки
    invoice.Перевірити сторінку
   	${TEST START TIME}  Evaluate  ('{:%d.%m.%Y %H:%M:%S}'.format(datetime.datetime.now() - datetime.timedelta(minutes=3)))  datetime
   	#date.now - 3 min (так нужно)
	Set Global Variable  ${TEST START TIME}  ${TEST START TIME}



Спробувати сформувати рахунок без суми
	${create invoice btn}  Set Variable  //*[@class="ivu-card-body"]//button
	Click Element  (${create invoice btn})[last()]
    Дочекатись сповіщення з текстом  Заповніть будь-ласка вірно усі необхідні поля


Сгенерувати суму до оплати
	${n}  random_number  1  1000
	${amount}  Evaluate  ${n}*17
	[Return]  ${amount}


Спробувати поповнити баланс з сумою та без
    Спробувати сформувати рахунок без суми
    ${amount}  Сгенерувати суму до оплати
    Ввести суму до оплати  ${amount}
	Натиснути сформувати рахунок
	[Return]  ${amount}


Перевірити email рахунок-фактуру
	[Arguments]  ${amount}
	${gmail}  email.Розпочати роботу з Gmail  ${user}
	${message}  email.Дочекатися отримання листа на пошту  ${gmail}  10m  SmartTender - Рахунок за Надання послуг
	${file}  get_attachment_from_message  ${message}  pdf
	Should Contain  ${file['content']}  ${amount},00


Перевірити суму на сторінці Platon
    [Documentation]  amount = platon amount - 2.7%
    [Arguments]  ${amount}
    Wait Until Element Is Visible  //span[@class="price"]
    ${platon amount}  Get Text  //span[@class="price"]
    ${platon amount}  Convert To Number  ${platon amount[:-4]}
    ${approximate amount}  Evaluate  int(round(${platon amount}*0.973))
    should be equal as strings  ${amount}  ${approximate amount}