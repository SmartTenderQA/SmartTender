*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${number of lots}                   how_many_lots?
${block}                            xpath=.//*[@class='ivu-card ivu-card-bordered']
${error}                            xpath=.//*[@class='ivu-notice-notice ivu-notice-notice-closable ivu-notice-notice-with-desc']
${xpath}                            xpath=//*
${block without}                    .//*[@class='ivu-card ivu-card-bordered']
${amount}                           ${block}[2]//div[@class='amount lead'][1]
${proposal}                         http://test.smarttender.biz/bid/edit
${useful indicators open}           //span[@class='ivu-select-selected-value']
${useful indicators list}           //div[@class='ivu-select-dropdown']/ul[2]/li
${checkbox1}                        xpath=//*[@id="SelfEligible"]//input
${checkbox2}                        xpath=//*[@id="SelfQualified"]//input
${button add file}                  //input[@type="file"][1]
${choice file button}               //button[@data-toggle="dropdown"]
${file button path}                 //div[@class="file-container"]/div
${choice file list}                 //div[@class="dropdown open"]//li
${sub field}                        xpath=//*[@id="lotSubcontracting0"]/textarea[1]
${send offer button}                css=button#submitBidPlease
${ok button}                        xpath=.//div[@class="ivu-modal-body"]/div[@class="ivu-modal-confirm"]//button
${ok button error}                  xpath=.//*[@class='ivu-modal-content']//button[@class="ivu-btn ivu-btn-primary"]
${EDS}                              ${block}[1]//div[@class="ivu-row"]//button
${EDS close}                        xpath=//*[@class="modal-dialog "]//button
${cancellation offers button}       ${block}[last()]//div[@class="ivu-poptip-rel"]/button
${cancel. offers confirm button}    ${block}[last()]//div[@class="ivu-poptip-footer"]/button[2]
${delete file}                      //div[@class="file-container"]/div[last()]/div/div[2]
${delete file confirm}              /div/div[2]//button[2]
${switch}                           xpath=//*[@class="ivu-switch"]
${switch field}                     xpath=//*[@class="ivu-input-wrapper ivu-input-type"]/input
${validation message}               css=.ivu-modal-content .ivu-modal-confirm-body>div:nth-child(2)

${succeed}                          Пропозицію прийнято
${succeed2}                         Не вдалося зчитати пропозицію з ЦБД!
${empty error}                      ValueError: Element locator
${error1}                           Не вдалося подати пропозицію
${error2}                           Виникла помилка при збереженні пропозиції.
${error3}                           Непередбачувана ситуація
${cancellation succeed}             Пропозиція анульована.
${cancellation error1}              Не вдалося анулювати пропозицію.

${file loading}                     css=div.loader
${wait}                             60



*** Test Cases ***
1 ПОДАННЯ ПРОПОЗИЦІЇ НА ${tender_form} ${tender_type}
  [Tags]   ${tender_type}  ${tender_form}
  No Operation

1.1 Знайти оголошену закупівлю
  [Tags]   ${tender_type}  ${tender_form}  smoke
  ${tender id}=  service.get_tender_variables  ${tender_form}  ${tender_type}
  Go To  ${proposal}/${tender id}/
  ${status}  Run Keyword And Return Status  Wait Until Page Contains Element  ${cancellation offers button}
  Run Keyword If  '${status}' == '${True}'  Cancellation offer
  ${status}=  Run Keyword And Return Status  Wait Until Page Contains element  ${block}[2]//button
  Run Keyword If  '${status}'=='${True}'   Set Global Variable  ${number of lots}  multiple
  ...  ELSE  Set Global Variable  ${number of lots}  withoutlot

1.2 Заповнити наступні обов’язкові поля по декількох лотах:
  [Tags]   ${tender_type}  ${tender_form}  smoke
  [Documentation]  checks if this page is what needed
  ...  counts number of lots
  ...  opens lots if multiple
  ${blocks amount}=  get matching xpath count  .//*[@class='ivu-card ivu-card-bordered']
  run keyword if  '${blocks amount}'<'3'
  ...  fatal error  Нету нужных елементов на странице(не та страница)
  ${lots amount}  evaluate  ${blocks amount}-2
  set suite variable  ${lots amount}
  set suite variable  ${blocks amount}
  run keyword if  '${number of lots}' == 'withoutlot'  Pass Execution  this is one lot tender
  Collaps Loop

