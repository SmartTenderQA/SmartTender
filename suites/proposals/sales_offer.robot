*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Start  ${user}  Provider1
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot



*** Test Cases ***
Знайти необхідний тендер
	${data}  Create Dictionary
	Відкрити сторінку тестових торгів
	Активувати вкладку аукціони на продаж активів банків
	#${ua_tender_type}  convert_tender_type  ${tender_type}
	Відфільтрувати по формі торгів  Голландський аукціон  #${ua_tender_type}
	Відфільтрувати по статусу торгів  Прийом пропозицій
	${date}  smart_get_time  1  d
	Відфільтрувати по даті кінця прийому пропозиції від  ${date}
	Виконати пошук тендера
	Перейти по результату пошуку  (${first found element})[last()]
	Отримати title тендеру


Подати заявку на участь
	No Operation


Підтвердити заявку
	Авторизуватися організатором
	Відкрити сторінку заявок на участь в аукціоні
	Пошук об'єкта у webclient по полю  Назва лоту  ${data.title}



*** Keywords ***
Postcondition
	Close All Browsers


Активувати вкладку аукціони на продаж активів банків
	Click Element  ${torgy top/bottom tab}(1) ${torgy count tab}(2)


Авторизуватися організатором
	Start  IT_RAV  tender_owner
	Закрити вікно у Виберіть об`єкт


Отримати title тендеру
	${selector}  Set Variable  css=.ivu-card-body h3
	Wait Until Element Is Visible  ${selector}
	${title}  Get Text  ${selector}
	Set To Dictionary  ${data}  title  ${title}
