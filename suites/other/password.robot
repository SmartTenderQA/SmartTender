*** Settings ***
Resource        ../../src/src.robot
Suite Setup     Precondition
Suite Teardown  Postcondition
Test Setup  	Stop The Whole Test Execution If Previous Test Failed
Test Teardown  Run Keyword If Test Failed  Run Keywords  Capture Page Screenshot
...  AND  Log Location


*** Variables ***
${new password}             qwerty12345
${submit btn locator}       xpath=//button[@type='button' and contains(@class,'btn-success')]


#zapusk
#robot --consolecolors on -L TRACE:INFO -d test_output -v role:provider -v where:$where suites/other/password.robot
#robot --consolecolors on -L TRACE:INFO -d test_output -v role:tender_owner -v where:$where suites/other/password.robot


*** Test Cases ***
Відновлення пароля через email
    [Tags]  reset_password
    Перейти на сторінку відновлення пароля
    Ввести mail в поле для відновлення паролю
    Wait Until Keyword Succeeds  3x  5  Відправити лист "Відновлення паролю" на пошту
    ${gmail}  email.Розпочати роботу з Gmail  ${user}
	${message}  email.Дочекатися отримання листа на пошту  ${gmail}  10m  SmartTender: Відновлення паролю
	${reset password href}  Отримати посилання з листа  ${message}
	Go To Smart  ${reset password href}
    Ввести новий пароль
    Go To  ${start_page}
    Переконатися що пароль змінено
    Авторизуватися з новим паролем  ${new password}
    Навести мишку на іконку з заголовку  Меню_користувача
	Натиснути  Змінити пароль
    Змінити пароль  ${new password}  ${password}


Перевірити можливість змінити пароль через особистий кабінет для організатора
    [Tags]  change_password
    Go To  ${start_page}
    Run Keyword If  '${role}' == 'tender_owner'  Run Keywords
    ...  Навести мишку на іконку з заголовку  Меню_користувача	AND
    ...  Натиснути  Вийти										AND
    ...  Авторизуватися  ${user}								AND
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


*** Keywords ***
Precondition
	${user}  Set Variable If
	...  "prod" in "${where}" and "${role}" == "provider"  prod_password_provider
	...  "prod" in "${where}" and "${role}" == "tender_owner"  prod_tender_owner
	...  "test" in "${where}" and "${role}" == "provider"  user4
	...  "test" in "${where}" and "${role}" == "tender_owner"  test_tender_owner
   	Set Global Variable  ${user}  ${user}
   	Open Browser In Grid  ${user}
   	Set Global Variable  ${login}  ${users_variables["${user}"]["login"]}
	Set Global Variable  ${password}  ${users_variables["${user}"]["password"]}
	${role}  Отримати дані користувача по полю  ${user}  role
	${name}  Отримати дані користувача по полю  ${user}  name
	Set Global Variable  ${role}
	Set Global Variable  ${name}


Postcondition
    Close All Browsers


Перевірити сторінку "Змінити пароль" для tender_owner
    Run Keyword If  '${site}' == 'test'
    ...  Click Element  xpath=//*[@title='${login}']
    Дочекатись закінчення загрузки сторінки(webclient)
    elements.Дочекатися відображення елемента на сторінці  //span[contains(text(),'Змінити свій пароль')]
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
    Click Element  //*[@data-qa="form-login-success"]
    notice.Дочекатись сповіщення з текстом  Невірний e-mail та/або пароль
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
	Відкрити вікно авторизації
	Click I forgot password


Ввести mail в поле для відновлення паролю
    ${forgot password input}  Set Variable  xpath=//div[@class='ivu-card-body']//input[@autocomplete="off"]
    elements.Дочекатися відображення елемента на сторінці  ${forgot password input}
    Input Text  ${forgot password input}  ${login}


Відправити лист "Відновлення паролю" на пошту
    Click Element  ${submit btn locator}
    Дочекатись Закінчення Загрузки Сторінки
    Page Should Contain Element  //*[text()='Перейдіть за посиланням в листі для відновлення пароля']


Ввести новий пароль
    Дочекатись Закінчення Загрузки Сторінки
    elements.Дочекатися відображення елемента на сторінці  //input[@placeholder='']
    Input Password  xpath=//input[@placeholder='']  ${new password}
    Click Element  ${submit btn locator}
    Дочекатись Закінчення Загрузки Сторінки
    Wait Until Page Contains  Пароль успішно змінений


Отримати посилання з листа
	[Arguments]  ${message}
	${content}  get_message_content  ${message}
	${href}  get_href_from_message  ${content}
	[Return]  ${href}
