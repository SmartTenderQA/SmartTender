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
${ok button}                        //div[@class="ivu-modal-body"]/div[@class="ivu-modal-confirm"]//button
${ok button error}                  //*[@class='ivu-modal-content']//button[@class="ivu-btn ivu-btn-primary"]
${checkbox1}                        //*[@id="SelfEligible"]//input
${checkbox2}                        //*[@id="SelfQualified"]//input
${button add file}                  //input[@type="file"][1]
${file loading}                     css=div.loader
${cancellation offers button}       ${block}[last()]//div[@class="ivu-poptip-rel"]/button
${cancel. offers confirm button}    ${block}[last()]//div[@class="ivu-poptip-footer"]/button[2]


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
  Sleep  2


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


Перевірити кнопку подачі пропозиції
  [Arguments]  ${selector}=None
  ${button}  Run Keyword If  "${selector}" == "None"
  ...  Set Variable  xpath=//*[@class='show-control button-lot']|//*[@data-qa="bid-button"]
  ...  ELSE  Set Variable  ${selector}
  Додаткова перевірка на тестові торги для продуктива
  Page Should Contain Element  ${button}
  Open button  ${button}
  ${status}  Run Keyword And Return Status  Element Should Be Visible  //*[@class='modal-dialog ']//h4
  Run Keyword If  "${status}" == "True"  Pass Execution  Прийом пропозицій завершений!
  Location Should Contain  /edit/


Додаткова перевірка на тестові торги для продуктива
  ${status}  Run Keyword And Return Status  Location Should Contain  test.
  ${status2}  Run Keyword If  ${status} == ${False}  Run Keyword And Return Status  Element Should Contain  //*[@data-qa="title"]  [ТЕСТУВАННЯ]
  Run Keyword If  ${status2} == ${False}  Fatal Error  це не тестовий тендер [ТЕСТУВАННЯ]


Подати пропозицію
  ${message}  Натиснути надіслати пропозицію та вичитати відповідь
  Виконати дії відповідно повідомленню  ${message}
  Wait Until Page Does Not Contain Element  ${ok button}


Перевірити неможливість подати пропозицію
	${list}  Create List
	...  Необхідно прийняти участь хоча б в одному лоті
	...  Не усі поля заповнені правильно. Перевірте будь ласка та внесіть відповідні зміни
	Click Element  ${send offer button}
	${validation message}  Set Variable  css=.ivu-notice-desc
	Wait Until Page Contains Element  ${validation message}
	${text}  Get Text  ${validation message}
	Should Contain Any  ${list}  ${text}


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


Порахувати Кількість Лотів
  ${blocks amount}=  get matching xpath count  .//*[@class='ivu-card ivu-card-bordered']
  run keyword if  '${blocks amount}'<'3'
  ...  fatal error  Нету нужных елементов на странице(не та страница)
  ${lots amount}  evaluate  ${blocks amount}-2
  Set Global Variable  ${lots amount}
  Set Global Variable  ${blocks amount}
  [Return]  ${lots amount}


Перевірка на мультилот
  ${status}=  Run Keyword And Return Status  Wait Until Page Contains element  ${block}[2]//button
  Run Keyword If  '${status}'=='${True}'   Set Global Variable  ${multiple status}  multiple
  ...  ELSE  Set Global Variable  ${multiple status}  withoutlot
  [Return]  ${multiple status}


Розгорнути усі лоти
	:FOR  ${i}  IN RANGE  1  ${lots amount}+1
	\  Розгорнути лот  ${i}


Розгорнути лот
	[Arguments]  ${lot}
	${status}  Run Keyword And Return Status  Page Should Contain Element  ${block}[${lot}+1]//button/i
	${class}  Run Keyword If  ${status} == ${True}  Get Element Attribute  ${block}[${lot}+1]//button/i  class
	Run Keyword If  "checkmark" not in "${class}" and ${status} == ${True}  Click Element  ${block}[${lot}+1]//button


Підтвердити відповідність
  Click Element  ${checkbox1}
  Click Element  ${checkbox2}


Створити та додати PDF файл
  [Documentation]  if ${lot} == 0 add file to tender overall
  [Arguments]  ${lot}
  ${lot}  Evaluate  ${lot}+1
  ${path}  create_pdf_file
  Choose File  xpath=(${button add file})[${lot}]  ${EXECDIR}/${path}
  ${status}  ${message}  Run Keyword And Ignore Error  Wait Until Page Contains Element  ${file loading}  3
  Run Keyword If  "${status}" == "PASS"  Run Keyword And Ignore Error  Wait Until Page Does Not Contain Element  ${file loading}


Завантажити файли на весь тендер
  :FOR  ${INDEX}  IN RANGE  0  ${lots amount}+1
  \  Створити та додати PDF файл  ${INDEX}
