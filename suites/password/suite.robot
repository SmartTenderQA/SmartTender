*** Settings ***
Resource        ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${login}                    ${users_variables["${user}"]["login"]}
${password}                 ${users_variables["${user}"]["password"]}
${new password}             qwerty12345
${submit btn locator}       xpath=//button[@type='button' and contains(@class,'btn-success')]

#Запуск
#robot --consolecolors on -L TRACE:INFO -d test_output -i change_password -v hub:None -v user:user4 suites/password/suite.robot
#robot --consolecolors on -L TRACE:INFO -d test_output -i change_password -v hub:None -v user:test_tender_owner suites/password/suite.robot
#robot --consolecolors on -L TRACE:INFO -d test_output -i reset_password -v hub:None -v user:user4 suites/password/suite.robot

*** Test Cases ***
Перевірити лінк на зміну пароля
    [Tags]  change_password
    Перейти до зміни пароля (вікно навігації)
    Go To  ${start page}
    Run Keyword  Перейти до зміни пароля (особистий кабінет) ${role}
    Go To  ${start page}


Змінити пароль користувача
    [Tags]  change_password
    Перейти до зміни пароля (вікно навігації)
    Змінити пароль  ${password}  ${new password}
	Завершити сеанс користувача
    Переконатися в зміні пароля
    Авторизуватися  ${login}  ${new password}
    Перейти до зміни пароля (вікно навігації)
    Змінити пароль  ${new password}  ${password}
  	Завершити сеанс користувача


Відновлення пароля через email
    [Tags]  reset_password
    Завершити сеанс користувача
    Перейти на сторінку відновлення пароля
    Відправити лист на пошту
    email precondition  ${user}
    Відкрити лист в email  SmartTender: Відновлення паролю
    Перейти за посиланням в листі  Відновити пароль→
    Відновити пароль
    Переконатися в зміні пароля
    Авторизуватися  ${login}  ${new password}
    Перейти до зміни пароля (вікно навігації)
    Змінити пароль  ${new password}  ${password}
  	Завершити сеанс користувача


*** Keywords ***
Precondition
	Run Keyword  Start in grid  ${user}
	Go To  ${start page}


Postcondition
    Close All Browsers


Перейти до зміни пароля (вікно навігації)
  	Go To  ${start page}
    Click Element  xpath=//a[contains(text(),'Заходи SmartTender')]
    Click Element  xpath=//*[contains(@class,'fa-user')]
    Click Element  xpath=//*[contains(@class,'fa-key')]
    Page Should Contain  Зміна пароля


Перейти до зміни пароля (особистий кабінет) provider
    Click Element  id=LoginAnchor
    Wait Until Page Contains Element  id=main-menu
    Click Element  xpath=//*[@id="personalsettings"]/../..
    Click Element  xpath=//*[contains(@class,'fa-key')]
    Page Should Contain  Зміна пароля


Перейти до зміни пароля (особистий кабінет) tender_owner
    Click Element  id=LoginAnchor
    Дочекатись Закінчення Загрузки Сторінки
    Run Keyword If  '${site}' == 'test'
    ...  Click Element  xpath=//*[@title='${login}']
    Sleep  0.5
    Click Element  xpath=//*[.='Змінити свій пароль']
    Дочекатись Закінчення Загрузки Сторінки
    Page Should Contain Element  xpath=//*[.='Зміна пароля']



Перейти на сторінку зміни пароля
    Click Element  xpath=//a[contains(text(),'Заходи SmartTender')]
    Click Element  xpath=//*[contains(@class,'fa-user')]
    Click Element  xpath=//*[contains(@class,'fa-key')]
    Wait Until Page Contains Element  css=form


Змінити пароль
    [Arguments]  ${old password}  ${new password}
    Input Password  xpath=(//input[@autocomplete])[1]  ${old password}
    Input Password  xpath=(//input[@autocomplete])[2]  ${new Password}
    Click Element  ${submit btn locator}
    Wait Until Page Contains Element  xpath=//div[contains(@class,'alert')]


Переконатися в зміні пароля
    ${status}  Run Keyword And Return Status  Авторизуватися  ${login}  ${password}
    Should Be Equal  ${status}  ${False}
    Go To  ${start page}


Перейти на сторінку відновлення пароля
    Click Element  id=LoginAnchor
    Click Element  xpath=//div[@id='sm_content']//div[@class='forgot']/a
    Wait Until Page Contains Element  xpath=//div[@id='warningMessage']


Відправити лист на пошту
    Input Password  xpath=//div[@class='ivu-card-body']//input[@autocomplete="off"]  ${login}
    Click Element  ${submit btn locator}
    Wait Until Page Contains  e-mail ${login}


Відновити пароль
    Select Window  New
    sleep  0.5
    Дочекатись Закінчення Загрузки Сторінки
    Input Password  xpath=//input[@placeholder='']  ${new password}
    Click Element  ${submit btn locator}