*** Variables ***
${EDS_block}    //*[@data-qa="modal-eds"]
${passwod}      291263


*** Keywords ***
Підписати ЕЦП
	Натиснути підписати ЕЦП
	Вибрати тестовий ЦСК
	Завантажити ключ
	Ввести пароль ключа
	Натиснути Підписати
	Перевірити успішність піцдписання


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
	Choose File  ${EDS_block}//input[@type='file']  ${EXECDIR}/src/Key-6.dat


Ввести пароль ключа
	Input Password  ${EDS_block}//*[@data-qa="eds-password"]//input  ${passwod}


Натиснути Підписати
	Click Element  //*[@data-qa="eds-submit-sign"]
	Wait Until Element Is Not Visible  //*[@data-qa="eds-submit-sign"]  120
	Reload Page


Перевірити успішність піцдписання
	${now}  smart_get_time
	${get}  Get Text  //button[contains(., 'ЕЦП')]/following-sibling::*//*[@class="smt-tooltip"]
	${parse}  Evaluate  "${get}".replace("sign.p7s - ", "")
	compare_dates_smarttender  ${now}  >=  ${parse}
