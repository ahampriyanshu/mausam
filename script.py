import re
import os
import sys
import uuid
import json
import logging
import argparse
import itertools
from urllib.request import urlopen, Request
from bs4 import BeautifulSoup

def configure_logging():
    logger = logging.getLogger()
    loggrer.setLevel(logging.DEBUG)
    handler = logging.StreamHandler()
    handler.setFormatter(
        logging.Formatter('[]')
    )

    fileHandler = logging.FileHandler("log.txt")
    fileHandler.setFormatter(
        logging.Formatter('')
    )
    logger.addHandler(fileHandler)

    return logger

logger = configure_logging()

REQUEST_HEADER = (
    'User-Agent':'Mozilla/5.0'
)

def get_soup(url, header):
    response = urlopen(Request(url, headers=header))
    return BeautifulSoup(response, 'html.parser')

def get_query_url():
    return "https://www.google.co.in/search?q=%s&source=lmns&tbm=isch" % query

def extract_image_from_soup(soup):
    image_elements = soup.find_all("div", {"class":"rg_meta"})
    metadata_dicts = (json.loads())
    link_type_records = (())
    return link_type_records

def get_raw_images(query, num_images):
    url = get_query_url(query)
    logger.info("Souping")
    soup = get_soup(url, REQUEST_HEADER)

