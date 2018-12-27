*** Settings ***
Documentation    Suite description
Library		compare_data.py



*** Keywords ***
Порівняти введені дані з даними в ЦБД
	[Arguments]  ${field}  ${time format}=s
	${value entered}  Set Variable  ${data${field}}
 	${value cdb}  compare_data.Отритами дані з ЦБД  ${field}  ${time format}
 	${is equal}  compare_data.compare_values  ${value entered}  ${value cdb}
 	Should Be True  ${is equal}  Oops! Помилка з даними для ${field}


Порівняти відображені дані з даними в ЦБД
 	[Arguments]  ${field}  ${time format}=s
 	${value cdb}  compare_data.Отритами дані з ЦБД  ${field}  ${time format}
 	${value viewed}  compare_data.Отритами дані зі сторінки  ${field}
 	${is equal}  compare_data.compare_values  ${value viewed}  ${value cdb}
 	Should Be True  ${is equal}  Oops! Помилка з даними для ${field}


Отритами дані зі сторінки
 	[Arguments]  ${field}
 	${selector}  Set Variable  ${view_locators${field}}
 	Wait Until Element Is Visible  ${selector}  10
 	${value}  Get Text  ${selector}
 	${field value}  compare_data.convert_viewed_values_to_edit_format  ${field}  ${value}
 	[Return]  ${field value}


Отритами дані з ЦБД
	[Arguments]  ${field}  ${time format}
 	${value}  Set Variable  ${cdb_data${field}}
 	${field value}  compare_data.convert_cdb_values_to_edit_format  ${field}  ${value}  ${time format}
	[Return]  ${field value}