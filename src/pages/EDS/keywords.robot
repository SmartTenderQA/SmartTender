*** Variables ***
${EDS btn}              ${block}[1]//div[@class="ivu-row"]//button
${EDS_block}    		//*[@data-qa="modal-eds"]
${passwod}      		29121963
${iframe}       		//iframe[contains(@src, 'EDS')]
${close button(old)}  	//div[@style]//button[@type='button' and @class='close']
${ca list}              //select[@name="ca"]


*** Keywords ***
Підписати ЕЦП iframe
    Select Frame  ${iframe}
    Вибрати тестовий ЦСК iframe
    Завантажити ключ
    Ввести пароль ключа
    Wait Until Keyword Succeeds  3m  10  Натиснути Підписати
    Перевірити успішність підписання
    Unselect Frame


Підписати ЕЦП no iframe
    Вибрати тестовий ЦСК
    Завантажити ключ
    Ввести пароль ключа
    Wait Until Keyword Succeeds  3m  10  Натиснути Підписати
    Перевірити успішність підписання


#################################################
#                   Keywords                    #
#################################################
Натиснути підписати ЕЦП
	${passed}  Run Keyword And Return Status  Wait Until Page Contains Element  ${EDS btn}[2]
	Sleep  2
	Run keyword if  "${passed}" == 'True'  Click element  ${EDS btn}[2]
	...  ELSE
	...  Click element  ${EDS btn}[1]
	${iframe status}  Run Keyword And Return Status  Wait Until Element Is Visible  ${iframe}
	[Return]  ${iframe status}


Вибрати тестовий ЦСК
    ${eds ca}  Set Variable  //*[@data-qa="eds-certification-authority"]
	${text}    Set Variable  Тестовий ЦСК АТ "ІІТ"
	Wait Until Page Contains Element  ${EDS_block}
	Sleep  1
	Click Element  ${eds ca}
	Sleep  2
	Click Element  ${eds ca}//li[contains(text(), '${text}')]


Вибрати тестовий ЦСК iframe
    Wait Until Keyword Succeeds  30  2  Select From List By Label  ${ca list}  Тестовий ЦСК АТ "ІІТ"


Завантажити ключ
    ${upload input}  Set Variable  ${EDS_block}//input[@type='file']|(//input[@class="upload"])[1]
	Choose File  ${upload input}   ${EXECDIR}/src/pages/EDS/Key-6.dat


Ввести пароль ключа
	Input Password  ${EDS_block}//*[@data-qa="eds-password"]//input|//input[@name="password"]  ${passwod}


Натиснути Підписати
    ${sign btn}  Set Variable  //*[@data-qa="eds-submit-sign"]|//*[text()="Підписати"]/ancestor::*[contains(@class,"btn")]
	Click Element  ${sign btn}
	Wait Until Element Is Not Visible  ${sign btn}  120
	Reload Page


Перевірити успішність підписання
    ${stamp}  Set Variable  //button[contains(., 'ЕЦП')]/following-sibling::*//*[@class="smt-tooltip"]
	${now}  smart_get_time
	${status}  Run Keyword And Return Status  Wait Until Element Is Visible  ${stamp}  10
	Run Keyword If  '${status}' == 'False'  Run Keywords
	...  Reload Page  AND
	...  Wait Until Element Is Visible  ${stamp}  10
	${get}  Get Text  ${stamp}
	${parse}  Evaluate  re.search(r'\\d{2}.+', '''${get}''').group(0)  re
	compare_dates_smarttender  ${now}  >=  ${parse}
