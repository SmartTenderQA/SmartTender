*** Keywords ***
Відкрити бланк подачі заявки
	Reload Page
	Дочекатись закінчення загрузки сторінки(skeleton)
	Click Element  xpath=//button[@type='button']//*[contains(text(), 'Взяти участь')]
	Дочекатись закінчення загрузки сторінки


Додати файл для подачі заявки
	${selector}  Set Variable  //input[@type='file' and @accept]
	Wait Until Page Contains Element  ${selector}
	${n}  Get Element Count  ${selector}/..
	:FOR  ${i}  IN RANGE  ${n}
    \  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
	\  Choose File  ${selector}  ${file_path}


Ввести ім'я для подачі заявки
	Input Text  xpath=//*[contains(text(), "Ім'я")]/following-sibling::*//input  Тостер


Підтвердити відповідність для подачі заявки
	Select Checkbox  xpath=//*[@class="group-line"]//input


Відправити заявку для подачі пропозиції та закрити валідаційне вікно
	Wait Until Keyword Succeeds  20  2  Click Element  xpath=//button[@class="ivu-btn ivu-btn-primary pull-right ivu-btn-large"]
	Wait Until Page Contains  Ваша заявка відправлена!  120
	Sleep  3
	Wait Until Keyword Succeeds  20  2  Click Element  xpath=//*[contains(text(), 'Ваша заявка відправлена!') or contains(text(), 'Ваша заявка розглядається!')]/ancestor::*[@class='ivu-modal-content']//a
	Wait Until Element Is Not Visible  xpath=//*[contains(text(), 'Ваша заявка відправлена!')]/ancestor::*[@class='ivu-modal-content']//a  20