import re


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
            return list.group('quantity')
    elif 'value' in field or 'guarantee' in field or 'budgetSpent' in field or 'registrationFee' in field:
        ret = re.search(u'(?P<amount>[\d\s.]+).*', value).group('amount')
        return ret.replace(' ', '')
    elif 'minimalStep' in field:
        ret = re.search(u'(?P<percents>.+)\D{5}(?P<amount>[\d\s.]+)', value)
        if 'percents' in field:
            ret = list.group('percents')
            return ret.replace('%', '')
        elif 'amount' in field:
            ret = list.group('amount')
            return ret.replace(' ', '')
    elif 'lassification' in field and not 1 in field:
        list = re.search(u'(?P<id>\d+?-?.\d+).{3}(?P<description>.*)', value)
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
    return ret
