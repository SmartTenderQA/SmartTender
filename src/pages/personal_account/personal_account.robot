*** Settings ***
Resource    	keywords.robot


*** Variables ***
${not collapsed menu button your account}         //*[contains(@class, "page-container") and not(contains(@class, "collapsed"))]//*[@class="sidebar-collapse"]
${collapsed menu button your account}             //*[contains(@class, "page-container") and contains(@class, "collapsed")]//*[@class="sidebar-collapse"]


*** Keywords ***
Розкрити меню в особистому кабінеті
	${status}  Run Keyword And Return Status  Page Should Contain Element  ${not collapsed menu button your account}
	Run Keyword If  "${status}" != "True"  Click Element  ${collapsed menu button your account}


Розгорнути під-меню в особистому кабінеті
    [Arguments]  ${menu}  ${item}
    Click Element  ${menu}
    Sleep  .5
    Click Element  ${item}


Відкрити сторінку рахунка фактури
	Click Element  //*[contains(text(), "Сформувати рахунок-фактуру")]/ancestor::a
	Location Should Contain  /invoicepage/


Відкрити сторінку "Аналітика"
    Відкрити особистий кабінет
    Розкрити меню в особистому кабінеті
    Click Element  //a[@href='/ParticipationAnalytic']
    Дочекатись закінчення загрузки сторінки
    Page Should Contain  Аналітика участі


Відкрити сторінку "Тендерне забезпечення"
    Відкрити особистий кабінет
    Розкрити меню в особистому кабінеті
    Розгорнути під-меню в особистому кабінеті  //*[contains(text(), "Платні сервіси")]/ancestor::a  //*[contains(text(), "Тендерне забезпечення")]/ancestor::a
    Дочекатись закінчення загрузки сторінки
    Element Should Contain  //h1  Заявки на отримання тендерного забезпечення
    Page Should Contain Element  //img[@src="/Images/Guarantee/guarantee-button.png"]


Відкрити сторінку "Юридична допомога"
    Відкрити особистий кабінет
    Розкрити меню в особистому кабінеті
    Розгорнути під-меню в особистому кабінеті  //*[contains(text(), "Платні сервіси")]/ancestor::a  //*[contains(text(), "Юридична допомога")]/ancestor::a
    Дочекатись закінчення загрузки сторінки
    Select frame  css=div.main-content iFrame
    Wait Until Page Contains Element  //*[@class="ivu-card-head"]//h4  30
    Element Should Contain  //*[@class="ivu-card-head"]//h4  Отримати юридичну допомогу
    Page Should Contain Element  css=.ivu-card-body>button[type="button"]
    Unselect Frame


Відкрити сторінку "Профіль компанії"
    Відкрити особистий кабінет
    Розкрити меню в особистому кабінеті
    Розгорнути під-меню в особистому кабінеті  //*[contains(text(), "Особисті дані")]/ancestor::a  //*[contains(text(), "Профіль компанії")]/ancestor::a
    Select frame  css=div.main-content iFrame
    Wait Until Page Contains Element  css=#FormLayout_1_0  30
    Element Should Contain  css=#FormLayout_1_0  Основна інформація
    Element Should Contain  css=#FormLayout_1_1  Додаткова інформація
    Page Should Contain Element  css=#BTSUBMIT_CD
    Unselect Frame


Відкрити сторінку "Змінити пароль" (особистий кабінет)
    Відкрити особистий кабінет
    Run Keyword  Відкрити сторінку "Змінити пароль" (особистий кабінет) для ${role}


Відкрити сторінку "Управління користувачами"
    Відкрити особистий кабінет
    Розкрити меню в особистому кабінеті
    Розгорнути під-меню в особистому кабінеті  //*[contains(text(), "Особисті дані")]/ancestor::a  //*[contains(text(), "Управління користувачами")]/ancestor::a
    Дочекатись закінчення загрузки сторінки
    Wait Until Page Contains Element  //h1  30
    Element Should Contain  //h1  Структура підприємства
    Element Should Contain  //h5  Управління користувачами
    ${tr for user}  Set Variable  css=.ivu-table-body .ivu-table-row
    Page Should Contain Element  ${tr for user}


Відкрити сторінку "Звіти"
    Відкрити особистий кабінет
    Розкрити меню в особистому кабінеті
    Click Element  //*[contains(text(), "Звіти")]/ancestor::a
    Дочекатись закінчення загрузки сторінки
    Location Should Contain  /Reports
    Element Should Contain  //h1  Звіти
