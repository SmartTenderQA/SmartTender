*** Settings ***
Library  Selenium2Library
Library  BuiltIn
Library  DebugLibrary
Library  service.py


*** Variables ***
                                    ###ІНШІ ДАННІ###
${browser}                          chrome
${start_page}                       http://test.smarttender.biz
${file path}                        src/
${some text}                        Це_тестовый_текст_для_тестування._Це_тестовый_текст_для_тестування._Це_тестовый_текст_для_тестування.

                                    ###ЛОКАТОРИ###
${block}                            xpath=.//*[@class='ivu-card ivu-card-bordered']
${send offer button}                css=button#submitBidPlease
${login button}                     xpath=//*[@id="loginForm"]/button[2]
${logout}                           id=LogoutBtn
${login link}                       id=SignIn
${events}                           xpath=//*[@id="LoginDiv"]//a[2]
${login field}                      id=login
${password field}                   id=password
${error}                            id=loginErrorMsg

${succeed}                          Пропозицію прийнято
${succeed2}                         Не вдалося зчитати пропозицію з ЦБД!
${empty error}                      ValueError: Element locator
${error1}                           Не вдалося подати пропозицію
${error2}                           Виникла помилка при збереженні пропозиції.
${error3}                           Непередбачувана ситуація
${cancellation succeed}             Пропозиція анульована.
${cancellation error1}              Не вдалося анулювати пропозицію.
${validation message}               css=.ivu-modal-content .ivu-modal-confirm-body>div:nth-child(2)
${ok button}                        xpath=.//div[@class="ivu-modal-body"]/div[@class="ivu-modal-confirm"]//button
${ok button error}                  xpath=.//*[@class='ivu-modal-content']//button[@class="ivu-btn ivu-btn-primary"]


${link to make proposal button}     css=[class='show-control button-lot']
${iframe open tender}               xpath=.//div[@class="container"]/iframe
${make proposal button}             xpath=//*[@id="tenderPage"]//a[@class='btn button-lot cursor-pointer']
${make proposal button new}         xpath=//*[@id="tenderDetail"]//a[@class="show-control button-lot"]
${komertsiyni-torgy icon}           xpath=//*[@id="main"]//a[2]/img
${derzavni zakupku}                 xpath=//*[@id="MainMenuTenders"]//ul[1]/li[2]/a
${first element find tender}        xpath=//*[@id="tenders"]//tr[1]/td[2]/a

