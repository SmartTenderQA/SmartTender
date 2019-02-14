*** Settings ***
Library  ../../src/pages/sale/SPF/cdb2_LandLease_page/cdb2_LandLease_variables.py


*** Keywords ***
Створити аукціон
	start_page.Натиснути на іконку з баннеру  Комерційні тендери SmartTender
	old_search.Активувати вкладку ФГИ
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	cdb2_LandLease_page.Натиснути створити аукціон
	cdb2_LandLease_step.Заповнити "Номер лоту"
	cdb2_LandLease_step.Заповнити "Найменування лоту"
	cdb2_LandLease_step.Заповнити "Опис лоту"
	cdb2_LandLease_step.Заповнити "Інформацію про організатора"
	cdb2_LandLease_step.Заповнити "Інформацію про контактну особу"
	cdb2_LandLease_step.Заповнити "Інформацію про умови аукціону"
	cdb2_LandLease_step.Заповнити "Банківські реквізити"
	cdb2_LandLease_step.Заповнити "Реквізити для перерахування реєстраційних внесків"
	cdb2_LandLease_step.Заповнити "Реквізити для перерахування гарантійних внесків"
	cdb2_LandLease_step.Заповнити "Реквізити рахунку(рахунків) виконавця для сплати винагороди та/або витрат на підготовку"
	cdb2_LandLease_step.Заповнити "Загальну інформацію про предмет"
	cdb2_LandLease_step.Додати проект договору
	sale_keywords.Натиснути кнопку зберегти
	#todo nuzhno ubrat` posle fixa
	Wait Until Keyword Succeeds  3x  35  sale_keywords.Натиснути кнопку опублікувати
	###


Завантажити локатори
	${edit_locators}  cdb2_LandLease_variables.get_edit_locators
	${view_locators}  cdb2_LandLease_variables.get_view_locators
	${data}  cdb2_LandLease_variables.get_data
	Set Global Variable  ${edit_locators}
	Set Global Variable  ${view_locators}
	Set Global Variable  ${data}


#########################################################
#	                  Keywords							#
#########################################################
Заповнити "Номер лоту"
	${lotNumber}  random_number  10000  1000000
	cdb2_LandLease_page.Заповнити lotIdentifier  ${lotNumber}
	Set To Dictionary  ${data}  lotIdentifier  ${lotNumber}


Заповнити "Найменування лоту"
	${title}  create_sentence  5
	cdb2_LandLease_page.Заповнити title  ${title}
	Set To Dictionary  ${data}  title  [ТЕСТУВАННЯ] ${title}


Заповнити "Опис лоту"
	${description}  create_sentence  20
	cdb2_LandLease_page.Заповнити description  ${description}
	Set To Dictionary  ${data}  description  ${description}


Заповнити "Інформацію про організатора"
	cdb2_LandLease_step.Заповнити "Назва організатора"
	cdb2_LandLease_step.Заповнити "Код ЄДРПОУ організатора"
	cdb2_LandLease_step.Заповнити "Поштовий індекс організатора"
	cdb2_LandLease_step.Заповнити "Місто організатора"
	cdb2_LandLease_step.Заповнити "Вулиця організатора"


Заповнити "Назва організатора"
	${legalName}  create_sentence  2
	cdb2_LandLease_page.Заповнити lotHolder.identifier.legalName  ${legalName}
	Set To Dictionary  ${data['lotHolder']['identifier']}  legalName  ${legalName}


Заповнити "Код ЄДРПОУ організатора"
	${id}  random_number  10000  100000
	cdb2_LandLease_page.Заповнити lotHolder.identifier.id  ${id}
	Set To Dictionary  ${data['lotHolder']['identifier']}  id  ${id}


Заповнити "Поштовий індекс організатора"
	${postalCode}  random_number  10000  99999
	cdb2_LandLease_page.Заповнити lotHolder.address.postalCode  ${postalCode}
	Set To Dictionary  ${data['lotHolder']['address']}  postalCode  ${postalCode}


