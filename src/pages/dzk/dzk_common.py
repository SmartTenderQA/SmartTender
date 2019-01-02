import re


def get_cdb_values(value_cdb, value_should):
    if re.match(u'^\d+[.]?\d*$', str(value_cdb)) and re.match(u'^\d+[.]?\d*$', str(value_should)):
        return float(value_cdb) == float(value_should)
    if re.match(r'[0-9]{2}[.][0-9]{2}[.][0-9]{4} [0-9]{2}[:][0-9]{2}', str(value_should)):
        tmp = value_cdb.split(' ')
        date = (tmp[0]).split('.')
        date_is = date[2] + '-' + date[1] + '-' + date[0] + 'T' + tmp[1]
        return date_is in value_should
    return str(value_cdb) == str(value_should)


def get_page_values(field, value):
    if 'address' in field:
        list = re.search(u'(?P<postal>.+), (?P<country>.+), (?P<region>.+), (?P<locality>.+), (?P<street>.+)', value)
        if 'postal' in field:
            return list.group('postal')
        elif 'region' in field:
            return list.group('region')
        elif 'locality' in field:
            return list.group('locality')
        elif 'street' in field:
            return list.group('street')
    elif 'unit' in field or 'quantity' in field:
        list = re.search(u'(?P<quantity>\S+) (?P<unit>.+)', value)
        if 'unit' in field:
            return list.group('unit')
        elif 'quantity' in field:
            return str(float(list.group('quantity')))
    elif 'value' in field or 'guarantee' in field or 'budgetSpent' in field or 'registrationFee' in field:
        ret = re.search(u'(?P<amount>[\d\s.]+).*', value).group('amount')
        return ret.replace(' ', '')
    elif 'minimalStep' in field:
        list = re.search(u'(?P<percents>.+)\D{5}(?P<amount>[\d\s.]+)', value)
        if 'percents' in field:
            ret = list.group('percents')
            return ret.replace('%', '')
        elif 'amount' in field:
            ret = list.group('amount')
            return ret.replace(' ', '')
    elif 'lassification' in field and not '1' in field:
        list = re.search(u'(?P<id>\d+[.-]\d+).{3}(?P<description>.*)', value)
        if 'id' in field:
            return list.group('id')
        elif 'description' in field:
            return list.group('description')
    elif 'leaseTerms' in field:
        list = re.search(u'(?P<years>^\d+).{7}(?P<months>\d+)', value)
        if 'years' in field:
            return list.group('years')
        elif 'months' in field:
            return list.group('months')
    return value