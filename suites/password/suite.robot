*** Settings ***
Resource        ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${login}                    ${users_variables["${user}"]["login"]}
${password}                 ${users_variables["${user}"]["password"]}
${new password}             qwerty123
${submit btn locator}       xpath=//button[@type='button' and contains(@class,'btn-success')]

#Запуск
#robot --consolecolors on -L TRACE:INFO -d test_output -i change_password -v user:user4 suites/password/suite.robot
#robot --consolecolors on -L TRACE:INFO -d test_output -i reset_password -v user:user4 suites/password/suite.robot

*** Test Cases ***
Залогінитися та змінити пароль користувача
    [Tags]  change_password
    Перейти на сторінку зміни пароля
    Змінити пароль  ${password}  ${new password}
	Завершити сеанс користувача
    Переконатися в зміні пароля
  	Залогінитися  ${login}  ${new password}
    Перейти на сторінку зміни пароля
    Змінити пароль  ${new password}  ${password}
  	Завершити сеанс користувача


Відновлення пароля через email
    [Tags]  reset_password
    Завершити сеанс користувача
    Перейти на сторінку відновлення пароля
    Відправити лист на пошту
    email precondition  ${user}
    Відкрити лист в email  SmartTender: Відновлення паролю
    Перейти за посиланням в листі  Відновити пароль
    Відновити пароль
    Переконатися в зміні пароля
  	Залогінитися  ${login}  ${new password}
    Перейти на сторінку зміни пароля
    Змінити пароль  ${new password}  ${password}
  	Завершити сеанс користувача


*** Keywords ***
Precondition
	Run Keyword  Start  ${user}


Postcondition
    Close All Browsers


Залогінитися
	[Arguments]  ${login}  ${password}
	Go To  ${start page}
    Авторизуватися  ${login}  ${password}


Перейти на сторінку зміни пароля
    Click Element  id=LoginAnchor
    Wait Until Page Contains Element  id=main-menu
    Click Element  xpath=//*[@id="personalsettings"]/../..
    Click Element  xpath=//a[contains(@href,'ChangePassword')]
    Wait Until Page Contains Element  css=form


Змінити пароль
    [Arguments]  ${old password}  ${new password}
    Input Password  xpath=(//input[@autocomplete])[1]  ${old password}
    Input Password  xpath=(//input[@autocomplete])[2]  ${new Password}
    Click Element  ${submit btn locator}
    Wait Until Page Contains Element  xpath=//div[contains(@class,'alert')]


Переконатися в зміні пароля
  	Go To  ${start page}
    ${status}  Run Keyword And Return Status  Авторизуватися  ${login}  ${password}
    Should Be Equal  ${status}  ${False}


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
    Input Password  xpath=//input[@placeholder='']  ${new password}
    Click Element  ${submit btn locator}