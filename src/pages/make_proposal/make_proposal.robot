*** Settings ***
Resource  			keywords.robot


*** Variables ***
${send offer button}                css=button#submitBidPlease
${cancellation succeed}             Пропозиція анульована.
${cancellation error1}              Не вдалося анулювати пропозицію.
${validation message}               //*[@class="ivu-modal-content"]//*[@class="ivu-modal-confirm-body"]//div[text()]
${ok button}                        //div[@class="ivu-modal-body"]/div[@class="ivu-modal-confirm"]//button
${ok button error}                  //*[@class='ivu-modal-content']//button[@class="ivu-btn ivu-btn-primary"]
${checkbox1}                        //*[@id="SelfEligible"]//input
${checkbox2}                        //*[@id="SelfQualified"]//input
${button add file}                  //input[@type="file"][1]
${file loading}                     css=div.loader

${cancellation offers button}       '${block}'[last()]//div[@class="ivu-poptip-rel"]/button



*** Keywords ***
Подати пропозицію
	${message}  Натиснути надіслати пропозицію та вичитати відповідь
	Виконати дії відповідно повідомленню  ${message}
	Wait Until Page Does Not Contain Element  ${ok button}


Перевірити неможливість подати пропозицію
	${list}  Create List
	...  Необхідно прийняти участь хоча б в одному лоті
	...  Не усі поля заповнені правильно. Перевірте будь ласка та внесіть відповідні зміни
	Wait Until Element Is Visible  ${send offer button}
	Click Element  ${send offer button}
	Run Keyword If  "${tender_type}" == "open_trade_eng"
	...  keywords.Закрити валідаційне вікно (Так/Ні)  Рекомендуємо Вам для файлів з ціновою пропозицією обрати тип  Ні
	${text}  Вичитати відповіди з валідаційного вікна при негативній подачі пропозиціїї
	Should Contain Any  ${list}  ${text}


Скасувати пропозицію
	${message}  Скасувати пропозицію та вичитати відповідь
	Виконати дії відповідно повідомленню при скасуванні  ${message}
	Wait Until Page Does Not Contain Element   ${cancellation offers button}


Скасувати пропозицію за необхідністю
	${status}  Run Keyword And Return Status  Wait Until Page Contains Element  ${cancellation offers button}
	Run Keyword If  '${status}' == '${True}'  Скасувати пропозицію


Порахувати Кількість Лотів
	${blocks amount}=  get matching xpath count  //*[@class='ivu-card ivu-card-bordered']
	Run Keyword If  ${blocks amount} < 3
	...  fatal error  Нету нужных елементов на странице(не та страница)
	${lots amount}  evaluate  ${blocks amount}-2
	Set Global Variable  ${lots amount}
	Set Global Variable  ${blocks amount}
	[Return]  ${lots amount}


Розгорнути лот
	[Arguments]  ${lot}
	${status}  Run Keyword And Return Status  Page Should Contain Element  ${block}[${lot}+1]//button/i
	${class}  Run Keyword If  ${status} == ${True}  Get Element Attribute  ${block}[${lot}+1]//button/i  class
	Run Keyword If  "checkmark" not in "${class}" and ${status} == ${True}  Click Element  ${block}[${lot}+1]//button


Розгорнути усі лоти
	:FOR  ${i}  IN RANGE  1  ${lots amount}+1
	\  Розгорнути лот  ${i}


Заповнити поле з ціною
  [Documentation]  takes lot number and coefficient
  ...  fill bid field with max available price
  [Arguments]  ${lot number}  ${coefficient}
  ${block number}  Set Variable  ${lot number}+1
  ${a}=  Get Text  '${block}'[${block number}]//div[@class='amount lead'][1]
  ${a}=  get_number  ${a}
  ${amount}=  Evaluate  int(${a}*${coefficient})
  ${amount}  Run Keyword If  ${amount} == 0  Set Variable  1  ELSE
  ...  Set Variable  ${amount}
  ${field number}=  Evaluate  ${lot number}-1
  Input Text  xpath=//*[@id="lotAmount${field number}"]/input[1]  ${amount}


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


Додати файл
	[Arguments]  ${block}=1
	${doc}=  create_fake_doc
	${path}  Set Variable  ${doc[0]}
	Choose File  xpath=(//input[@type="file"][1])[${block}]  ${path}
	[Return]  ${doc[1]}





