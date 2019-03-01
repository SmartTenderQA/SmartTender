*** Settings ***
Resource  				../../src/src.robot
Resource  				../../src/pages/start_page/start_page.robot
Resource  				../../src/pages/contacts/contacts.robot
Resource  				../../src/pages/povidomlenya/povidomlenya.robot

Suite Setup             Precondition
Suite Teardown  		Close All Browsers
Test Teardown  			Run Keywords
						...  Log Location  AND
						...  Run Keyword If Test Failed  Capture Element Screenshot  //body

#zapusk
#robot --consolecolors on -L TRACE:INFO -d test_output -v where:test suites/other/povidomlenya.robot
*** Test Cases ***
Відкрити сторінку зі списком повідомлень
	start_page.Навести мишку на іконку з заголовку  Повідомлення
	notifications.Натиснути показати всі


Перевірити сторінку та одне повідомлення
	Порахувати кількість повідомлень
	Переглянути повідемлення
	Закрити вікно з повідомленням


Завершити сеанс користувачем
	Go To Smart  ${start_page}
	Навести мишку на іконку з заголовку  Меню_користувача
	Натиснути  Вийти


Негативні перевірки
	Run Keyword And Expect Error
	...  *not found.
	...  start_page.Навести мишку на іконку з заголовку  Повідомлення
	Вибрати елемент з випадаючого списку заголовку  Про SmartTender  Контакти
	Перевірити відсутність дзвіночка(povidomlenya)


*** Keywords ***
Precondition
	${user}  Set Variable If
	...  '${where}' == 'test'  ssp_tender_owner
	...  'prod' in '${where}'  prod_ssp_owner
   	Set Global Variable  ${user}  ${user}
    Додати першого користувача  ${user}
