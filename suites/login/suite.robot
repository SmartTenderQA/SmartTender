*** Settings ***
Resource        ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${forgot password locator}                  xpath=//*[@id="loginForm"]/h5/a
${forgot password link test}				https://test.smarttender.biz/Authentication/ForgotPassword/
${forgot password link prod}				https://smarttender.biz/Authentication/ForgotPassword/
${registration locator}                     xpath=//*[@id="login-modal"]//div[2]/p/a
${registration link test}					https://test.smarttender.biz/reestratsiya/
${registration link prod}					https://smarttender.biz/reestratsiya/


#Запуск
#robot --consolecolors on -L TRACE:INFO -d test_output -v where:prod suites/login/suite.robot


*** Test Cases ***
Спроба залогінитися з невірними даними
    [Template]  Login with wrong data
    empty  empty
    user1  empty
    empty  user1


Спроба залогінитися з невірними даними та вичитати відповідь
    [Template]  Login with wrong data and check message
    user1  user2
    deleted  deleted
    wrong user  wrong user


Перевірити лінку Я забув пароль
	Відкрити вікно авторизації
    Click I forgot password
    Go Back


Залогінитися та перевірити користувача
	Run Keyword  Залогінитися та перевірити користувача ${env}


*** Keywords ***
Precondition
	Run Keyword If  'prod' in '${where}'  Set Global Variable  ${env}  prod
	...  ELSE  Set Global Variable  ${env}  test
	Run Keyword If  'pre_prod' == '${where}'  Set Global Variable  ${IP}  iis
	Run Keyword  Open Browser In Grid  ${env}_viewer


Postcondition
    Close All Browsers


Login with wrong data
    [Arguments]  ${name1}  ${name2}
    Відкрити вікно авторизації
    Fill login  ${users_variables["${name1}"]["login"]}
    Fill password  ${users_variables["${name2}"]["password"]}
    Run Keyword And Expect Error  *  Click Log In
#	Close login window
	Go To Smart  ${start_page}

Login with wrong data and check message
    [Arguments]  ${name1}  ${name2}
    Відкрити вікно авторизації
    Fill login  ${users_variables["${name1}"]["login"]}
    Fill password  ${users_variables["${name2}"]["password"]}
    Click Element  //*[@data-qa="form-login-success"]
    notice.Дочекатись сповіщення з текстом  Невірний e-mail та/або пароль
	Close login window


Залогінитися та перевірити користувача test
	Login With Correct Data  user1					#role:provider
	Login With Correct Data  IT_RAV  				#role:tender_owner
	Login With Correct Data  ssp_tender_owner		#role:ssp_tender_owner


Залогінитися та перевірити користувача prod
	Login With Correct Data  prod_provider			#role:provider
	Run Keyword If  "iis" not in "${IP}"  Login With Correct Data  prod_owner  			#role:tender_owner
	Login With Correct Data  prod_ssp_owner			#role:ssp_tender_owner


Login with correct data
	[Arguments]  ${user}
	Go To Smart  ${start page}
    Авторизуватися  ${user}
    Reload and check
	start_page.Навести мишку на іконку з заголовку  Меню_користувача
	menu-user.Натиснути  Вийти


Reload and check
    Go To Smart  ${start page}
    Wait Until Page Contains  ${name}  10