1.2.1 Ціна (по кожному лоту окремо)
  [Tags]   ${tender_type}  ${tender_form}  smoke
  Run depending on the dict  Amount  Enter price LOOP
  Run Keyword If  "${tender_form}" == "ESCO"  Fill ESCO LOOP

1.2.2 Інші критерії (по кожному лоту окремо)
  [Tags]   ${tender_type}  ${tender_form}
  Stop depending on the dict or run  Useful indicators  Choice useful indicators LOOP

1.2.3 Підтвердження відповідності кваліфікаційним критеріям та відсутності підстав для відмови в участі (ст. 16 та ст. 17 Закону про публічні закупівлі)
  [Tags]   ${tender_type}  ${tender_form}  smoke
  Run depending on the dict  Conformity  Check boxes

1.2.4 Додати файли
  [Tags]   ${tender_type}  ${tender_form}  smoke
  run keyword if  '${number of lots}'=='multiple'  Add file loop
  ...  ELSE  Add file to ...  1  _First.txt

1.2.4.1 Обрати типи файлів (до закупівлі в цілому, або по кожному лоту окремо)
   [Tags]   ${tender_type}  ${tender_form}
   Run depending on the dict  Document type  Choice type of file run

1.2.4.2 Перевірити кількість типів файлів
  [Tags]   ${tender_type}  ${tender_form}
  Run depending on the dict  Document type  Verify the number of file types

1.2.4.3 Вибрати усі доспупні типи файлів
  [Tags]   ${tender_type}  ${tender_form}
  Run depending on the dict  Document type  Choice all type of files

1.2.4.4 Визначити файлы як конфіденційні
  [Tags]   ${tender_type}  ${tender_form}  smoke
  Run depending on the dict  Confidentiality  Confidentiality

1.2.4.5 Зазначивши причину конфіденційності
  [Tags]   ${tender_type}  ${tender_form}  smoke
  Run depending on the dict  Description  File description

1.2.4.6 Додати другий файл
    [Tags]   ${tender_type}  ${tender_form}
    Add file to ...  1  _Second.txt

1.2.4.7 Вадалити файл
    [Tags]   ${tender_type}  ${tender_form}
    Delete file  1

1.3 Зазначити інформацію про субпідрядника
    [Tags]   ${tender_type}  ${tender_form}  smoke
    run keyword if  '${number of lots}'=='multiple'  Run depending on the dict  Sub information  Add info about sub LOOP
    ...  ELSE  Run depending on the dict  Sub information  omg this robot...

2 ПОДАТИ ПРОПОЗИЦІЮ
    [Tags]   ${tender_type}  ${tender_form}  smoke
    Подати пропозицію

3 НАКЛАДАННЯ ЕЦП
    [Tags]   ${tender_type}  ${tender_form}
    Sign EDS

4 ВНЕСТИ ЗМІНИ ДО ПРОПОЗИЦІЇ
    [Tags]   ${tender_type}  ${tender_form}
    no operation

4.1 Внести наступні зміни по одному з лотів
    [Tags]   ${tender_type}  ${tender_form}
    [Documentation]  for first lot
    no operation

4.1.1 Ціна
    [Tags]   ${tender_type}  ${tender_form}
    Run depending on the dict  Amount  Price again

4.1.2 Інші критерії
    [Tags]   ${tender_type}  ${tender_form}
    Useful indicators  2  1

4.1.3 Додати нові файли
    [Tags]   ${tender_type}  ${tender_form}
    ${a}=  set variable if  '${number of lots}'=='multiple'  2  1
    Add file to ...  ${a}  _Second.txt

4.2 Подати пропозицію
    [Tags]   ${tender_type}  ${tender_form}
    Подати пропозицію