Заповнити "Місто організатора"
	${locality}  cdb2_LandLease_page.Заповнити lotHolder.address.locality
	${region}  Evaluate  (re.findall(r'[А-я][^(]+[.]','${locality}'))[0]  re
	Set To Dictionary  ${data['lotHolder']['address']}  region  ${region}
	${locality}  Evaluate  re.sub(r'.[(].*','','${locality}')  re
	Set To Dictionary  ${data['lotHolder']['address']}  locality  ${locality}


Заповнити "Вулиця організатора"
	${streetAddress}  get_some_uuid
	cdb2_LandLease_page.Заповнити lotHolder.address.streetAddress  ${streetAddress}
	Set To Dictionary  ${data['lotHolder']['address']}  streetAddress  ${streetAddress}


Заповнити "Інформацію про контактну особу"
	cdb2_LandLease_step.Заповнити "ПІБ контактної особи"
	cdb2_LandLease_step.Заповнити "Телефон контактної особи"
	cdb2_LandLease_step.Заповнити "Факс контактної особи"
	cdb2_LandLease_step.Заповнити "Email контактної особи"
	cdb2_LandLease_step.Заповнити "URL контактної особи"


Заповнити "ПІБ контактної особи"
	${name}  create_sentence  3
	cdb2_LandLease_page.Заповнити lotHolder.contactPoint.name  ${name}
	Set To Dictionary  ${data['lotHolder']['contactPoint']}  name  ${name}


Заповнити "Телефон контактної особи"
	No Operation


Заповнити "Факс контактної особи"
	No Operation


Заповнити "Email контактної особи"
	${text}  Generate Random String  6  [LETTERS][NUMBERS]
	${email}  Set Variable  ${text}@gmail.com
	cdb2_LandLease_page.Заповнити lotHolder.contactPoint.email  ${email}
	Set To Dictionary  ${data['lotHolder']['contactPoint']}  email  ${email}


Заповнити "URL контактної особи"
	No Operation


Заповнити "Інформацію про умови аукціону"
	cdb2_LandLease_step.Заповнити "Дата проведення аукціону"
	cdb2_LandLease_step.Заповнити "Лоти виставляються"
	cdb2_LandLease_step.Заповнити "Мінімальна кількість учасників аукціону"
	cdb2_LandLease_step.Заповнити "Тривалість оренди Років"
	cdb2_LandLease_step.Заповнити "Тривалість оренди Місяців"
	cdb2_LandLease_step.Заповнити "Стартова ціна об’єкта"
	cdb2_LandLease_step.Заповнити "Крок електронного аукціону"
	cdb2_LandLease_step.Заповнити "Розмір гарантійного внеску"
	cdb2_LandLease_step.Заповнити "Вартість підготовки лоту до торгів"
	cdb2_LandLease_step.Заповнити "Реєстраційний внесок"


Заповнити "Дата проведення аукціону"
	${delta minutes}  Set Variable  40
	${start}  Evaluate  '{:%d.%m.%Y %H:%M:%S}'.format(datetime.datetime.now() + datetime.timedelta(minutes=int(${delta minutes})))  datetime
	cdb2_LandLease_page.Заповнити auctionPeriod.shouldStartAfter  ${start}
	Set To Dictionary  ${data['auctionPeriod']}  shouldStartAfter  ${start}


Заповнити "Лоти виставляються"
	${tenderAttempts}  cdb2_LandLease_page.Заповнити tenderAttempts
	Set To Dictionary  ${data}  tenderAttempts  ${tenderAttempts}


Заповнити "Мінімальна кількість учасників аукціону"
	${minNumberOfQualifiedBids}  cdb2_LandLease_page.Заповнити minNumberOfQualifiedBids
	Set To Dictionary  ${data}  minNumberOfQualifiedBids  ${minNumberOfQualifiedBids}


