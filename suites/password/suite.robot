*** Settings ***
Resource        ../../src/src.robot
Suite Setup     Precondition
Suite Teardown  Postcondition
Test Teardown   Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${new password}             qwerty12345
${submit btn locator}       xpath=//button[@type='button' and contains(@class,'btn-success')]


*** Test Cases ***
Перевірити можливість змінити пароль через особистий кабінет
    [Tags]  change_password
    Run Keyword  Перевірити сторінку "Змінити пароль" для ${role}


Змінити пароль користувача
    [Tags]  change_password
    Перейти до зміни пароля (вікно навігації)
    Змінити пароль  ${password}  ${new password}
	Завершити сеанс користувача
    Переконатися що пароль змінено
    Авторизуватися  ${login}  ${new password}
    Перейти до зміни пароля (вікно навігації)
    Змінити пароль  ${new password}  ${password}


Відновлення пароля через email
    [Tags]  reset_password
    Перейти на сторінку відновлення пароля
    Відправити лист "Відновлення паролю" на пошту
    Розпочати роботу з Gmail  ${user}
    Відкрити лист в email за темою  SmartTender: Відновлення паролю
    Перейти за посиланням в листі  Відновити пароль→
    Ввести новий пароль
    Переконатися що пароль змінено
    Авторизуватися  ${login}  ${new password}
    Перейти до зміни пароля (вікно навігації)
    Змінити пароль  ${new password}  ${password}


*** Keywords ***
Precondition
   	Start in grid  ${user}
   	Set Global Variable  ${login}  ${users_variables["${user}"]["login"]}
	Set Global Variable  ${password}  ${users_variables["${user}"]["password"]}


Postcondition
    Close All Browsers


Перейти до зміни пароля (вікно навігації)
  	Go To  ${start page}
    Click Element  xpath=//a[contains(text(),'Заходи SmartTender')]
    Click Element  xpath=//*[contains(@class,'fa-user')]
    Click Element  xpath=//*[contains(@class,'fa-key')]
    Page Should Contain  Зміна пароля


Перевірити сторінку "Змінити пароль" для provider
    start_page.Відкрити особистий кабінет
    personal_account.Відкрити сторінку за назвою  change_password


Перевірити сторінку "Змінити пароль" для tender_owner
    Run Keyword If  '${site}' == 'test'
    ...  Click Element  xpath=//*[@title='${login}']
    Sleep  0.5
    Click Element  xpath=//*[.='Змінити свій пароль']
    Дочекатись Закінчення Загрузки Сторінки
    Page Should Contain Element  xpath=//*[.='Зміна пароля']


Змінити пароль
    [Arguments]  ${old password}  ${new password}
    Input Password  xpath=(//input[@autocomplete])[1]  ${old password}
    Input Password  xpath=(//input[@autocomplete])[2]  ${new Password}
    Click Element  ${submit btn locator}
    Wait Until Page Contains Element  xpath=//div[contains(@class,'alert')]


Переконатися що пароль змінено
    ${status}  Run Keyword And Return Status  Авторизуватися  ${login}  ${password}
    Should Be Equal  ${status}  ${False}
    Go To  ${start page}


Перейти на сторінку відновлення пароля
    Завершити Сеанс Користувача
    Click Element  id=LoginAnchor
    Click Element  xpath=//div[@id='sm_content']//div[@class='forgot']/a
    Wait Until Page Contains Element  xpath=//div[@id='warningMessage']


Відправити лист "Відновлення паролю" на пошту
    Input Password  xpath=//div[@class='ivu-card-body']//input[@autocomplete="off"]  ${login}
    Click Element  ${submit btn locator}
    Дочекатись Закінчення Загрузки Сторінки


Ввести новий пароль
    Дочекатись Закінчення Загрузки Сторінки
    Input Password  xpath=//input[@placeholder='']  ${new password}
    Click Element  ${submit btn locator}