*** Settings ***
Resource  EDS_keywords.robot


*** Keywords ***
Підписати ЕЦП
	Натиснути підписати ЕЦП
	Завантажити ключ
	Ввести пароль ключа
	${message}  Натиснути Підписати та отримати відповідь
	Перевірити успішність підписання  ${message}


Валідація підпису ЕЦП
    Валідація файла підпису ЕЦП
