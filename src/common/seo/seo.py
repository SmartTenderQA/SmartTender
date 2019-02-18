#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ==============
#      Main script file
# ==============


import requests
import re


def get_seo_data(data_type, status, page_href):
    keys = {
        'title': 1,
        'h1': 2,
        'description': 3,
        'keywords': 4,
        'seotext': 5
    }

    page_href = re.sub(r'htt[^//]+//', '', page_href)
    page_href = page_href[page_href.find('/'):]

    url = 'https://'
    if(status == 'test'):
        url += 'test.'
    url += 'smarttender.biz/Seo/GetPageSeoParam?key='
    url += page_href
    response = requests.get(url)
    data = response.json()

    for val in data:
        if(val['TypeId'] == keys[data_type]):
            return (val['SeoValue'])

    return u'Error. Відсутній seo текст'