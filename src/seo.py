#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ==============
#      Main script file
# ==============
import sys
import urllib2
import json

reload(sys)
sys.setdefaultencoding('utf-8')


def get_seo_data(data_type, status, page_href):
    keys = {
        'title': 1,
        'h1': 2,
        'description': 3,
        'keywords': 4,
        'seotext': 5
    }

    url = 'https://'
    if(status == 'test'):
        url += 'test.'
    url += 'smarttender.biz/Seo/GetPageSeoParam?key='
    url += page_href
    response = urllib2.urlopen(url)
    data = json.load(response)

    for val in data:
        if(val['TypeId'] == keys[data_type]):
            return (val['SeoValue'])

    return u'Error. Відсутній seo текст'