*** Keywords ***
Отримати дані тендеру з cdb по id
    [Arguments]  ${id}
	Run Keyword If  "${site}" == "test"
	...  Create Session  api  https://lb-api-sandbox.prozorro.gov.ua/api/2.4/tenders/${id}
	Run Keyword If  "${site}" == "prod"
	...  Create Session  api  https://public.api.openprocurement.org/api/0/tenders/${id}  #https://public-api-sandbox.prozorro.gov.ua/api/0/tenders/${id}
	${data}  Get Request  api  \
	${data}  Set Variable  ${data.json()}
	${cdb_data}  Set Variable  ${data['data']}
	[Return]  ${cdb_data}


Отримати дані об'єкту приватизації з cdb по id
    [Arguments]  ${id}
	Run Keyword If  "${site}" == "test"
	...  Create Session  api  https://public.api-sandbox.ea2.openprocurement.net/api/2.3/assets/${id}
	Run Keyword If  "${site}" == "prod"
	...  Create Session  api  https://public.api.ea2.openprocurement.net/api/0/assets/${id}
	${data}  Get Request  api  \
	${data}  Set Variable  ${data.json()}
	${cdb_data}  Set Variable  ${data['data']}
	[Return]  ${cdb_data}


Отримати дані Аукціону ДЗК з cdb по id
    [Arguments]  ${id}
	Run Keyword If  "${site}" == "test"
	...  Create Session  api  https://public.api-sandbox.ea2.openprocurement.net/api/2.3/auctions/${id}
	Run Keyword If  "${site}" == "prod"
	...  Create Session  api  https://public.api.ea2.openprocurement.net/api/0/auctions/${id}
	${data}  Get Request  api  \
	${data}  Set Variable  ${data.json()}
	${cdb_data}  Set Variable  ${data['data']}
	[Return]  ${cdb_data}