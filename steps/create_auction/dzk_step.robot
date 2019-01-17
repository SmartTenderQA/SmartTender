*** Settings ***
Library  ../../src/pages/sale/SPF/dzk/dzk_variables.py


*** Keywords ***
Створити аукціон
	start_page.Натиснути на іконку з баннеру  Комерційні тендери SmartTender
	old_search.Активувати вкладку ФГИ
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	dzk_auction.Натиснути створити аукціон
	dzk_step.Заповнити "Номер лоту"
	dzk_step.Заповнити "Найменування лоту"
	dzk_step.Заповнити "Опис лоту"
	dzk_step.Заповнити "Інформацію про організатора"
	dzk_step.Заповнити "Інформацію про контактну особу"
	dzk_step.Заповнити "Інформацію про умови аукціону"
	dzk_step.Заповнити "Банківські реквізити"
	dzk_step.Заповнити "Реквізити для перерахування реєстраційних внесків"
	dzk_step.Заповнити "Реквізити для перерахування гарантійних внесків"
	dzk_step.Заповнити "Реквізити рахунку(рахунків) виконавця для сплати винагороди та/або витрат на підготовку"
	dzk_step.Заповнити "Загальну інформацію про предмет"
	dzk_auction.Натиснути кнопку зберегти
	#todo nuzhno ubrat` posle fixa
	Wait Until Keyword Succeeds  3x  35  dzk_auction.Опублікувати аукціон у реєстрі
	###


Завантажити локатори
	${edit_locators}  dzk_variables.get_edit_locators
	${view_locators}  dzk_variables.get_view_locators
	${data}  dzk_variables.get_data
	Set Global Variable  ${edit_locators}
	Set Global Variable  ${view_locators}
	Set Global Variable  ${data}


#########################################################
#	                  Keywords							#
#########################################################
Заповнити "Номер лоту"
	${lotNumber}  random_number  10000  1000000
	dzk_auction.Заповнити lotIdentifier  ${lotNumber}
	Set To Dictionary  ${data}  lotIdentifier  ${lotNumber}


Заповнити "Найменування лоту"
	${title}  create_sentence  5
	dzk_auction.Заповнити title  ${title}
	Set To Dictionary  ${data}  title  [ТЕСТУВАННЯ] ${title}


Заповнити "Опис лоту"
	${description}  create_sentence  20
	dzk_auction.Заповнити description  ${description}
	Set To Dictionary  ${data}  description  ${description}


Заповнити "Інформацію про організатора"
	dzk_step.Заповнити "Назва організатора"
	dzk_step.Заповнити "Код ЄДРПОУ організатора"
	dzk_step.Заповнити "Поштовий індекс організатора"
	dzk_step.Заповнити "Місто організатора"
	dzk_step.Заповнити "Вулиця організатора"


Заповнити "Назва організатора"
	${legalName}  create_sentence  2
	dzk_auction.Заповнити lotHolder.identifier.legalName  ${legalName}
	Set To Dictionary  ${data['lotHolder']['identifier']}  legalName  ${legalName}


Заповнити "Код ЄДРПОУ організатора"
	${id}  random_number  10000  100000
	dzk_auction.Заповнити lotHolder.identifier.id  ${id}
	Set To Dictionary  ${data['lotHolder']['identifier']}  id  ${id}


Заповнити "Поштовий індекс організатора"
	${postalCode}  random_number  10000  99999
	dzk_auction.Заповнити lotHolder.address.postalCode  ${postalCode}
	Set To Dictionary  ${data['lotHolder']['address']}  postalCode  ${postalCode}


Заповнити "Місто організатора"
	${locality}  dzk_auction.Заповнити lotHolder.address.locality
	${region}  Evaluate  (re.findall(r'[А-я][^(]+[.]','${locality}'))[0]  re
	Set To Dictionary  ${data['lotHolder']['address']}  region  ${region}
	${locality}  Evaluate  re.sub(r'.[(].*','','${locality}')  re
	Set To Dictionary  ${data['lotHolder']['address']}  locality  ${locality}


Заповнити "Вулиця організатора"
	${streetAddress}  get_some_uuid
	dzk_auction.Заповнити lotHolder.address.streetAddress  ${streetAddress}
	Set To Dictionary  ${data['lotHolder']['address']}  streetAddress  ${streetAddress}


Заповнити "Інформацію про контактну особу"
	dzk_step.Заповнити "ПІБ контактної особи"
	dzk_step.Заповнити "Телефон контактної особи"
	dzk_step.Заповнити "Факс контактної особи"
	dzk_step.Заповнити "Email контактної особи"
	dzk_step.Заповнити "URL контактної особи"


