#!/usr/bin/env python
#coding=utf-8

import urllib2
from lxml import etree
from datetime import *
import json

hitcountXPath = '/RESULT/SET/@hits'


def getResultsFor (name):
	opacBaseURL = 'http://opac.sub.uni-goettingen.de/DB=1/XML=1/CMD?ACT=SRCHA&TRM=exk+ref+'
	opacURL = opacBaseURL + name

	xmlString = urllib2.urlopen(opacURL).read()
	xml = etree.fromstring(xmlString)
	
	allBooks = xml.xpath(hitcountXPath)[0]
	
	opacURL = opacBaseURL + name + '+AND+LKL+[ABCDEFGHIJKLMNOPQRSTUVWXYZ]*'
	
	xmlString = urllib2.urlopen(opacURL).read()
	xml = etree.fromstring(xmlString)
	
	readyBooks = xml.xpath(hitcountXPath)[0]

	data = {}
	data['person'] = name
	data['date'] = datetime.today().isoformat()
	data['allBooks'] = allBooks
	data['readyBooks'] = readyBooks
	
	couchurl = 'http://vlib.sub.uni-goettingen.de/couch/exk/'
	postdata = json.dumps(data)
	
	auth_handler = urllib2.HTTPBasicAuthHandler()
	auth_handler.add_password(None, 'http://vlib.sub.uni-goettingen.de/couch/exk', 'exk', 'exk')
	opener = urllib2.build_opener(auth_handler)
	req = urllib2.Request(couchurl)
	req.add_header('Content-Type', 'application/json')
	
	couchresult = opener.open(req, postdata)



getResultsFor('ds')
getResultsFor('en')
getResultsFor('ha')
getResultsFor('pf')
