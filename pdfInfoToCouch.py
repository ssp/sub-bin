#!/usr/bin/env python
#coding=utf-8

import sys
import subprocess
import json
import urllib2

def pdfInfoFromString (input):
	result = {}
	lines = input.split('\n')
	for line in lines:
		if ':' in line:
			colonPosition = line.index(':')
			label = line[0:colonPosition].strip()
			content = line[colonPosition+1:].strip()
			if content == 'yes':
				content = True
			elif content == 'no':
				content = False
			result[label] = content
	return result


def postRecord (record):	
	couchurl = 'http://vlib.sub.uni-goettingen.de/couch/documentinfo/'
	postdata = json.dumps(record)
	
	auth_handler = urllib2.HTTPBasicAuthHandler()
	auth_handler.add_password(None, 'http://vlib.sub.uni-goettingen.de/couch/exk', 'pdf', 'pdf')
	opener = urllib2.build_opener(auth_handler)
	req = urllib2.Request(couchurl)
	req.add_header('Content-Type', 'application/json')
	
	couchresult = opener.open(req, postdata)


if len(sys.argv) > 1:
	fileName = sys.argv[1]

	output = subprocess.Popen(['/usr/bin/pdfinfo', fileName], stdout=subprocess.PIPE).communicate()[0]
	results = pdfInfoFromString(output)

	fileResult = subprocess.Popen(['/usr/bin/file', '-b', fileName], stdout=subprocess.PIPE).communicate()[0]
	
	results['fileName'] = fileName
	results['fileInfo'] = fileResult
	
	postRecord(results)
	


else:
	print "Usage: " + sys.argv[0] + " file"
	quit()