5 НАКЛАДАННЯ ЕЦП НА ВИПРАВЛЕНУ ПРОПОЗИЦІЮ
    [Tags]   ${tender_type}  ${tender_form}  EDS
    Sign EDS

6 СКАСУВАТИ ПРОПОЗИЦІЮ НА ПРОЦЕДУРУ/ЛОТ
    [Tags]   ${tender_type}  ${tender_form}  smoke
    Cancellation offer

7 НЕМОЖЛИВІСТЬ ПОДАТИ ПРОПОЗИЦІЮ
    [Tags]   ${tender_type}  ${tender_form}  negative
    Run Keyword And Expect Error  *  Подати пропозицію

8 НЕМОЖЛИВІСТЬ НАКЛАСТИ ЕЦП
    [Tags]   ${tender_type}  ${tender_form}  negative
    Run Keyword And Expect Error  *  Sign EDS

*** Keywords ***
Precondition
  Start
  Login  user1

Postcondition
  Close All Browsers

###    Collaps    ###
Collaps Loop
    [Documentation]  expand all lots
    sleep  1
    :FOR  ${INDEX}  IN RANGE  ${lots amount}
    \  ${n}  evaluate  ${INDEX}+2
    \  click element  ${block}[${n}]//button

###    Fill bid    ###
Заповнити поле з ціною
    [Documentation]  takes lot number and coefficient
    ...  fill bid field with max available price
    [Arguments]  ${lot number}  ${coefficient}
    ${block number}  set variable  ${lot number}+1
    ${a}=  get text  ${block}[${block number}]//div[@class='amount lead'][1]
    ${a}=  get_number  ${a}
    ${amount}=  evaluate  int(${a}*${coefficient})
    ${field number}=  evaluate  ${lot number}-1
    input text  ${xpath}[@id="lotAmount${field number}"]/input[1]  ${amount}

Enter price LOOP
    :FOR  ${INDEX}  IN RANGE  ${lots amount}
    \  ${lot number}  evaluate  ${INDEX}+1
    \  Заповнити поле з ціною  ${lot number}  1