Заповнити "Тривалість оренди Років"
	${years}  random_number  1  100
	cdb2_LandLease_page.Заповнити contractTerms.leaseTerms.years  ${years}
	${leaseDuration}  Set Variable If
	...  '${data['contractTerms']['leaseTerms']['leaseDuration']}' == ''  P0Y0M
	...  '${data['contractTerms']['leaseTerms']['leaseDuration']}' != ''  ${data['contractTerms']['leaseTerms']['leaseDuration']}
	${leaseDuration}  Evaluate  re.sub(r'P[0-9]*Y', 'P${years}Y', '${leaseDuration}')  re
	Set To Dictionary  ${data['contractTerms']['leaseTerms']}  leaseDuration  ${leaseDuration}


Заповнити "Тривалість оренди Місяців"
	${months}  random_number  1  12
	cdb2_LandLease_page.Заповнити contractTerms.leaseTerms.months  ${months}
	${leaseDuration}  Set Variable If
	...  '${data['contractTerms']['leaseTerms']['leaseDuration']}' == ''  P0Y0M
	...  '${data['contractTerms']['leaseTerms']['leaseDuration']}' != ''  ${data['contractTerms']['leaseTerms']['leaseDuration']}
	${leaseDuration}  Evaluate  re.sub(r'Y[0-9]*M', 'Y${months}M', '${leaseDuration}')  re
	Set To Dictionary  ${data['contractTerms']['leaseTerms']}  leaseDuration  ${leaseDuration}


Заповнити "Стартова ціна об’єкта"
	${value}  random_number  10000  500000
	cdb2_LandLease_page.Заповнити value.amount  ${value}
	Set To Dictionary  ${data['value']}  amount  ${value}


Заповнити "Крок електронного аукціону"
	${minimalStep}  random_number  100  10000
	cdb2_LandLease_page.Заповнити minimalStep.amount  ${minimalStep}
	Set To Dictionary  ${data['minimalStep']}  amount  ${minimalStep}


Заповнити "Розмір гарантійного внеску"
	${guarantee}  random_number  100  1000
	cdb2_LandLease_page.Заповнити guarantee.amount  ${guarantee}
	Set To Dictionary  ${data['guarantee']}  amount  ${guarantee}


Заповнити "Вартість підготовки лоту до торгів"
	${budgetSpent}  random_number  100  1000
	cdb2_LandLease_page.Заповнити budgetSpent.amount  ${budgetSpent}
	Set To Dictionary  ${data['budgetSpent']}  amount  ${budgetSpent}


Заповнити "Реєстраційний внесок"
	${registrationFee}  random_number  100  1000
	cdb2_LandLease_page.Заповнити registrationFee.amount  ${registrationFee}
	Set To Dictionary  ${data['registrationFee']}  amount  ${registrationFee}


Заповнити "Банківські реквізити"
	cdb2_LandLease_step.Заповнити "Найменування банку"
	cdb2_LandLease_step.Заповнити "Опис банку"


Заповнити "Найменування банку"
	${bankName}  create_sentence  5
	cdb2_LandLease_page.Заповнити bankAccount.bankName  ${bankName}
	Set To Dictionary  ${data['bankAccount']}  bankName  ${bankName}


Заповнити "Опис банку"
	No Operation


Заповнити "Реквізити для перерахування реєстраційних внесків"
	cdb2_LandLease_step.Заповнити "Код ЄДРПОУ для реєстраційних внесків"
	cdb2_LandLease_step.Заповнити "МФО для реєстраційних внесків"
	cdb2_LandLease_step.Заповнити "Номер рахунку для реєстраційних внесків"


Заповнити "Код ЄДРПОУ для реєстраційних внесків"
    ${id}  Generate Random String  10  [LETTERS][NUMBERS]
    cdb2_LandLease_page.Заповнити bankAccount.accountIdentification.(num).id  ${id}  6
    Set To Dictionary  ${data['bankAccount']['accountIdentification'][6]}  id  ${id}


Заповнити "МФО для реєстраційних внесків"
    ${id}  Generate Random String  10  [LETTERS][NUMBERS]
    cdb2_LandLease_page.Заповнити bankAccount.accountIdentification.(num).id  ${id}  7
    Set To Dictionary  ${data['bankAccount']['accountIdentification'][7]}  id  ${id}


