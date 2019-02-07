*** Keywords ***
Перевірити сторінку
	Location Should Contain  /invoicepage/


Ввести суму до оплати
	[Arguments]  ${amount}
	${input field}  Set Variable  //*[@class="ivu-card-body"]//input
	Wait Until Page Contains Element  ${input field}  60
	Input Text  ${input field}  ${amount}
	${get}  Get Element Attribute  ${input field}  value
	Run Keyword If  "${get}" == ""  Ввести суму до оплати


Натиснути сформувати рахунок
	${selector}  Set Variable  //*[@class="ivu-card-body"]//button
	Click Element  (${selector})[last()]
	Дочекатись закінчення загрузки сторінки
	Wait Until Page Does Not Contain  ${selector}


Перевірити валідаційне повідомлення для сформованого рахунку
	Element Should Contain  css=.ivu-alert-desc  Рахунок сформований
	Element Should Contain  css=.ivu-alert-desc  відправлений на електронну адресу Вашої компанії


Обрати тип оплати
    [Arguments]  ${type}
    ${dict}  Create Dictionary
    ...  Карткою=1
    ...  Рахунок-фактура=2
    ${selector}  Set Variable  (//div[contains(@class, "payment-method")])[${dict[u'${type}']}]
    Click Element  ${selector}
    Wait Until Element is Visible  ${selector}/self::*[contains(@class, "active")]


Перевірити що підказок на сторінці
    [Arguments]  ${desired ammount}
    ${actual ammount}  Get Element Count   //div[contains(@class, "ivu-alert-with-desc")]
    Should Be Equal As Strings  ${desired ammount}  ${actual ammount}  На сторінці ${actual ammount} підказка(и), а повинно бути ${desired ammount}


Перевірити що підказка містить текст
    [Arguments]  ${text}
    Wait Until Element Is Visible  //*[@class="ivu-alert-desc"]//span[contains(text(), "${text}")]


Перевірити підтвердження формування рахунку-фактури
    ${login}  Отримати дані користувача по полю  ${user}  login
    ${message}  Set Variable  //*[@class="ivu-alert-desc"]//div[contains(text(), "Рахунок сформований і найближчим часом буде відправлений на електронну адресу Вашої компанії (${login})")]|//*[@class="ivu-alert-desc"]//div[contains(text(), "Рахунок сформований і відправлений на електронну адресу Вашої компанії (${login}).")]
    Wait Until Page Contains Element  ${message}


Перевірити перехід на сторінку Platon
    ${url}  Get Location
    Should Contain  ${url}  https://secure.platononline.com/payment/purchase?token


Перевірити що на сторінці стільки типів оплати
    [Arguments]  ${desired ammount}
    ${actual ammount}  Get Element Count  //div[contains(@class, "payment-method")]
    Should Be Equal As Strings  ${desired ammount}  ${actual ammount}  На сторінці ${actual ammount} тип(а) оплати, а повинно бути ${desired ammount}


Перевірити що на сторінці є тип оплати
    [Arguments]  ${type}
    Element Should Be Visible  //div[contains(@class, "payment-method")]//p[text()="${type}"]
