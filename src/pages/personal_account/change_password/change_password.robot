*** Variables ***


*** Keywords ***
Перевірити сторінку
    Element Should Contain  //h1[@class="text-center"]  Зміна пароля
    Element Should Contain  (//*[@class="ivu-card-body"]//*[@class="ivu-form-item-label"])[1]  Поточний пароль
    Element Should Contain  (//*[@class="ivu-card-body"]//*[@class="ivu-form-item-label"])[2]  Новий пароль
    Element Should Contain  (//*[@class="ivu-card-body"]//*[@class="ivu-form-item-label"])[3]  Підтвердження нового пароля
    Page Should Contain Element  //*[@data-qa="change-password-new-btn"]