Заповнити "Номер рахунку для реєстраційних внесків"
    ${id}  Generate Random String  10  [LETTERS][NUMBERS]
    cdb2_LandLease_page.Заповнити bankAccount.accountIdentification.(num).id  ${id}  8
    Set To Dictionary  ${data['bankAccount']['accountIdentification'][8]}  id  ${id}


Заповнити "Реквізити для перерахування гарантійних внесків"
	cdb2_LandLease_step.Заповнити "Код ЄДРПОУ для гарантійних внесків"
	cdb2_LandLease_step.Заповнити "МФО для гарантійних внесків"
	cdb2_LandLease_step.Заповнити "Номер рахунку для гарантійних внесків"


Заповнити "Код ЄДРПОУ для гарантійних внесків"
    ${id}  Generate Random String  10  [LETTERS][NUMBERS]
    cdb2_LandLease_page.Заповнити bankAccount.accountIdentification.(num).id  ${id}  3
    Set To Dictionary  ${data['bankAccount']['accountIdentification'][3]}  id  ${id}


Заповнити "МФО для гарантійних внесків"
    ${id}  Generate Random String  10  [LETTERS][NUMBERS]
    cdb2_LandLease_page.Заповнити bankAccount.accountIdentification.(num).id  ${id}  4
    Set To Dictionary  ${data['bankAccount']['accountIdentification'][4]}  id  ${id}


Заповнити "Номер рахунку для гарантійних внесків"
    ${id}  Generate Random String  10  [LETTERS][NUMBERS]
    cdb2_LandLease_page.Заповнити bankAccount.accountIdentification.(num).id  ${id}  5
    Set To Dictionary  ${data['bankAccount']['accountIdentification'][5]}  id  ${id}


Заповнити "Реквізити рахунку(рахунків) виконавця для сплати винагороди та/або витрат на підготовку"
	cdb2_LandLease_step.Заповнити "Найменування банку для сплати винагороди"
	cdb2_LandLease_step.Заповнити "Код ЄДРПОУ для сплати винагороди"
	cdb2_LandLease_step.Заповнити "МФО для сплати винагороди"
	cdb2_LandLease_step.Заповнити "Номер рахунку для сплати винагороди"


Заповнити "Найменування банку для сплати винагороди"
	${description}  create_sentence  3
	cdb2_LandLease_page.Заповнити bankAccount.accountIdentification.0.description  ${description}
	Set To Dictionary  ${data['bankAccount']['accountIdentification'][0]}  description  ${description}


Заповнити "Код ЄДРПОУ для сплати винагороди"
	${id}  Generate Random String  10  [LETTERS][NUMBERS]
	cdb2_LandLease_page.Заповнити bankAccount.accountIdentification.(num).id  ${id}  0
	Set To Dictionary  ${data['bankAccount']['accountIdentification'][0]}  id  ${id}


Заповнити "МФО для сплати винагороди"
	${id}  Generate Random String  10  [LETTERS][NUMBERS]
	cdb2_LandLease_page.Заповнити bankAccount.accountIdentification.(num).id  ${id}  1
	Set To Dictionary  ${data['bankAccount']['accountIdentification'][1]}  id  ${id}


Заповнити "Номер рахунку для сплати винагороди"
	${id}  Generate Random String  10  [LETTERS][NUMBERS]
	cdb2_LandLease_page.Заповнити bankAccount.accountIdentification.(num).id  ${id}  2
	Set To Dictionary  ${data['bankAccount']['accountIdentification'][2]}  id  ${id}


Заповнити "Загальну інформацію про предмет"
	cdb2_LandLease_step.Заповнити "Опис предмету"
	cdb2_LandLease_step.Заповнити "Кадастровий номер предмету"
	cdb2_LandLease_step.Заповнити "Класифікація предмету"
	cdb2_LandLease_step.Заповнити "Додаткова класифікація предмету"
	cdb2_LandLease_step.Заповнити "Кількість предмету"
	cdb2_LandLease_step.Заповнити "Одиниці виміру предмету"
	cdb2_LandLease_step.Заповнити "Поштовий індекс предмету"
	cdb2_LandLease_step.Заповнити "Місто предмету"
	cdb2_LandLease_step.Заповнити "Вулиця предмету"


