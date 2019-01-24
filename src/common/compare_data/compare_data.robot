*** Settings ***
Documentation    Suite description
Library		compare_data.py



*** Keywords ***
Завантажити локатори для кваліфікаційних документів
	${docs_data}  compare_data.get_docs_data
	${docs_view}  compare_data.get_docs_view
	Set Global Variable  ${docs_data}
	Set Global Variable  ${docs_view}


Порівняти введені дані з даними в ЦБД
	[Arguments]  ${field}  ${time format}=s
	${value entered}  Set Variable  ${data${field}}
 	${value cdb}  compare_data.Отритами дані з ЦБД  ${field}  ${time format}
 	${is equal}  compare_data.compare_values  ${value entered}  ${value cdb}
 	Should Be True  ${is equal}  Oops! Помилка з даними для ${field}


Порівняти відображені дані з даними в ЦБД
 	[Arguments]  ${field}  ${procedure}=DZK
 	${value cdb}  compare_data.Отритами дані з ЦБД  ${field}
 	${value viewed}  compare_data.Отритами дані зі сторінки  ${field}  ${procedure}
 	${is equal}  compare_data.compare_values  ${value viewed}  ${value cdb}
 	Run Keyword If  ${is equal} == ${False}  Run Keywords
 	...  Scroll Page To Element XPATH  ${view_locators${field}}  AND
 	...  Capture Page Screenshot
 	Should Be True  ${is equal}  Oops! Помилка з даними для ${field}


Отритами дані зі сторінки
 	[Arguments]  ${field}  ${procedure}=DZK
 	${selector}  Set Variable  ${view_locators${field}}
 	Wait Until Element Is Visible  ${selector}  10
 	${value}  Get Text  ${selector}
 	${field value}  compare_data.convert_viewed_values_to_edit_format  ${field}  ${value}  ${procedure}
 	[Return]  ${field value}


Отритами дані з ЦБД
	[Arguments]  ${field}  ${time format}=s
 	${value}  Set Variable  ${cdb_data${field}}
 	${field value}  compare_data.convert_cdb_values_to_edit_format  ${field}  ${value}  ${time format}
	[Return]  ${field value}


Порівняти створений документ з документом в ЦБД
	[Arguments]  ${doc}
	${cdb_doc}  get_selected_doc  ${doc}  ${cdb_data}
	Should Be Equal  ${cdb_doc['title']}  ${doc['title']}  Oops! Помилка з title
	Should Be Equal  ${cdb_doc['documentType']}  ${doc['documentType']}  Oops! Помилка з documentType
	Should Be Equal  ${cdb_doc['hash']}  ${doc['hash']}  Oops! Помилка з hash


Порівняти відображений документ з документом в ЦБД
	[Arguments]  ${doc}
	${cdb_doc}  get_selected_doc  ${doc}  ${cdb_data}
	${view doc block}  Set Variable  //*[@style and @class='ivu-row' and contains(.,'${doc['title']}')]
	Scroll Page To Element XPATH  ${view doc block}
	${view title}  Get Text  ${view doc block}${docs_view['title']}
	Should Be Equal  ${view title}  ${cdb_doc['title']}  Oops! Помилка з title
	${view documentType}  Get Text  ${view doc block}${docs_view['documentType']}
	Should Be Equal  ${view documentType}  ${cdb_doc['documentType']}  Oops! Помилка з documentType
	${view dateModified}  Get Text  ${view doc block}${docs_view['dateModified']}
	Should Be Equal  ${view dateModified}  ${cdb_doc['dateModified']}  Oops! Помилка з dateModified
