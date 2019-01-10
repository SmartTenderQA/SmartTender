*** Variables ***
${EDS}                  ${block}[1]//div[@class="ivu-row"]//button
${EDS_block}    		//*[@data-qa="modal-eds"]
${passwod}      		29121963
${iframe}       		//iframe[contains(@src, 'EDS')]
${close button(old)}  	//div[@style]//button[@type='button' and @class='close']


*** Keywords ***
Натиснути підписати ЕЦП
	${passed}=  Run Keyword And Return Status  Wait Until Page Contains Element  ${EDS}[2]
	Sleep  2
	Run keyword if   "${passed}" == "${True}"  Click element  ${EDS}[2]
	...  ELSE  Click element  ${EDS}[1]
	Wait Until Page Contains Element  ${EDS_block}


Вибрати тестовий ЦСК
	${text}  Set Variable  Тестовий ЦСК АТ "ІІТ"
	Sleep  1
	Click Element  //*[@data-qa="eds-certification-authority"]
	Sleep  2
	Click Element  //*[@data-qa="eds-certification-authority"]//li[contains(text(), '${text}')]


Завантажити ключ
	Choose File  ${EDS_block}//input[@type='file']  ${EXECDIR}/src/pages/EDS/Key-6.dat


Ввести пароль ключа
	Input Password  ${EDS_block}//*[@data-qa="eds-password"]//input  ${passwod}


Натиснути Підписати
	Click Element  //*[@data-qa="eds-submit-sign"]
	Wait Until Element Is Not Visible  //*[@data-qa="eds-submit-sign"]  120
	Reload Page


Перевірити успішність підписання
	${now}  smart_get_time
	${get}  Get Text  //button[contains(., 'ЕЦП')]/following-sibling::*//*[@class="smt-tooltip"]
	${parse}  Evaluate  re.search(r'\\d{2}.+', '''${get}''').group(0)  re
	compare_dates_smarttender  ${now}  >=  ${parse}