Заповнити "ПІБ контактної особи"
	${name}  create_sentence  3
	dzk_auction.Заповнити lotHolder.contactPoint.name  ${name}
	Set To Dictionary  ${data['lotHolder']['contactPoint']}  name  ${name}


Заповнити "Телефон контактної особи"
	No Operation


Заповнити "Факс контактної особи"
	No Operation


Заповнити "Email контактної особи"
	${text}  Generate Random String  6  [LETTERS][NUMBERS]
	${email}  Set Variable  ${text}@gmail.com
	dzk_auction.Заповнити lotHolder.contactPoint.email  ${email}
	Set To Dictionary  ${data['lotHolder']['contactPoint']}  email  ${email}


Заповнити "URL контактної особи"
	No Operation


Заповнити "Інформацію про умови аукціону"
	dzk_step.Заповнити "Дата проведення аукціону"
	dzk_step.Заповнити "Лоти виставляються"
	dzk_step.Заповнити "Мінімальна кількість учасників аукціону"
	dzk_step.Заповнити "Тривалість оренди Років"
	dzk_step.Заповнити "Тривалість оренди Місяців"
	dzk_step.Заповнити "Стартова ціна об’єкта"
	dzk_step.Заповнити "Крок електронного аукціону"
	dzk_step.Заповнити "Розмір гарантійного внеску"
	dzk_step.Заповнити "Вартість підготовки лоту до торгів"
	dzk_step.Заповнити "Реєстраційний внесок"


Заповнити "Дата проведення аукціону"
	${delta minutes}  Set Variable  33
	${start}  Evaluate  '{:%d.%m.%Y %H:%M:%S}'.format(datetime.datetime.now() + datetime.timedelta(minutes=int(${delta minutes})))  datetime
	dzk_auction.Заповнити auctionPeriod.shouldStartAfter  ${start}
	Set To Dictionary  ${data['auctionPeriod']}  shouldStartAfter  ${start}


Заповнити "Лоти виставляються"
	${tenderAttempts}  dzk_auction.Заповнити tenderAttempts
	Set To Dictionary  ${data}  tenderAttempts  ${tenderAttempts}


Заповнити "Мінімальна кількість учасників аукціону"
	${minNumberOfQualifiedBids}  dzk_auction.Заповнити minNumberOfQualifiedBids
	Set To Dictionary  ${data}  minNumberOfQualifiedBids  ${minNumberOfQualifiedBids}


Заповнити "Тривалість оренди Років"
	${years}  random_number  1  100
	dzk_auction.Заповнити contractTerms.leaseTerms.years  ${years}
	${leaseDuration}  Set Variable If
	...  '${data['contractTerms']['leaseTerms']['leaseDuration']}' == ''  P0Y0M
	...  '${data['contractTerms']['leaseTerms']['leaseDuration']}' != ''  ${data['contractTerms']['leaseTerms']['leaseDuration']}
	${leaseDuration}  Evaluate  re.sub(r'P[0-9]*Y', 'P${years}Y', '${leaseDuration}')  re
	Set To Dictionary  ${data['contractTerms']['leaseTerms']}  leaseDuration  ${leaseDuration}


Заповнити "Тривалість оренди Місяців"
	${months}  random_number  1  12
	dzk_auction.Заповнити contractTerms.leaseTerms.months  ${months}
	${leaseDuration}  Set Variable If
	...  '${data['contractTerms']['leaseTerms']['leaseDuration']}' == ''  P0Y0M
	...  '${data['contractTerms']['leaseTerms']['leaseDuration']}' != ''  ${data['contractTerms']['leaseTerms']['leaseDuration']}
	${leaseDuration}  Evaluate  re.sub(r'Y[0-9]*M', 'Y${months}M', '${leaseDuration}')  re
	Set To Dictionary  ${data['contractTerms']['leaseTerms']}  leaseDuration  ${leaseDuration}


Заповнити "Стартова ціна об’єкта"
	${value}  random_number  10000  500000
	dzk_auction.Заповнити value.amount  ${value}
	Set To Dictionary  ${data['value']}  amount  ${value}


Заповнити "Крок електронного аукціону"
	${minimalStep}  random_number  100  10000
	dzk_auction.Заповнити minimalStep.amount  ${minimalStep}
	Set To Dictionary  ${data['minimalStep']}  amount  ${minimalStep}


Заповнити "Розмір гарантійного внеску"
	${guarantee}  random_number  100  1000
	dzk_auction.Заповнити guarantee.amount  ${guarantee}
	Set To Dictionary  ${data['guarantee']}  amount  ${guarantee}


