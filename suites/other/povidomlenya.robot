*** Settings ***
Resource  				../../src/src.robot
Resource  				../../src/pages/start_page/start_page.robot
Resource  				../../src/pages/contacts/contacts.robot
Resource  				../../src/pages/povidomlenya/povidomlenya.robot

Suite Setup  			Run Keywords
...  					Open Browser In Grid  ${user}  AND
...  					Авторизуватися  ssp_tender_owner
Suite Teardown  		Close All Browsers
Test Teardown  			Run Keywords
						...  Log Location  AND
						...  Run Keyword If Test Failed  Capture Page Screenshot


*** Test Cases ***
Відкрити сторінку зі списком повідомлень
	start_page.Навести мишку на іконку з заголовку  Повідомлення
	notifications.Натиснути показати всі


Перевірити сторінку та одне повідомлення
	Зайти на сторінку povidomlenya
	Перевірити заголовок сторінки повідомлень
	Порахувати кількість повідомлень
	Переглянути повідемлення
	Закрити вікно з повідомленням

Завершити сеанс користувачем
	Go To  ${start_page}
	Навести мишку на іконку з заголовку  Меню_користувача
	Натиснути  Вийти


Негативні перевірки
	Run Keyword And Expect Error
	...  Element with locator '//*[@data-qa="notifications"]' not found.
	...  start_page.Навести мишку на іконку з заголовку  Повідомлення
	Вибрати елемент з випадаючого списку заголовку  Про SmartTender  Контакти
	Перевірити відсутність дзвіночка(povidomlenya)
