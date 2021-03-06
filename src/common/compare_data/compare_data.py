# -*- coding: utf-8 -*-
import re


def get_docs_data():
	return docs_data

def get_docs_view():
	return docs_view


def compare_values(first_value, second_value):
    if re.match(u'^\d+[.]?\d*$', str(first_value)) and re.match(u'^\d+[.]?\d*$', str(second_value)):
        return float(first_value) == float(second_value)
    return str(first_value) == str(second_value)


def convert_cdb_values_to_edit_format(field, value, time_format='s'):
    if 'Period' in field or 'Date' in field or 'date' in field:
        if time_format == 's':
            list = re.search(u'(?P<year>^\d+)-(?P<month>\d+)-(?P<day>\d+)T(?P<hours>\d+):(?P<minutes>\d+):(?P<seconds>\d+)', value)
            return list.group('day')+'.'+list.group('month')+'.'+list.group('year')+' '+list.group('hours')+':'+list.group('minutes')+':'+list.group('seconds')
        elif time_format == 'm':
            list = re.search(u'(?P<year>^\d+)-(?P<month>\d+)-(?P<day>\d+)T(?P<hours>\d+):(?P<minutes>\d+)', value)
            return list.group('day') + '.' + list.group('month') + '.' + list.group('year') + ' ' + list.group('hours') + ':' + list.group('minutes')
        elif time_format == 'd':
            list = re.search(u'(?P<year>^\d+)-(?P<month>\d+)-(?P<day>\d+)', value)
            return list.group('day') + '.' + list.group('month') + '.' + list.group('year')
    elif 'accountIdentification' in field and 'description' in field:
        return value.replace('[Реквізити рахунку (рахунків) виконавця для сплати винагороди та/або витрат на підготовку] ', '')
    elif re.match(u'^\d+[.]?\d*$', str(value)):
        return repr(float(value))
    elif 'lassification' in field and 'scheme' in field and not '1' in field:
        return classification_scheme_dictionary[value]
    elif 'accountIdentification' in field and 'scheme' in field:
        return accountIdentification_scheme_dictionary[value]
    return value


def convert_viewed_values_to_edit_format(field, value, procedure='DZK'):
    if "['title']" == field:
        if not '[ТЕСТУВАННЯ]' in value:
            return '[ТЕСТУВАННЯ] ' + value
    elif 'valueAddedTaxIncluded' in field:
        if u'без ПДВ' in value:
            return False
        else:
            return True
    elif 'Period' in field:
        list = re.findall(u'[0-9.]+\s[0-9:]+', value)
        if 'start' in field:
            return list[0]
        elif 'end' in field:
            return list[1]
    elif 'minimalStep' in field:
        list = re.search(u'((?P<percents>[^%]+)\D{5})?(?P<amount>[\d\s]+,\d+).*', value)
        if 'percents' in field:
            ret = list.group('percents')
            return ret
        elif 'amount' in field:
            ret = list.group('amount')
            return ret.replace(' ', '').replace(',', '.')
    elif ('value' in field or 'guarantee' in field or 'budgetSpent' in field or 'registrationFee' in field) and 'amount' in field:
        ret = re.search(u'(?P<amount>[\d\s]+,\d+).*', value).group('amount')
        return ret.replace(' ', '').replace(',', '.')
    elif 'leaseDuration' in field:
        list = re.search(u'(?P<years>^\d+).{7}(?P<months>\d+)', value)
        if procedure == 'DZK':
            return 'P'+list.group('years')+'Y'+list.group('months')+'M'
        else:
            return 'P'+str(int(list.group('years'))*12+int(list.group('months')))+'M'
    elif 'address' in field:
        list = re.search(u'(?P<postal>\d+), (?P<country>[^,]+), ((?P<region>[^,]+), )?(?P<locality>[^,]+), (?P<street>[^,]+)', value)
        if 'postal' in field:
            return list.group('postal')
        elif 'country' in field:
            return list.group('country')
        elif 'region' in field:
            if list.group('region') is None:
                return ''
            else:
                return list.group('region')
        elif 'locality' in field:
            return list.group('locality')
        elif 'street' in field:
            return list.group('street')
    elif 'lassification' in field and not '1' in field:
        list = re.search(u'(?P<scheme>[^:]+)[:]\s+(?P<id>\d+[.-]\d+).{3}(?P<description>.*)', value)
        if 'scheme' in field:
            return list.group('scheme')
        elif 'id' in field:
            return list.group('id')
        elif 'description' in field:
            return list.group('description')
    elif 'unit' in field or 'quantity' in field:
        list = re.search(u'(?P<quantity>\S+) (?P<unit>.+)', value)
        if 'unit' in field:
            return list.group('unit')
        elif 'quantity' in field:
            return str(float(list.group('quantity')))
    elif 'decisions' in field:
        list = re.search(u'((?P<title>[^0-9]+) )?(?P<decisionID>\d+).{5}(?P<decisionDate>[0-9.]+\s[0-9:]+)', value)
        if 'title' in field:
            return list.group('title')
        elif 'decisionID' in field:
            return list.group('decisionID')
        elif 'decisionDate' in field:
            return list.group('decisionDate')
    elif 'dgfDecision' in field:
        list = re.search(u'(?P<ID>^\S+).{5}(?P<Date>[0-9.]+)', value)
        if 'ID' in field:
            return list.group('ID')
        elif 'Date' in field:
            return list.group('Date')
    return value


def get_selected_doc(doc, cdb_data):
    cdb_docs = []
    for i in cdb_data[doc['key']]:
        if i['status'] != 'invalid' and i['status'] != 'unsuccessful':
            cdb_docs = i['documents']
    for i in cdb_docs:
        if doc['title'] == i['title']:
            result = i.copy()
            result['documentType'] = documents_types_dictionary[i['documentType']]
            result['dateModified'] = convert_cdb_values_to_edit_format('date', i['dateModified'])
            return result


documents_types_dictionary = {
    "auctionProtocol": "Протокол аукціону",
    "eligibilityDocuments": "Документи, що підтверджують відповідність",
    "commercialProposal": "Цінова пропозиція",
    "qualificationDocuments": "Документи, що підтверджують кваліфікацію",
    "": "Протокол рішення",
    "contractSigned": "Договір",
}


classification_scheme_dictionary = {
    u'CPV': u'CPV',
    u'CAV-PS': u'CAV-PS',
    u'kvtspz': u'КВЦПЗ',
    u"CAV": u"CAV"
}


accountIdentification_scheme_dictionary = {
    u'UA-EDR': u'Код ЄДРПОУ',
    u'UA-MFO': u'МФО банку',
    u'accountNumber': u'Номер рахунку',
}


#<editor-fold desc="DATA">
docs_view = {
	"title": "//*[@data-qa='file-name']",
	"documentType": "//*[@data-qa='file-document-type']",
	"dateModified": "//*[@data-qa='file-date-modified']"
}
#</editor-fold>


#<editor-fold desc="DATA">
docs_data = {
	"key": "",
	"title": "",
	"documentType": "",
	"hash": "",
}
#</editor-fold>