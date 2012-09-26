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
import os
from lxml import etree
import simplejson


NamespaceMap = {None: "http://www.indexdata.com/turbomarc"}



""" 
	stolen from xml2json 
	https://github.com/mutaku/xml2json
	added simplistic stripping of namespace from the tag names
"""
def elem_to_internal(elem, strip=1):

    """Convert an Element into an internal dictionary (not JSON!)."""

    d = {}
    for key, value in elem.attrib.items():
        d['@'+key] = value

    # loop over subelements to merge them
    for subelem in elem:
        v = elem_to_internal(subelem, strip=strip)
        tag = subelem.tag
        tagWithoutNamespace = tag .rpartition('}')[2]
        value = v[tag]
        try:
            # add to existing list for this tag
            d[tagWithoutNamespace].append(value)
        except AttributeError:
            # turn existing entry into a list
            d[tagWithoutNamespace] = [d[tagWithoutNamespace], value]
        except KeyError:
            # add a new non-list entry
            d[tagWithoutNamespace] = value
    text = elem.text
    tail = elem.tail
    if strip:
        # ignore leading and trailing whitespace
        if text: text = text.strip()
        if tail: tail = tail.strip()

    if tail:
        d['#tail'] = tail

    if d:
        # use #text element if other attributes exist
        if text: d["#text"] = text
    else:
        # text is the value if no attributes
        d = text or None
    return {elem.tag: d}






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
	bulkJSON = {'docs': []}
	
	totalHits = int(xml.xpath("//SET/@hits")[0])
	sys.stderr.write("loaded: " + str(min(firstHit + hitsPerQuery - 1, totalHits)) + " of " + str(totalHits) + "\n")

	records = xml.xpath("//record")

	for record in records:
		PPN = record.xpath("datafield[@tag='003@']/subfield[@code='0']")[0].text

		if xsl != None:
			record = xsl(record)
			
		folder1 = PPN[-4:-2]
		folder2 = PPN[-2:]
		subfolder = folder1 + '/' + folder2
		if not os.path.exists(subfolder):
		    os.makedirs(subfolder)
		
		PPNXML = etree.tostring(record, encoding="utf-8", method="xml")
		PPNXMLFile = open (subfolder + '/' + PPN + ".xml", "w")
		PPNXMLFile.write(PPNXML)
		PPNXMLFile.close()
		
		if hasattr(record, 'getroot'):
			record = record.getroot()
		JSONInternal = elem_to_internal(record, strip=1)
		if len(JSONInternal) == 1:
			JSONInternal = JSONInternal.values()[0]
		
		""" Add ID for CouchDB to JSON """
		JSONInternal['_id'] = PPN
		PPNJSONFile = open (subfolder + '/' + PPN + ".js", "w")
		PPNJSONFile.write(simplejson.dumps(JSONInternal))
		PPNJSONFile.close()
		bulkJSON['docs'] += [JSONInternal]
		print 'wrote ' + PPN + ' .xml/.js'
		
	
	number = '%08u' % firstHit
	folder1 = number[-8:-6]
	folder2 = number[-6:-4]
	subfolder = '_bulk/' + folder1 + '/' + folder2
	if not os.path.exists(subfolder):
	    os.makedirs(subfolder)
	bulkXMLFile = open(subfolder + '/' + number + '.xml', 'w')
	bulkXMLFile.write(xmlString)
	bulkXMLFile.close()

	bulkJSONFile = open(subfolder + '/' + number + '.js', 'w')
	bulkJSONFile.write(simplejson.dumps(bulkJSON))
	bulkJSONFile.close()
	print 'wrote records _bulk/' + number + '.xml/.js'


	
		
	firstHit += hitsPerQuery

