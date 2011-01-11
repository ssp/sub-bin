#!/usr/bin/env python
#coding=utf-8
"""
Script doing OPAC queries to get short titles,
join the results into a single XML document
and possibly process it with XSL.

Can be used to create PPN lists from queries with extractPPNs.xsl.

January 2011
Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
"""

import urllib
import sys
from lxml import etree


query = None
xsl = None
queryParameter = None

"""
1. parameter: OPAC query to run
2. parameter (optional): path to XSLT
3. parameter (optional): additional bit to insert into URL, e.g.: REC=2
"""
if len(sys.argv) > 1:
	query = urllib.quote_plus(sys.argv[1])

	if len(sys.argv) > 2:
		try:
			xslXML = etree.parse(sys.argv[2])
			xsl = etree.XSLT(xslXML)
		except:
			sys.stderr.write("Could not read XSLT at " + sys.argv[2] + ", ignoring it.\n")

		if len(sys.argv) > 3:
			queryParameter = sys.argv[3]
else:
	print "Usage: " + sys.argv[0] + " picaQuery [pathToXSLT [additionalURLParameter]]"
	quit()


firstHit = 1
hitsPerQuery = 500
totalHits = 100000000
result = etree.XML("<RESULT><SET></SET></RESULT>")
resultElement = result.xpath("//SET")[0]

while firstHit < totalHits:
	URL = "http://opac.sub.uni-goettingen.de/DB=1/XML=1/SHRTST=" + str(hitsPerQuery)
	URL += "/FRST="  + str(firstHit)
	if queryParameter != None:
		URL += "/" + queryParameter
	URL += "/CMD?ACT=SRCHA&IKT=1016&SRT=YOP&TRM=" + query

	xmlString = urllib.urlopen(URL).read()
	xml = etree.fromstring(xmlString)

	queryResults = xml.xpath("//SET/*")
	for queryResult in queryResults:
		resultElement.append(queryResult)

	totalHits = int(xml.xpath("//SET/@hits")[0])
	sys.stderr.write("loaded: " + str(min(firstHit + hitsPerQuery - 1, totalHits)) + " of " + str(totalHits) + "\n")
	firstHit += hitsPerQuery


if xsl != None:
	result = xsl(result)


printString = etree.tostring(result, encoding="utf-8", method="xml")

if printString == None:
	# if nothing came out that's because the XSLT result is not XML anymore, we can print it as is
	printString = result

print printString
