*** Keywords ***
Отримати дані тендеру з cdb по id
	Run Keyword If  "${site}" == "test"
	...  Create Session  api  https://lb.api-sandbox.openprocurement.org/api/2.4/tenders/${id}
	Run Keyword If  "${site}" == "prod"
	...  Create Session  api  https://public.api.openprocurement.org/api/0/tenders/${id}  #https://public-api-sandbox.prozorro.gov.ua/api/0/tenders/${id}
	${data}  Get Request  api  \
	${data}  Set Variable  ${data.json()}
	${cdb_data}  Set Variable  ${data['data']}
	[Return]  ${cdb_data}