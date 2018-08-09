*** Settings ***
Library     service.py


*** Variables ***
${send offer button}                css=button#submitBidPlease

${succeed}                          Пропозицію прийнято
${succeed2}                         Не вдалося зчитати пропозицію з ЦБД!
${empty error}                      ValueError: Element locator
${error1}                           Не вдалося подати пропозицію
${error2}                           Виникла помилка при збереженні пропозиції.
${error3}                           Непередбачувана ситуація
${error4}                           В даний момент вже йде подача/зміна пропозиції по тендеру від Вашої організації!
${cancellation succeed}             Пропозиція анульована.
${cancellation error1}              Не вдалося анулювати пропозицію.
${validation message}               css=.ivu-modal-content .ivu-modal-confirm-body>div:nth-child(2)
${ok button}                        xpath=.//div[@class="ivu-modal-body"]/div[@class="ivu-modal-confirm"]//button
${ok button error}                  xpath=.//*[@class='ivu-modal-content']//button[@class="ivu-btn ivu-btn-primary"]

*** Keywords ***
Відкрити сторінку подачі пропозиції
  ${location}  Get Location
  Run Keyword If  '/bid/' not in '${location}'  Run Keywords
  ...  Reload Page
  ...  AND  Click Element  xpath=//*[contains(text(), 'Подача пропозиції') or contains(text(), 'Змінити пропозицію')]
  ...  AND  Wait Until Page Contains Element  xpath=//button/*[contains(text(), 'Надіслати пропозицію')]


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
  Run Keyword And Ignore Error  Wait Until Page Contains Element  ${loading}
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
  ...  ELSE IF  "${error4}" in """${message}"""  Ignore error
  ...  ELSE IF  "${succeed}" in """${message}"""  Click Element  ${ok button}
  ...  ELSE IF  "${succeed2}" in """${message}"""  Click Element  ${ok button}
  ...  ELSE  Fail  Look to message above


Ignore error
  Click Element  ${ok button}
  Wait Until Page Does Not Contain Element  ${ok button}
  Sleep  30
  Подати пропозицію