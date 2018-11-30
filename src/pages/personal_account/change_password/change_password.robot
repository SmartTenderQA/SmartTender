*** Variables ***


*** Keywords ***
Перевірити сторінку
    Element Should Contain  //h2  Зміна пароля
    Element Should Contain  (//*[@class="ivu-form-item-label"])[1]  Поточний пароль
    Element Should Contain  (//*[@class="ivu-form-item-label"])[2]  Новий пароль
    Page Should Contain Element  //button[@type="button" and contains(., "Змінити пароль")]