Заповнити "Вартість підготовки лоту до торгів"
	${budgetSpent}  random_number  100  1000
	dzk_auction.Заповнити budgetSpent.amount  ${budgetSpent}
	Set To Dictionary  ${data['budgetSpent']}  amount  ${budgetSpent}


Заповнити "Реєстраційний внесок"
	${registrationFee}  random_number  100  1000
	dzk_auction.Заповнити registrationFee.amount  ${registrationFee}
	Set To Dictionary  ${data['registrationFee']}  amount  ${registrationFee}


Заповнити "Банківські реквізити"
	dzk_step.Заповнити "Найменування банку"
	dzk_step.Заповнити "Опис банку"


Заповнити "Найменування банку"
	${bankName}  create_sentence  5
	dzk_auction.Заповнити bankAccount.bankName  ${bankName}
	Set To Dictionary  ${data['bankAccount']}  bankName  ${bankName}


Заповнити "Опис банку"
	No Operation


Заповнити "Реквізити для перерахування реєстраційних внесків"
	dzk_step.Заповнити "Код ЄДРПОУ для реєстраційних внесків"
	dzk_step.Заповнити "МФО для реєстраційних внесків"
	dzk_step.Заповнити "Номер рахунку для реєстраційних внесків"


Заповнити "Код ЄДРПОУ для реєстраційних внесків"
    ${id}  Generate Random String  10  [LETTERS][NUMBERS]
    dzk_auction.Заповнити bankAccount.accountIdentification.(num).id  ${id}  6
    Set To Dictionary  ${data['bankAccount']['accountIdentification'][6]}  id  ${id}


Заповнити "МФО для реєстраційних внесків"
    ${id}  Generate Random String  10  [LETTERS][NUMBERS]
    dzk_auction.Заповнити bankAccount.accountIdentification.(num).id  ${id}  7
    Set To Dictionary  ${data['bankAccount']['accountIdentification'][7]}  id  ${id}


Заповнити "Номер рахунку для реєстраційних внесків"
    ${id}  Generate Random String  10  [LETTERS][NUMBERS]
    dzk_auction.Заповнити bankAccount.accountIdentification.(num).id  ${id}  8
    Set To Dictionary  ${data['bankAccount']['accountIdentification'][8]}  id  ${id}


Заповнити "Реквізити для перерахування гарантійних внесків"
	dzk_step.Заповнити "Код ЄДРПОУ для гарантійних внесків"
	dzk_step.Заповнити "МФО для гарантійних внесків"
	dzk_step.Заповнити "Номер рахунку для гарантійних внесків"


Заповнити "Код ЄДРПОУ для гарантійних внесків"
    ${id}  Generate Random String  10  [LETTERS][NUMBERS]
    dzk_auction.Заповнити bankAccount.accountIdentification.(num).id  ${id}  3
    Set To Dictionary  ${data['bankAccount']['accountIdentification'][3]}  id  ${id}


Заповнити "МФО для гарантійних внесків"
    ${id}  Generate Random String  10  [LETTERS][NUMBERS]
    dzk_auction.Заповнити bankAccount.accountIdentification.(num).id  ${id}  4
    Set To Dictionary  ${data['bankAccount']['accountIdentification'][4]}  id  ${id}


Заповнити "Номер рахунку для гарантійних внесків"
    ${id}  Generate Random String  10  [LETTERS][NUMBERS]
    dzk_auction.Заповнити bankAccount.accountIdentification.(num).id  ${id}  5
    Set To Dictionary  ${data['bankAccount']['accountIdentification'][5]}  id  ${id}


Заповнити "Реквізити рахунку(рахунків) виконавця для сплати винагороди та/або витрат на підготовку"
	dzk_step.Заповнити "Найменування банку для сплати винагороди"
	dzk_step.Заповнити "Код ЄДРПОУ для сплати винагороди"
	dzk_step.Заповнити "МФО для сплати винагороди"
	dzk_step.Заповнити "Номер рахунку для сплати винагороди"


Заповнити "Найменування банку для сплати винагороди"
	${description}  create_sentence  3
	dzk_auction.Заповнити bankAccount.accountIdentification.0.description  ${description}
	Set To Dictionary  ${data['bankAccount']['accountIdentification'][0]}  description  ${description}


Заповнити "Код ЄДРПОУ для сплати винагороди"
	${id}  Generate Random String  10  [LETTERS][NUMBERS]
	dzk_auction.Заповнити bankAccount.accountIdentification.(num).id  ${id}  0
	Set To Dictionary  ${data['bankAccount']['accountIdentification'][0]}  id  ${id}


