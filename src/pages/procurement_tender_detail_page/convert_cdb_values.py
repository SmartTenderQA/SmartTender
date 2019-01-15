# -*- coding: utf-8 -*-


#import re
import sys

sys.path.append('../../src/')

from service import convert_datetime_to_smart_format
from service import get_only_numbers


def convert_cdb_values(field, value):
    if 'Period' in field:
        ret = convert_datetime_to_smart_format(value, 'm')
    elif 'agreementDuration' in field:
        ret = get_only_numbers(value)
    elif 'locality' in field:
        ret = str(value).decode("utf-8")
    elif 'quantity' in field:
        ret = int(value)
    elif 'maxAwardsCount' in field:
        ret = str(value)
    elif 'hash' in field:
        ret = str(value[4:])
    else:
        ret = value
    return ret