Заповнити "Опис предмету"
	${description}  create_sentence  20
	cdb2_LandLease_page.Заповнити items.0.description  ${description}
	Set To Dictionary  ${data['items'][0]}  description  ${description}


Заповнити "Кадастровий номер предмету"
	${number}  random_number  1000000000000000000  9999999999999999999
	${cadastralNumber}  cdb2_LandLease_page.Заповнити items.0.additionalClassifications.1.id  ${number}
	Set To Dictionary  ${data['items'][0]['additionalClassifications'][1]}  id  ${cadastralNumber}


Заповнити "Класифікація предмету"
	${description}  cdb2_LandLease_page.Заповнити items.0.classification.description
	${id}  Evaluate  (re.findall(r'[0-9]*[-][0-9]*', "${description}"))[0]  re
	Set To Dictionary  ${data['items'][0]['classification']}  id  ${id}
	${description}  Evaluate  re.sub(r'[0-9]*[-][0-9]*.', '', "${description}", 1)  re
	Set To Dictionary  ${data['items'][0]['classification']}  description  ${description}


Заповнити "Додаткова класифікація предмету"
	${description}  cdb2_LandLease_page.Заповнити items.0.additionalClassifications.description
	${id}  Evaluate  ((re.findall(r'[0-9]*[.][0-9]*', "${description}"))[0])  re
	Set To Dictionary  ${data['items'][0]['additionalClassifications'][0]}  id  ${id}
	${description}  Evaluate  re.sub(r'[0-9]*[.][0-9]*.', '', "${description}", 1)  re
	Set To Dictionary  ${data['items'][0]['additionalClassifications'][0]}  description  ${description}


Заповнити "Кількість предмету"
	${first}  random_number  1  1000
	${second}  random_number  1  100
    ${quantity}  Evaluate  str(round(float(${first})/float(${second}), 3))
	cdb2_LandLease_page.Заповнити items.0.quantity  ${quantity}
	Set To Dictionary  ${data['items'][0]}  quantity  ${quantity}


Заповнити "Одиниці виміру предмету"
	${name}  cdb2_LandLease_page.Заповнити items.0.unit.name
	${name}  Set Variable If  '${name}' == 'м.кв.'
	...  метри квадратні  ${name}
	Set To Dictionary  ${data['items'][0]['unit']}  name  ${name}


Заповнити "Поштовий індекс предмету"
	${postalCode}  random_number  10000  99999
	cdb2_LandLease_page.Заповнити items.0.address.postalCode  ${postalCode}
	Set To Dictionary  ${data['items'][0]['address']}  postalCode  ${postalCode}


Заповнити "Місто предмету"
	${locality}  cdb2_LandLease_page.Заповнити items.0.address.locality
	${region}  Evaluate  (re.findall(r'[А-я][^(]+[.]','${locality}'))[0]  re
	Set To Dictionary  ${data['items'][0]['address']}  region  ${region}
	${locality}  Evaluate  re.sub(r'.[(].*','','${locality}')  re
	Set To Dictionary  ${data['items'][0]['address']}  locality  ${locality}


Заповнити "Вулиця предмету"
	${streetAddress}  get_some_uuid
	cdb2_LandLease_page.Заповнити items.0.address.streetAddress  ${streetAddress}
	Set To Dictionary  ${data['items'][0]['address']}  streetAddress  ${streetAddress}


Додати проект договору
	${doc}  Створити файл
	${md5}  get_checksum_md5  ${OUTPUTDIR}/${doc[1]}
	cdb2_LandLease_page.Додати документ з типом  ${doc}  Проект договору
	Set To Dictionary  ${docs_data}  title  ${doc[1]}
	Set To Dictionary  ${docs_data}  documentType  Проект договору
	Set To Dictionary  ${docs_data}  hash  md5:${md5}
    ${new docs}  Evaluate  ${docs_data}.copy()
	Append To List  ${data['documents']}  ${new docs}

