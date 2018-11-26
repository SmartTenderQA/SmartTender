*** Settings ***
Resource  				../../src/src.robot
Resource  				../../src/pages/start_page/start_page.robot
Resource  				../../src/pages/contacts/contacts.robot
Resource  				../../src/pages/povidomlenya/povidomlenya.robot

Suite Setup  			Start in grid  ${user}
Suite Teardown  		Close All Browsers
Test Teardown  			Run Keywords
						...  Log Location  AND
						...  Run Keyword If Test Failed  Capture Page Screenshot


*** Test Cases ***
Повідомлення
	Зайти на сторінку contacts
	Зайти на сторінку povidomlenya
	Перевірити заголовок сторінки повідомлень
	Порахувати кількість повідомлень
	Переглянути повідемлення
	Закрити вікно з повідомленням
	Завершити сеанс користувача
	Зайти на сторінку contacts
	Перевірити відсутність дзвіночка(povidomlenya)
