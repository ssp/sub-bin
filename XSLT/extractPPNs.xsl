<?xml version="1.0" encoding="UTF-8"?>
<!--
	Used on the XML coming from the SUB Göttingen Opac short XML records to extract
		the PPN attribute of the contained SHORTTITLE elements as one PPN per line.
		
	Example URL for the XML:
	
	http://opac.sub.uni-goettingen.de/DB=1/XML=/SHRTST=10/CMD?ACT=SRCHA&IKT=1016&SRT=YOP&TRM=test&ADI_BIB=a,b,c,e,k,l,n,r,x,z,i148,i165

	Stored at: https://gist.github.com/750094

	December 2010
	Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output indent="no" method="xml" omit-xml-declaration="yes" version="1.0" encoding="UTF-8" media-type="text"/>


	<xsl:template match="/RESULT/SET/SHORTTITLE">
		<xsl:value-of select="@PPN"/>
		<xsl:text>
</xsl:text>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>

</xsl:stylesheet>
