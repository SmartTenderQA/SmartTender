*** Settings ***
Resource        ../../src/src.robot
Suite Setup     Precondition
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Run Keywords  Capture Page Screenshot
...  AND  Log Location


*** Variables ***
${new password}             qwerty12345
${submit btn locator}       xpath=//button[@type='button' and contains(@class,'btn-success')]


#zapusk
#robot --consolecolors on -L TRACE:INFO -d test_output -v hub:None -v user:prod_tender_owner suites/password/suite.robot
#
*** Test Cases ***
Перевірити можливість змінити пароль через особистий кабінет для організатора
    [Tags]  change_password
    Run Keyword If  '${role}' == 'tender_owner'  Run Keywords
    ...  Перевірити сторінку "Змінити пароль" для tender_owner  AND
    ...  Go To  ${start_page}


Змінити пароль користувача
    [Tags]  change_password
    Навести мишку на іконку з заголовку  Меню_користувача
	Натиснути  Змінити пароль
    Змінити пароль  ${password}  ${new password}
    Go To  ${start_page}
	start_page.Навести мишку на іконку з заголовку  Меню_користувача
	menu-user.Натиснути  Вийти
    Переконатися що пароль змінено
    Авторизуватися з новим паролем  ${new password}
    Навести мишку на іконку з заголовку  Меню_користувача
	Натиснути  Змінити пароль
    Змінити пароль  ${new password}  ${password}


Відновлення пароля через email
    [Tags]  reset_password
    Перейти на сторінку відновлення пароля
    Відправити лист "Відновлення паролю" на пошту
    Розпочати роботу з Gmail  ${user}
    Відкрити лист в email за темою  SmartTender: Відновлення паролю
    Перейти за посиланням в листі  Відновити пароль→
    Ввести новий пароль
    Go To  ${start_page}
    Переконатися що пароль змінено
    Авторизуватися з новим паролем  ${new password}
    Навести мишку на іконку з заголовку  Меню_користувача
	Натиснути  Змінити пароль
    Змінити пароль  ${new password}  ${password}


*** Keywords ***
Precondition
   	Open Browser In Grid  ${user}
   	Авторизуватися  ${user}
   	Set Global Variable  ${login}  ${users_variables["${user}"]["login"]}
	Set Global Variable  ${password}  ${users_variables["${user}"]["password"]}


Postcondition
    Close All Browsers


Перевірити сторінку "Змінити пароль" для tender_owner
    Run Keyword If  '${site}' == 'test'
    ...  Click Element  xpath=//*[@title='${login}']
    Wait Until Element Is Visible  //span[contains(text(),'Змінити свій пароль')]  10
    Sleep  0.5
    Click Element  //span[contains(text(),'Змінити свій пароль')]
    Дочекатись Закінчення Загрузки Сторінки
    Page Should Contain Element  xpath=//*[.='Зміна пароля']


Змінити пароль
    [Arguments]  ${old password}  ${new password}
    Input Password  xpath=(//input[@autocomplete])[1]  ${old password}
    Input Password  xpath=(//input[@autocomplete])[2]  ${new Password}
    Click Element  ${submit btn locator}
    Wait Until Page Contains Element  xpath=//div[contains(@class,'alert')]


Переконатися що пароль змінено
    Відкрити вікно авторизації
    Fill login  ${users_variables["${user}"]["login"]}
    Fill password  ${users_variables["${user}"]["password"]}
    Click Log In
    Дочекатись валідаційного повідомлення з текстом  Невірний e-mail та/або пароль
    Close login window


Авторизуватися з новим паролем
	[Arguments]  ${new password}
	Відкрити вікно авторизації
    Fill login  ${users_variables["${user}"]["login"]}
    Fill password  ${new password}
    Click Log In
    Run Keyword If  "tender_owner" == "${role}"
	...  Дочекатись закінчення загрузки сторінки(webclient)  ELSE
	...  Дочекатись закінчення загрузки сторінки
	Run Keyword If  "${role}" != "viewer" and "${role}" != "tender_owner"
	...  Wait Until Page Contains  ${name}  10
	Run Keyword If  "tender_owner" == "${role}"  Go To  ${start_page}


Перейти на сторінку відновлення пароля
	Go To  ${start_page}
    start_page.Навести мишку на іконку з заголовку  Меню_користувача
	menu-user.Натиснути  Вийти
	Відкрити вікно авторизації
	Click I forgot password


Відправити лист "Відновлення паролю" на пошту
    Input Password  xpath=//div[@class='ivu-card-body']//input[@autocomplete="off"]  ${login}
    Click Element  ${submit btn locator}
    Дочекатись Закінчення Загрузки Сторінки


Ввести новий пароль
    Дочекатись Закінчення Загрузки Сторінки
    Input Password  xpath=//input[@placeholder='']  ${new password}
    Click Element  ${submit btn locator}
    Wait Until Page Contains  Пароль успішно змінений
