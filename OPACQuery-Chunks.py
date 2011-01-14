#!/usr/bin/env python
#coding=utf-8
"""
Script doing OPAC queries to get full titles,
possibly apply XSL and write each record to its own file.
The file name is determined by the PPN in field 003@ $0 of each record.

Can be used to download records from the Opac.

Using MarcXML2TurboMarc.xsl on them appears to be a good idea.

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
hitsPerQuery = 100
totalHits = 100000000

while firstHit < totalHits:
	URL = "http://opac.sub.uni-goettingen.de/DB=1/XML=1/SHRTST=" + str(hitsPerQuery)
	URL += "/FRST="  + str(firstHit)
	if queryParameter != None:
		URL += "/" + queryParameter
	URL += "/PRS=XML"
	URL += "/CMD?ACT=SRCHA&IKT=1016&SRT=YOP&TRM=" + query
	print URL
	
	xmlString = urllib.urlopen(URL).read()
	xml = etree.fromstring(xmlString)

	totalHits = int(xml.xpath("//SET/@hits")[0])
	sys.stderr.write("loaded: " + str(min(firstHit + hitsPerQuery - 1, totalHits)) + " of " + str(totalHits) + "\n")

	records = xml.xpath("//record")

	for record in records:
		PPN = record.xpath("datafield[@tag='003@']/subfield[@code='0']")[0].text
		print PPN

		if xsl != None:
			record = xsl(record)

		PPNFile = open (PPN + ".xml", "w")
		PPNFile.write(etree.tostring(record, encoding="utf-8", method="xml"))
		PPNFile.close()
		
	firstHit += hitsPerQuery

