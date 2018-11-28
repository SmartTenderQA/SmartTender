*** Variables ***


*** Keywords ***
Відкрити сторінку "Змінити пароль" (особистий кабінет) для provider
    Розкрити меню в особистому кабінеті
    Розгорнути під-меню в особистому кабінеті  //*[contains(text(), "Особисті дані")]/ancestor::a  //*[contains(text(), "Змінити пароль")]/ancestor::a
    Дочекатись Закінчення Загрузки Сторінки
    Element Should Contain  //h2  Зміна пароля
    Element Should Contain  (//*[@class="ivu-form-item-label"])[1]  Поточний пароль
    Element Should Contain  (//*[@class="ivu-form-item-label"])[2]  Новий пароль
    Page Should Contain Element  //button[@type="button" and contains(., "Змінити пароль")]


Відкрити сторінку "Змінити пароль" (особистий кабінет) для tender_owner
    Run Keyword If  '${site}' == 'test'
    ...  Click Element  xpath=//*[@title='${login}']
    Sleep  0.5
    Click Element  xpath=//*[.='Змінити свій пароль']
    Дочекатись Закінчення Загрузки Сторінки
    Page Should Contain Element  xpath=//*[.='Зміна пароля']
