# coding=utf-8
import re

from dateutil.parser import parse
from dateutil.parser import parserinfo


def convert_data_from_the_page(value, field):
    if field == 'dateCreated' or field == 'monitoring_id':
        splitter = value.split(u" від ")
        if field == 'dateCreated':
            return splitter[1]
        elif field == 'monitoring_id':
            return splitter[0]
    elif field == 'decision.date':
        response = re.search(u'\D+ (?P<date>[\d .,:]+)', value)
        return response.group('date')
    elif field == 'status':
        return convert_monitoring_status(value)
    else:
        return value, field


def compare_dates_smarttender(cdb, smarttender):
    ltr = parse(cdb, parserinfo(True, False))
    left = (ltr.strftime('%Y-%m-%dT%H:%M'))
    dtr = parse(smarttender, parserinfo(True, False))
    right = (dtr.strftime('%Y-%m-%dT%H:%M'))
    return left == right


def convert_monitoring_status(value):
    map = {
        u'Проект': 'draft',
        u'Відмінено': 'cancelled',
        u'Здійснення моніторингу': 'active',
        u'Знайдено порушення': True,
        u'Вирішено': 'completed',
        u'Завершено': 'closed',
        u'Рішення зупинено': 'stopped',
    }
    return map[value]
