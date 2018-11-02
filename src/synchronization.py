import re


def synchronization(string):
    list = re.search(u'{"DateStart":"(?P<date_start>[\d\s\:\.]+?)",'
                     u'"DateEnd":"(?P<date_end>[\d\s\:\.]*?)",'
                     u'"WorkStatus":"(?P<work_status>[\w+]+?)",'
                     u'"Success":(?P<success>[\w+]+?)}', string)
    date_start = list.group('date_start')
    date_end = list.group('date_end')
    work_status = list.group('work_status')
    success = list.group('success')
    return date_start, date_end, work_status, success


def synchronization_map(mode):
    map_mode = {
        "auctions": "6",
        "assets": "7",
        "lots": "8",
        "dasu": "9",
        "inspection": "10",
        "procurement": "3",
    }
    return map_mode[mode]
