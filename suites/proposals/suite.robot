*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Start  user1
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${multiple status}                   how_many_lots?
${error}                            xpath=.//*[@class='ivu-notice-notice ivu-notice-notice-closable ivu-notice-notice-with-desc']
${block without}                    .//*[@class='ivu-card ivu-card-bordered']
${amount}                           ${block}[2]//div[@class='amount lead'][1]
${proposal}                         http://test.smarttender.biz/bid/edit
${useful indicators open}           //span[@class='ivu-select-selected-value']
${useful indicators list}           //div[@class='ivu-select-dropdown']/ul[2]/li
${button add file}                  //input[@type="file"][1]
${choice file button}               //button[@data-toggle="dropdown"]
${file button path}                 //div[@class="file-container"]/div
${choice file list}                 //div[@class="dropdown open"]//li
${sub field}                        xpath=//*[@id="lotSubcontracting0"]/textarea[1]
${EDS}                              ${block}[1]//div[@class="ivu-row"]//button
${EDS close}                        xpath=//*[@class="modal-dialog "]//button
${cancellation offers button}       ${block}[last()]//div[@class="ivu-poptip-rel"]/button
${cancel. offers confirm button}    ${block}[last()]//div[@class="ivu-poptip-footer"]/button[2]
${delete file}                      //div[@class="file-container"]/div[last()]/div/div[2]
${delete file confirm}              /div/div[2]//button[2]
${switch}                           xpath=//*[@class="ivu-switch"]
${switch field}                     xpath=//*[@class="ivu-input-wrapper ivu-input-type"]/input
${wait}                             60


*** Test Cases ***
1 ПОДАННЯ ПРОПОЗИЦІЇ НА ${tender_form} ${tender_type}
  [Tags]   ${tender_type}  ${tender_form}
  No Operation

1.1 Знайти оголошену закупівлю
  [Tags]   ${tender_type}  ${tender_form}  smoke
  ${tender id}=  service.get_tender_variables  ${tender_form}  ${tender_type}
  Go To  ${proposal}/${tender id}/
  Скасувати пропозицію за необхідністю


1.2 Заповнити наступні обов’язкові поля по декількох лотах:
  [Tags]   ${tender_type}  ${tender_form}  smoke
  [Documentation]  checks if this page is what needed
  ...  counts number of lots
  ...  opens lots if multiple
  ${lots amount}  Порахувати Кількість Лотів
  ${multiple status}  Перевірка на мультилот
  Розгорнути усі лоти


1.2.1 Ціна (по кожному лоту окремо)
  [Tags]   ${tender_type}  ${tender_form}  smoke
  Run depending on the dict  Amount  Enter price LOOP
  Run Keyword If  "${tender_form}" == "ESCO"  Fill ESCO LOOP

1.2.2 Інші критерії (по кожному лоту окремо)
  [Tags]   ${tender_type}  ${tender_form}
  Stop depending on the dict or run  Useful indicators  Choice useful indicators LOOP

1.2.3 Підтвердження відповідності кваліфікаційним критеріям та відсутності підстав для відмови в участі (ст. 16 та ст. 17 Закону про публічні закупівлі)
  [Tags]   ${tender_type}  ${tender_form}  smoke
  Run depending on the dict  Conformity  Підтвердити відповідність

1.2.4 Додати файли
  [Tags]   ${tender_type}  ${tender_form}  smoke
  run keyword if  '${multiple status}'=='multiple'  Завантажити файли на весь тендер
  ...  ELSE  Створити та додати PDF файл  1

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
    Створити та додати PDF файл  1

1.2.4.7 Вадалити файл
    [Tags]   ${tender_type}  ${tender_form}
    Delete file  1

1.3 Зазначити інформацію про субпідрядника
    [Tags]   ${tender_type}  ${tender_form}  smoke
    run keyword if  '${multiple status}'=='multiple'  Run depending on the dict  Sub information  Add info about sub LOOP
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
    ${a}=  set variable if  '${multiple status}'=='multiple'  2  1
    Створити та додати PDF файл  ${a}

4.2 Подати пропозицію
    [Tags]   ${tender_type}  ${tender_form}
    Подати пропозицію

5 НАКЛАДАННЯ ЕЦП НА ВИПРАВЛЕНУ ПРОПОЗИЦІЮ
    [Tags]   ${tender_type}  ${tender_form}  EDS
    Sign EDS

6 СКАСУВАТИ ПРОПОЗИЦІЮ НА ПРОЦЕДУРУ/ЛОТ
    [Tags]   ${tender_type}  ${tender_form}  smoke
    Скасувати пропозицію

7 НЕМОЖЛИВІСТЬ ПОДАТИ ПРОПОЗИЦІЮ
    [Tags]   ${tender_type}  ${tender_form}  negative
    Run Keyword And Expect Error  *  Подати пропозицію

8 НЕМОЖЛИВІСТЬ НАКЛАСТИ ЕЦП
    [Tags]   ${tender_type}  ${tender_form}  negative
    Run Keyword And Expect Error  *  Sign EDS

*** Keywords ***
Postcondition
  Close All Browsers

###    Fill bid    ###
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
    \  Створити та додати PDF файл  1
    \  ${a}  set variable  ${INDEX}+1
    \  Choice type of file  1  ${INDEX}  ${a}

Choice type of file run
    run keyword if  '${multiple status}'=='multiple'  Choice type of file loop
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
Negative submit offer
  wait until page contains element  ${send offer button}
  click element  ${send offer button}
  wait until page contains element  ${error}  3


###    Confidentiality    ###
Confidentiality
    Click element  ${switch}

File description
    Input text  ${switch field}  ${some text}

###    Other    ###
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