${bread crumbs}                     xpath=(//*[@class='ivu-breadcrumb-item-link'])

${loading}                          css=.smt-load .box
${webClient loading}                id=LoadingPanel

*** Keywords ***
Start
  Open Browser  ${start_page}  ${browser}  alies

Login
  [Arguments]  ${user}
  Відкрити вікно авторизації
  Авторизуватися  ${user}
  Перевірити успішність авторизації  ${user}

Відкрити вікно авторизації
  Click Element  ${events}
  Click Element  ${login link}
  Sleep  2

Авторизуватися
  [Arguments]  ${user}
  ${login}=  get_user_variable  ${user}  login
  ${password}=  get_user_variable  ${user}  password
  Fill Login  ${login}
  Fill Password  ${password}
  Click Element  ${login button}
  Run Keyword If  '${role}' == 'Bened'
  ...       Wait Until Element Is Not Visible  ${webClient loading}  120
  ...  ELSE  Run Keywords
  ...       Run Keyword And Ignore Error  Wait Until Page Contains Element  ${loading}
  ...  AND  Run Keyword And Ignore Error  Wait Until Page Does Not Contain Element  ${loading}  120

Перевірити успішність авторизації
  [Arguments]  ${user}
  Run Keyword If  '${role}' == 'Bened'  Перевірити успішність авторизації організатора
  ...  ELSE  Перевірити успішність авторизації учасника  ${user}

Перевірити успішність авторизації організатора
  Wait Until Page Does Not Contain Element  ${login button}
  Location Should Contain  /webclient/
  Wait Until Page Contains Element  css=.body-container #container
  Go To  ${start_page}

Перевірити успішність авторизації учасника
  [Arguments]  ${user}
  Wait Until Page Does Not Contain Element  ${login button}
  ${name}=  get_user_variable  ${user}  name
  Set Global Variable  ${name}
  Wait Until Page Contains  ${name}  10
  Go To  ${start_page}

Fill login
  [Arguments]  ${user}
  Input Password  ${login field}  ${user}

Fill password
  [Arguments]  ${pass}
  Input Password  ${password field}  ${pass}

Open button
  [Documentation]   відкривае лінку з локатора у поточному вікні
  [Arguments]  ${selector}
  ${a}=  Get Element Attribute  ${selector}  href
  Go To  ${a}

Заповнити поле з ціною
  [Documentation]  takes lot number and coefficient
  ...  fill bid field with max available price
  [Arguments]  ${lot number}  ${coefficient}
  ${block number}  Set Variable  ${lot number}+1
  ${a}=  Get Text  ${block}[${block number}]//div[@class='amount lead'][1]
  ${a}=  get_number  ${a}
  ${amount}=  Evaluate  int(${a}*${coefficient})
  ${field number}=  Evaluate  ${lot number}-1
  Input Text  xpath=//*[@id="lotAmount${field number}"]/input[1]  ${amount}

Скасувати пропозицію
  ${message}  Скасувати пропозицію та вичитати відповідь
  Виконати дії відповідно повідомленню при скасуванні  ${message}
  Wait Until Page Does Not Contain Element   ${cancellation offers button}

Скасувати пропозицію та вичитати відповідь
  Wait Until Page Contains Element  ${cancellation offers button}
  Click Element  ${cancellation offers button}
  Click Element   ${cancel. offers confirm button}
  Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${loading}  600
  ${status}  ${message}  Run Keyword And Ignore Error  Get Text  ${validation message}
  [Return]  ${message}

Виконати дії відповідно повідомленню при скасуванні
  [Arguments]  ${message}
  Run Keyword If  """${message}""" == "${EMPTY}"  Fail  Message is empty
  ...  ELSE IF  "${cancellation error1}" in """${message}"""  Ignore cancellation error
  ...  ELSE IF  "${cancellation succeed}" in """${message}"""  Click Element  ${ok button}
  ...  ELSE  Fail  Look to message above

Ignore cancellation error
  Click Element  ${ok button}
  Wait Until Page Does Not Contain Element  ${ok button}
  Sleep  20
  Скасувати пропозицію

Скасувати пропозицію за необхідністю
  ${status}  Run Keyword And Return Status  Wait Until Page Contains Element  ${cancellation offers button}
  Run Keyword If  '${status}' == '${True}'  Скасувати пропозицію

Подати пропозицію
  ${message}  Натиснути надіслати пропозицію та вичитати відповідь
  Виконати дії відповідно повідомленню  ${message}
  Wait Until Page Does Not Contain Element  ${ok button}

Натиснути надіслати пропозицію та вичитати відповідь
  Click Element  ${send offer button}
  Run Keyword And Ignore Error  Wait Until Page Contains Element  ${loading}
  Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${loading}  600
  ${status}  ${message}  Run Keyword And Ignore Error  Get Text  ${validation message}
  Capture Page Screenshot  ${OUTPUTDIR}/my_screen{index}.png
  [Return]  ${message}

Виконати дії відповідно повідомленню
  [Arguments]  ${message}
  Run Keyword If  "${empty error}" in """${message}"""  Подати пропозицію
  ...  ELSE IF  "${error1}" in """${message}"""  Ignore error
  ...  ELSE IF  "${error2}" in """${message}"""  Ignore error
  ...  ELSE IF  "${error3}" in """${message}"""  Ignore error
  ...  ELSE IF  "${succeed}" in """${message}"""  Click Element  ${ok button}
  ...  ELSE IF  "${succeed2}" in """${message}"""  Click Element  ${ok button}
  ...  ELSE  Fail  Look to message above

Ignore error
  Click Element  ${ok button}
  Wait Until Page Does Not Contain Element  ${ok button}
  Sleep  30
  Подати пропозицію

Відкрити сторінку тестових торгів
  Mouse Over  ${button komertsiyni-torgy}
  Click Element  ${dropdown navigation}[href='/test-tenders/']

Дочекатись закінчення загрузки сторінки
  Run Keyword And Ignore Error  Wait Until Page Contains Element  ${loading}
  Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${loading}