*** Variables ***
${EDS btn}                 ${block}\[1]//div[@class="ivu-row"]//button
${EDS_block}    		   //*[@data-qa="modal-eds"]
${EDS validation message}  //*[@class="ivu-notice-title"]
${EDS submit btn}          //*[@data-qa="eds-submit-sign"]
${EDS stamp}               //button[contains(., 'ЕЦП')]/following-sibling::*//*[@class="smt-tooltip"]
${passwod}      		   29121963
${iframe}       		   //iframe[contains(@src, 'EDS')]
${close button(old)}  	   //div[@style]//button[@type='button' and @class='close']

${EDS succeed}             ЕЦП/КЕП успішно накладено


*** Keywords ***
Натиснути підписати ЕЦП
	${passed}=  Run Keyword And Return Status  Wait Until Page Contains Element  ${EDS btn}\[2]
	Sleep  2
	Run keyword if   "${passed}" == "${True}"  Click element  ${EDS btn}\[2]
	...  ELSE  Click element  ${EDS btn}\[1]
	elements.Дочекатися відображення елемента на сторінці  ${EDS_block}


Вибрати тестовий ЦСК
	${text}  Set Variable  Тестовий ЦСК АТ "ІІТ"
	Sleep  1
	Click Element  //*[@data-qa="eds-certification-authority"]
	Sleep  2
	Click Element  //*[@data-qa="eds-certification-authority"]//li[contains(text(), '${text}')]


Завантажити ключ
    [Arguments]  ${index}=1
	Choose File  (${EDS_block}//input[@type='file'])[${index}]  ${EXECDIR}/src/pages/EDS/Key-6.dat


Ввести пароль ключа
    [Arguments]  ${index}=1
	Input Password  (${EDS_block}//*[@data-qa="eds-password"]//input)[${index}]  ${passwod}


Натиснути Підписати та отримати відповідь
	[Arguments]  ${index}=1
	Click Element  (${EDS submit btn})[${index}]
	Wait Until Element Is Not Visible  (${EDS submit btn})[${index}]  120
	${message}  Отримати відповідь про підписання ЕЦП
	Reload Page
	loading.Дочекатись закінчення загрузки сторінки
	[Return]  ${message}


Перевірити успішність підписання
    [Arguments]  ${message}
    Run Keyword If  "${EDS succeed}" in """${message}"""  No Operation
    ...  ELSE  Fail  Помилка підписання ЕЦП! Look to message
    Перевірити дату підписання ЕЦП


##########################################################
########################  KEYWORDS  ######################
##########################################################
Отримати відповідь про підписання ЕЦП
    Wait Until Element Is Visible  ${EDS validation message}
    ${message}  Get Text  ${EDS validation message}
    Run Keyword If  '${message}' == 'None'  Fail  Де валідаційне повідомлення?
    [Return]  ${message}


Перевірити дату підписання ЕЦП
    ${now}  smart_get_time
    Wait Until Element Is Visible  ${EDS stamp}  10
	${get}  Get Text  ${EDS stamp}
	${parse}  Evaluate  re.search(r'\\d{2}.+', '''${get}''').group(0)  re
	compare_dates_smarttender  ${now}  >=  ${parse}


Валідація файла підпису ЕЦП
    ${poptip}  Set Variable  (//*[@class="ivu-poptip-inner"])[1]
    Click Element                   ${EDS stamp}
    Дочекатись закінчення загрузки сторінки
    Wait Until Element is Visible   ${poptip}
    ${validation poptip}  Get text  ${poptip}
    Should Contain Any  ${validation poptip}  Підпис ЭЦП/КЭП  Підпис ЕЦП/КЕП
    Should Contain  ${validation poptip}  Власник: Шурек Костянтин Вадимович
    Should Contain  ${validation poptip}  ЦСК: Тестовий ЦСК АТ "ІІТ"
    Should Contain  ${validation poptip}  Серійний номер: 5B63D88375D9201804000000D7060000614E0000