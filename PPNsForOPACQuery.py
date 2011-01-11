#!/usr/bin/env python
import urllib
import sys
from lxml import etree


if not len(sys.argv) >= 3:
	print "Usage: " + sys.argv[0] + " picaQuery pathToXSLT [additionalURLParameter]"
	quit()


query = urllib.quote_plus(sys.argv[1])

queryParameter = ""
if len(sys.argv) > 3:
	queryParamter = sys.argv[3]

xslXML = etree.parse(sys.argv[2])
xsl = etree.XSLT(xslXML)

firstHit = 1
hitsPerQuery = 500
totalHits = 100000000
result = etree.XML("<RESULT><SET></SET></RESULT>")
resultElement = result.xpath("//SET")[0]

while firstHit < totalHits:
	URL = "http://opac.sub.uni-goettingen.de/DB=1/XML=1/SHRTST=" + str(hitsPerQuery)
	URL += "/FRST="  + str(firstHit)
	URL += "/CMD?ACT=SRCHA&IKT=1016&SRT=YOP&TRM=" + query
#	print URL

	xmlString = urllib.urlopen(URL).read()
	xml = etree.fromstring(xmlString)

	queryResults = xml.xpath("//SET/*")
	for queryResult in queryResults:
		resultElement.append(queryResult)

	totalHits = int(xml.xpath("//SET/@hits")[0])
	sys.stderr.write("loaded: " + str(firstHit + hitsPerQuery) + " of " + str(totalHits) + "\n")
	firstHit += hitsPerQuery


if xsl != None:
	result = xsl(result)

print result

