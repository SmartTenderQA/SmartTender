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
#robot --consolecolors on -L TRACE:INFO -d test_output -v env:prod suites/login/suite.robot
#robot --consolecolors on -L TRACE:INFO -d test_output -v env:test suites/login/suite.robot
*** Test Cases ***
Спроба залогінитися з невірними даними
    [Template]  Авторизуватися with wrong data
    empty  empty
    user1  empty
    empty  user1
    user1  user2
    deleted  deleted
    wrong user  wrong user


Перевірити лінки
    ${a}=  Get Element Attribute  ${forgot password locator}  href
    Should Be Equal  ${a}  ${forgot password link ${env}}
    ${a}=  Get Element Attribute  ${registration locator}  href
    Should Be Equal  ${a}  ${registration link ${env}}


Залогінитися та перевірити користувача
	Run Keyword  Залогінитися та перевірити користувача ${env}


*** Keywords ***
Precondition
	Run Keyword  Start  ${env}_viewer
	Click Element  ${events}
    Click Element  ${login link}
    Wait Until Page Contains Element  ${login field}  5


Postcondition
    Close All Browsers


Login with wrong data
    [Arguments]  ${name1}  ${name2}
    sleep  .2
    Fill login  ${users_variables["${name1}"]["login"]}
    Fill password  ${users_variables["${name2}"]["password"]}
    Click Element  ${login button}
    Wait Until Page Contains Element  ${error}  5


Залогінитися та перевірити користувача test
	Login With Correct Data  user1					#role:provider
	Login With Correct Data  IT_RAV  				#role:tender_owner
	Login With Correct Data  ssp_tender_owner		#role:ssp_tender_owner


Залогінитися та перевірити користувача prod
	Login With Correct Data  prod_provider			#role:provider
	Login With Correct Data  prod_owner  			#role:tender_owner
	Login With Correct Data  prod_ssp_owner			#role:ssp_tender_owner


Login with correct data
	[Arguments]  ${user}
	Go To  ${start page}
    ${login}  ${password}  Отримати дані користувача  ${user}
    Авторизуватися  ${login}  ${password}
    Reload and check
	Завершити сеанс користувача


Reload and check
    Go To  ${start page}
    Wait Until Page Contains  ${name}  10