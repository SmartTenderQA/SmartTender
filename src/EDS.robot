*** Variables ***
${EDS_block}    //*[@data-qa="modal-eds"]
${passwod}      291263
${iframe}       //iframe[contains(@src, 'EDS')]
${close button(old)}  //div[@style]//button[@type='button' and @class='close']



*** Keywords ***
Підписати ЕЦП
	${status}  Run Keyword And Return Status  Location Should Contain  test.
	Run Keyword If  ${status} == ${True}  Підписати ЕЦП(new)
	...  ELSE  Підписати ЕЦП(old)


Підписати ЕЦП(new)
	Натиснути підписати ЕЦП
	Вибрати тестовий ЦСК
	Завантажити ключ
	Ввести пароль ключа
	Натиснути Підписати
	Перевірити успішність піцдписання


Підписати ЕЦП(old)
	Натиснути підписати ЕЦП
	Дочекатись прогрузки елементів
	Закрити вікно ЕЦП(old)


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


Дочекатись прогрузки елементів
	${iframe}  Set Variable  //iframe[contains(@src, 'EDS')]
	Wait Until Page Contains Element  ${iframe}
	Select Frame  ${iframe}
	Wait Until Page Contains  Апаратний ключ  60
	Wait Until Page Contains  ЦСК  60
	Wait Until Page Contains  Приватний ключ  60
	Wait Until Page Contains  Пароль ключа  60


Закрити вікно ЕЦП(old)
	Unselect Frame
	Wait Until Page Contains Element  ${close button(old)}
	Click Element  ${close button(old)}
	Wait Until Page Does Not Contain Element  ${close button(old)}
