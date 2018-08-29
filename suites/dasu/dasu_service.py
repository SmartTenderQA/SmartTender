# coding=utf-8
import re



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


def convert_monitoring_status(value):
    map = {
        u'Проект': 'draft',
        u'Відмінено': 'cancelled',
        u'Здійснення моніторингу': 'active',
        u'Знайдено порушення': True,
        u'Вирішено': 'completed',
        u'Завершено': 'closed',
        u'Рішення зупинено': 'stopped',
        u'Порушення виявлені': 'addressed',
        u'Порушення не виявлені': 'declined',
    }
    return map[value]