###    ESCO    ###
Fill ESCO
    [Arguments]   ${block number}
    input text  xpath=(${block without}[${block number}]//input)[1]  1
    input text  xpath=(${block without}[${block number}]//input)[2]  0
    input text  xpath=(${block without}[${block number}]//input)[3]  95
    input text  xpath=(${block without}[${block number}]//input)[6]  100

Fill ESCO LOOP
    :FOR  ${INDEX}  IN RANGE  2  ${lots amount}+2
    \  Fill ESCO  ${INDEX}

###    Useful indicators    ###
Useful indicators
    [Documentation]  takes block number and list number
    [Arguments]  ${block number}  ${list number}
    ${passed}=  run keyword and return status  wait until page contains element  ${block}[${block number}]${useful indicators open}  1
    run keyword if  ${passed}==${True}  click element  ${block}[${block number}]${useful indicators open}
    run keyword if  ${passed}==${True}  sleep  .5
    run keyword if  ${passed}==${True}  click element  ${block}[${block number}]${useful indicators list}[${list number}]

Choice useful indicators LOOP
    ${count}  evaluate  ${lots amount}+2
    :FOR  ${INDEX}  IN RANGE  1  ${count}
    \  Useful indicators  ${INDEX}  last()


###    Add File    ###
Add file to ...
    [Documentation]  takes block number and file name
    [Arguments]  ${add_file_number}  ${file_name}
    choose File  xpath=(${button add file})[${add_file_number}]  ${EXECDIR}/suites/proposals/upload_files/${file_name}
    Run Keyword And Ignore Error  Wait Until Page Contains Element  ${file loading}
    Run Keyword And Ignore Error  Wait Until Page Does Not Contain Element  ${file loading}

Add file LOOP
    ${count}  evaluate  ${lots amount}+2
    :FOR  ${INDEX}  IN RANGE  1  ${count}
    \  Add file to ...  ${INDEX}  _First.txt

Delete file
    [Documentation]  deleta last file
    [Arguments]  ${block number}
    wait until page contains element  ${block}[${block number}]${delete file}//button
    click element  ${block}[${block number}]${delete file}//button
    wait until page contains element  ${block}[${block number}]${delete file}${delete file confirm}
    click element  ${block}[${block number}]${delete file}${delete file confirm}

###    Choice type of file     ###
Choice type of file
    [Documentation]  takes
    ...  block number
    ...  number from list
    ...  file number
    [Arguments]  ${block number}  ${type of file number}  ${file number}
    ${file number}  evaluate  ${file number}+1
    click element  ${block}[${block number}]${file button path}[${file number}]${choice file button}
    click element  ${block}${choice file list}[${type of file number}]

Choice type of file loop
    [Documentation]  choice last type of file for all lost and tender
    ${lots amount}  evaluate  ${lots amount}+2
    :FOR  ${INDEX}  IN RANGE  1  ${lots amount}
    \  Choice type of file  ${INDEX}  last()  1
    \  sleep  .5

Get number of file types from dict
    ${list of type files}=  get_tender_variables  ${tender_form}  Document type list
    ${number of file types}  evaluate  str(len(${list of type files}))
    set global variable  ${number of file types}

Verify the number of file types
    sleep  1
    Get number of file types from dict
    click element  ${block}[1]${choice file button}
    ${count}=  get matching xpath count  .//*[@class='ivu-card ivu-card-bordered']//div[@class="dropdown open"]//li
    should be equal  ${number of file types}  ${count}
    click element  ${block}[1]${choice file button}

Choice all type of files
    Get number of file types from dict
    :FOR  ${INDEX}  IN RANGE  1  ${number of file types}
    \  Add file to ...  1  ${INDEX}.txt
    \  ${a}  set variable  ${INDEX}+1
    \  Choice type of file  1  ${INDEX}  ${a}

Choice type of file run
    run keyword if  '${number of lots}'=='multiple'  Choice type of file loop
    ...  ELSE  Choice type of file  1  last()  1

###    Add info    ###
Add info about sub
    [Arguments]  ${block number}
    input text  ${block}[${block number}]//textarea  ${some text}

Add info about sub LOOP
    :FOR  ${INDEX}  INRANGE  2  ${lots amount}+2
    \  Add info about sub  ${index}

omg this robot...
    Add info about sub  2

###    Submit    ###
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

Negative submit offer
  wait until page contains element  ${send offer button}
  click element  ${send offer button}
  wait until page contains element  ${error}  3

Cancellation offer
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
  Cancellation offer


###    Confidentiality    ###
Confidentiality
    Click element  ${switch}

File description
    Input text  ${switch field}  ${some text}

###    Other    ###
Check boxes
    click element  ${checkbox1}
    click element  ${checkbox2}

Sign EDS
  ${passed}=  Run Keyword And Return Status  Wait Until Page Contains Element  ${EDS}[2]
  sleep  2
  Run keyword if   "${passed}" == "${True}"  Click element  ${EDS}[2]
  ...  ELSE  Click element  ${EDS}[1]
  Wait Until Page Contains Element  ${EDS close}
  Wait Until Page Contains Element  ${EDS close}  20
  Run again  ${EDS close}

Run again
  [Arguments]  ${element}
  run keyword and ignore error  Click element  ${element}
  ${passed}=  Run Keyword And Return Status  wait until page does not contain element  ${element}
  Run keyword if   "${passed}" == "${False}"  Run again  ${element}

Run depending on the dict
    [Arguments]  ${tender_sign}  ${keyword}
    ${variable}  get_tender_variables  ${tender_form}  ${tender_sign}
    ${status}=  run keyword and return status  ${keyword}
    should be equal  ${status}  ${variable}

Stop depending on the dict or run
    [Arguments]  ${tender_sign}  ${keyword}
    ${variable}  get_tender_variables  ${tender_form}  ${tender_sign}
    run keyword if  '${variable}'=='${False}'  Pass Execution  doesn't work for this tender type
    ${status}=  run keyword and return status  ${keyword}
    should be equal  ${status}  ${variable}

Price again
    Заповнити поле з ціною  1  0.9