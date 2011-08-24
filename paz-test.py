#!/usr/bin/env python
import urllib
import re
import time

pazURL = 'http://10.0.5.99/pazpar2/search.pz2?command='
index = 0
queries = ['lkl=ia%206', 'lkl=pb', 'lkl=pg', 'lkl=ic%206']

while True:
	print time.strftime('%x %X')
	workingIndex = index % len(queries)
	query = queries[workingIndex]
	initURL = pazURL + 'init&service=test'
	f = urllib.urlopen(initURL)
	result = f.read()
	f.close()
	m = re.search('session>([0-9]*)</session', result)
	sessionID = m.group(1)
	print 'session: ' + sessionID
	
	query = queries[workingIndex]
	searchURL = pazURL + 'search&session=' + sessionID + '&query=' + query
 	f = urllib.urlopen(searchURL)
	result = f.read()
	f.close()
	print 'searching for: ' + query
	print ''

	time.sleep(60)
	
	index = index + 1
	
	
	
