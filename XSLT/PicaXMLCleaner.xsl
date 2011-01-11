<?xml version="1.0" encoding="UTF-8"?>
<!--
	Removes @ characters from <datafield> 'tag' attributes, which can appear
		in Pica Marc XML output, and replaces them with AA.
		
	The resulting XML can be converted to indexdata’s TurboMarc format using 
		MarcXML2TurboMarc.xsl with Pica fields like 003@ ending up in <d003AA> Tags.

	January 2011
	Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->

<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<xsl:template match="@*|node()">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>


<xsl:template match="@tag[substring(., 4, 1)='@']">
	<xsl:attribute name="tag">
		<xsl:value-of select="concat(substring(., 1, 3), 'AA')"/>
	</xsl:attribute>
</xsl:template>


</xsl:stylesheet>
