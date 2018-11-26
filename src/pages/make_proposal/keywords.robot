*** Settings ***
Resource  		../../common/loading/loading.robot



*** Variables ***
${cancel. offers confirm button}    ${block}[last()]//div[@class="ivu-poptip-footer"]/button[2]

${succeed}                          Пропозицію прийнято
${succeed2}                         Не вдалося зчитати пропозицію з ЦБД!
${empty error}                      ValueError: Element locator
${error1}                           Не вдалося подати пропозицію
${error2}                           Виникла помилка при збереженні пропозиції.
${error3}                           Непередбачувана ситуація
${error4}                           В даний момент вже йде подача/зміна пропозиції по тендеру від Вашої організації!
${error5}


*** Keywords ***
Скасувати пропозицію та вичитати відповідь
	Wait Until Page Contains Element  ${cancellation offers button}
	Click Element  ${cancellation offers button}
	Click Element   ${cancel. offers confirm button}
	Дочекатись закінчення загрузки сторінки
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


Перевірка на мультилот
  ${status}=  Run Keyword And Return Status  Wait Until Page Contains element  ${block}[2]//button
  Run Keyword If  '${status}'=='${True}'   Set Global Variable  ${multiple status}  multiple
  ...  ELSE  Set Global Variable  ${multiple status}  withoutlot
  [Return]  ${multiple status}