Заповнити "МФО для сплати винагороди"
	${id}  Generate Random String  10  [LETTERS][NUMBERS]
	dzk_auction.Заповнити bankAccount.accountIdentification.(num).id  ${id}  1
	Set To Dictionary  ${data['bankAccount']['accountIdentification'][1]}  id  ${id}


Заповнити "Номер рахунку для сплати винагороди"
	${id}  Generate Random String  10  [LETTERS][NUMBERS]
	dzk_auction.Заповнити bankAccount.accountIdentification.(num).id  ${id}  2
	Set To Dictionary  ${data['bankAccount']['accountIdentification'][2]}  id  ${id}


Заповнити "Загальну інформацію про предмет"
	dzk_step.Заповнити "Опис предмету"
	dzk_step.Заповнити "Кадастровий номер предмету"
	dzk_step.Заповнити "Класифікація предмету"
	dzk_step.Заповнити "Додаткова класифікація предмету"
	dzk_step.Заповнити "Кількість предмету"
	dzk_step.Заповнити "Одиниці виміру предмету"
	dzk_step.Заповнити "Поштовий індекс предмету"
	dzk_step.Заповнити "Місто предмету"
	dzk_step.Заповнити "Вулиця предмету"


Заповнити "Опис предмету"
	${description}  create_sentence  20
	dzk_auction.Заповнити items.0.description  ${description}
	Set To Dictionary  ${data['items'][0]}  description  ${description}


Заповнити "Кадастровий номер предмету"
	${number}  random_number  1000000000000000000  9999999999999999999
	${cadastralNumber}  dzk_auction.Заповнити items.0.additionalClassifications.1.id  ${number}
	Set To Dictionary  ${data['items'][0]['additionalClassifications'][1]}  id  ${cadastralNumber}


Заповнити "Класифікація предмету"
	${description}  dzk_auction.Заповнити items.0.classification.description
	${id}  Evaluate  (re.findall(r'[0-9]*[-][0-9]*', "${description}"))[0]  re
	Set To Dictionary  ${data['items'][0]['classification']}  id  ${id}
	${description}  Evaluate  re.sub(r'[0-9]*[-][0-9]*.', '', "${description}", 1)  re
	Set To Dictionary  ${data['items'][0]['classification']}  description  ${description}


Заповнити "Додаткова класифікація предмету"
	${description}  dzk_auction.Заповнити items.0.additionalClassifications.description
	${id}  Evaluate  ((re.findall(r'[0-9]*[.][0-9]*', "${description}"))[0])  re
	Set To Dictionary  ${data['items'][0]['additionalClassifications'][0]}  id  ${id}
	${description}  Evaluate  re.sub(r'[0-9]*[.][0-9]*.', '', "${description}", 1)  re
	Set To Dictionary  ${data['items'][0]['additionalClassifications'][0]}  description  ${description}


Заповнити "Кількість предмету"
	${first}  random_number  1  1000
	${second}  random_number  1  100
    ${quantity}  Evaluate  str(round(float(${first})/float(${second}), 3))
	dzk_auction.Заповнити items.0.quantity  ${quantity}
	Set To Dictionary  ${data['items'][0]}  quantity  ${quantity}


Заповнити "Одиниці виміру предмету"
	${name}  dzk_auction.Заповнити items.0.unit.name
	${name}  Set Variable If  '${name}' == 'м.кв.'
	...  метри квадратні  ${name}
	Set To Dictionary  ${data['items'][0]['unit']}  name  ${name}


Заповнити "Поштовий індекс предмету"
	${postalCode}  random_number  10000  99999
	dzk_auction.Заповнити items.0.address.postalCode  ${postalCode}
	Set To Dictionary  ${data['items'][0]['address']}  postalCode  ${postalCode}


Заповнити "Місто предмету"
	${locality}  dzk_auction.Заповнити items.0.address.locality
	${region}  Evaluate  (re.findall(r'[А-я][^(]+[.]','${locality}'))[0]  re
	Set To Dictionary  ${data['items'][0]['address']}  region  ${region}
	${locality}  Evaluate  re.sub(r'.[(].*','','${locality}')  re
	Set To Dictionary  ${data['items'][0]['address']}  locality  ${locality}


Заповнити "Вулиця предмету"
	${streetAddress}  get_some_uuid
	dzk_auction.Заповнити items.0.address.streetAddress  ${streetAddress}
	Set To Dictionary  ${data['items'][0]['address']}  streetAddress  ${streetAddress}