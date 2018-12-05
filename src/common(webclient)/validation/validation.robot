*** Keywords ***
Закрити вікно
	[Arguments]  ${title}
	${button}  Set Variable  //*[contains(@class, "headerText") and contains(text(), "${title}")]/../../div[contains(@class, 'close')]
	Wait Until Page Contains Element  ${button}
	Click Element  ${button}
	Wait Until Page Does Not Contain Element  ${button}


Закрити валідаційне вікно
	[Arguments]  ${title}  ${action}
	${button}  Set Variable  //*[contains(@class, "headerText") and contains(text(), "${title}")]/ancestor::*//span[contains(text(), '${action}')]
	Wait Until Page Contains Element  ${button}
	Click Element  ${button}
	Дочекатись закінчення загрузки сторінки(webclient)
	Wait Until Element Is Not Visible  ${button}


Закрити валідаційне вікно (Так/Ні)
	[Arguments]  ${title}  ${action}
	${button}  Set Variable
	...  //*[@id="MessageBoxContent"]//p[contains(text(),"${title}")]/ancestor::*[@id="MessageBoxContent"]//*[@class="messagebox-button-cell"]//span[text()="${action}"]
	Wait Until Page Contains Element  ${button}
	Click Element  ${button}
	Sleep  3


Підтвердити повідомлення про перевірку публікації документу за необхідністю
    ${status}  Run Keyword And Return Status
    ...  Wait Until Element Contains  //span[@id="pcModalMode_PWH-1T"]  Завантаження документації
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  xpath=//*[@title="OK"]
    ...  AND  Дочекатись закінчення загрузки сторінки(webclient)


Ignore WebClient Error
	[Arguments]  ${text}=Виняткова ситуація
	${window}  Set Variable  //*[@id="pcModalMode_PW-1"]//span[contains(text(), "${text}")]
	${status}  Run Keyword And Return Status  Wait Until Element Is Visible  ${window}
	Run Keyword If  ${status} == ${True}  Run Keywords
	...  Натиснути OkButton
	...  AND  Ignore WebClient Error  ${text}


Перевірка на успішність публікації тендера
	${status}  Run Keyword And Return Status  Element Should Be Visible  //*[@id="IMMessageBox_PWH-1T"]
	Run Keyword If  ${status}  Fatal Error  Тендер не опубліковано


Перевірити стадію тендера
	[Arguments]  ${stage}
	${get}  Get Text  //tr[contains(@class, "rowselected")]//td[4]
	Should Contain  ${get}  ${stage}