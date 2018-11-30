*** Keywords ***
Отримати дані тендеру з cdb по id
	${id}  procurement_tender_detail.Отритами дані зі сторінки  ['prozorro-id']
	Run Keyword If  "${site}" == "test"
	...  Create Session  api  https://lb.api-sandbox.openprocurement.org/api/2.4/tenders/${id}
	Run Keyword If  "${site}" == "prod"
	...  Create Session  api  https://public-api-sandbox.prozorro.gov.ua/api/0/tenders/${id}
	${data}  Get Request  api  \
	${data}  Set Variable  ${data.json()}
	${cbd_data}  Set Variable  ${data['data']}
	[Return]  ${cbd_data}