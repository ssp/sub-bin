<?xml version="1.0" encoding="UTF-8"?>
<!--
	Used to extract the <record> elements from SRU replies and dump the rest of the records.
		
	Example URL for input XML:
	
	http://gso.gbv.de/sru/DB=2.1/?query=pica.ppn%3D%22309041996%22&version=1.1&operation=searchRetrieve&recordSchema=pica&recordPacking=xml

	Stored at: https://gist.github.com/750153

	December 2010
	Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>

	<xsl:template match="@*|node()">
			<xsl:apply-templates select="@*|node()"/>
	</xsl:template>


	<xsl:template match="record|datafield|controlfield|subfield|@tag|@occurrence|@code|datafield/node()|controlfield/node()|subfield/node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
