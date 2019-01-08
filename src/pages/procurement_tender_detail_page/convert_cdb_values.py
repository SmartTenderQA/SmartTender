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
    else:
        ret = value
    return ret

