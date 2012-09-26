#!/usr/bin/env python
#coding=utf-8
"""
Input: a big XML file containing Pica XML output of <record> elements.
Output: TurboMac Pica XML with one file per record. The file name is PPN.xml.
"""
import sys
from lxml import etree
import json

filename = sys.argv[1]

xslXML2 = etree.parse("/home/ssp/bin/XSLT/Remove-Namespaces.xsl")
xsl2 = etree.XSLT(xslXML2)

xslXML = etree.parse("/home/ssp/bin/XSLT/MarcXML2TurboMarc.xsl")
xsl = etree.XSLT(xslXML)


xml = etree.parse(filename)


xml = xsl2(xml)
xml = xsl(xml)
xml = xsl2(xml)

records = xml.xpath("//r")
	

for record in records:
	# Pica record
	PPNField = record.xpath(u"d003Ä/s0")
	id = None
	if len(PPNField) > 0:
		id = PPNField[0].text
	else:
		# Marc Record
		IDField = record.xpath("c001")
		if len(IDField) > 0:
			id = IDField[0].text

	if id:
		print id

		XMLFile = open (id + ".xml", "w")
		XMLFile.write(etree.tostring(record, encoding="utf-8", method="xml"))
		XMLFile.close()

	else:
		print 'Could not process record.'
