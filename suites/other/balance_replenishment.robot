*** Settings ***
Resource  				../../src/src.robot

Suite Setup  			Run Keywords
...						Open Browser In Grid  ${user}  AND
...						Авторизуватися  ${user}  AND
...                     Preconditions
Suite Teardown  		Close All Browsers
Test Teardown  			Run Keywords
						...  Log Location  AND
						...  Run Keyword If Test Failed  Capture Page Screenshot




*** Test Cases ***
Обрати тип оплати Рахунок-фактура(ідентифікований користувач)
    [Tags]  identified-invoice
    invoice.Обрати тип оплати  Рахунок-фактура
    invoice.Перевірити що підказок на сторінці  1
    invoice.Перевірити що підказка містить текст  Сума до оплати має бути кратною
    ${amount}  Спробувати поповнити баланс з сумою та без
    invoice.Перевірити підтвердження формування рахунку-фактури
    Перевірити email рахунок-фактуру  ${amount}


Обрати тип оплати Картка(ідентифікований користувач)
    [Tags]  identified-card
    invoice.Обрати тип оплати  Карткою
    invoice.Перевірити що підказок на сторінці  2
    invoice.Перевірити що підказка містить текст  Сума до оплати має бути кратною
    invoice.Перевірити що підказка містить текст  У разі сплати карткою Visa/MasterCard
    ${amount}  Спробувати поповнити баланс з сумою та без
    Wait Until Keyword Succeeds  15  2  invoice.Перевірити перехід на сторінку Platon
    Перевірити суму на сторінці Platon  ${amount}



Сформувати рахунок-фактуру(неідентифікований користувач)
    [Tags]  unidentified
    invoice.Перевірити що підказка містить текст  Сума до оплати має бути кратною
    invoice.Перевірити що підказка містить текст  Ваша компанія повинна пройти ідентифікацію
    invoice.Перевірити що на сторінці стільки типів оплати  1
    invoice.Перевірити що на сторінці є тип оплати  Сформувати рахунок-фактуру для оплати


*** Keywords ***
Preconditions
    Навести мишку на іконку з заголовку  Баланс
    balance.Натиснути сформувати Invoice
    Дочекатись закінчення загрузки сторінки
    Дочекатись закінчення загрузки сторінки(полоса)
    invoice.Перевірити сторінку


Спробувати сформувати рахунок без суми
    Run Keyword And Ignore Error  Натиснути сформувати рахунок
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
	Розпочати роботу з Gmail  ${user}
	Відкрити лист в Email за темою  SmartTender - Рахунок за Надання послуг
	Перевірити вкладений файл за назвою  ${amount}  Рахунок
	Close Browser
	Switch Browser  1


Перевірити суму на сторінці Platon
    [Documentation]  amount = platon amount - 2.7%
    [Arguments]  ${amount}
    Wait Until Element Is Visible  //span[@class="price"]
    ${platon amount}  Get Text  //span[@class="price"]
    ${platon amount}  Convert To Number  ${platon amount[:-4]}
    ${approximate amount}  Evaluate  int(round(${platon amount}*0.973))
    should be equal as strings  ${amount}  ${approximate amount}