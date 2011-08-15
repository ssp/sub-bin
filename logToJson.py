#!/usr/bin/env python
#coding=utf-8
import sys
import json
import apachelog
import hashlib



def writeRecordsToFileName (records, fileName):
	fullFileName = fileName + '.json'
	jsonFile = open(fullFileName, 'w')
	json.dump({'docs':records}, jsonFile)
	jsonFile.close()
	print "wrote file " + fullFileName
	
 
if len(sys.argv) > 1:
	parser = apachelog.parser(apachelog.formats['extended'])
	fileNumber = 1

	for fileName in sys.argv[1:]:
		records = []
		
		file = open(fileName)
		for line in file:
			try:
				data = parser.parse(line)
				record = {}
				record['date'] = data['%t'][1:-1]
				record['iptrunk'] = '.'.join(data['%h'].split('.')[0:2])
				hash = hashlib.md5()
				hash.update('smsmc0' + data['%h'])
				record['iphash'] = hash.hexdigest()
				record['status'] = data['%>s']
				record['bytes'] = data['%b']
				record['useragent'] = data['%{User-agent}i']
				record['referer'] = data['%{Referer}i']
				requestinfo = data['%r'].split(' ')
				record['requesttype'] = requestinfo[0]
				record['request'] = requestinfo[1]
				record['requestprotocol'] = requestinfo[2]
				records += [record]

				if len(records) == 1000:
					writeRecordsToFileName(records, str(fileNumber))
					fileNumber += 1
					records = []
					
			except:
				sys.stderr.write("Unable to parse %s" % line)

		file.close()

	# write remaining files
	writeRecordsToFileName(records, str(fileNumber))
		
