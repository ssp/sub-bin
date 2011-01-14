<?xml version="1.0" encoding="UTF-8"?>
<!--
	Clear some crap out of Open Office generated HTML.

	November-Dezember 2010
	Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:date="http://exslt.org/dates-and-times">

<xsl:param name="fileName" />
<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>



<xsl:template match="@*|node()">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>




<!-- remove potentially wrong encoding information -->
<xsl:template match="meta[@http-equiv]">
</xsl:template>


<!-- remove font tags to make things readable -->
<xsl:template match="font">
	<xsl:apply-templates select="@*|node()"/>
</xsl:template>


<!-- add title text with file name and creation date -->
<xsl:template match="title">
	<xsl:copy>
			<xsl:text>SUB </xsl:text>
			<xsl:value-of select="$fileName" />
			<xsl:text>, konvertiert am: </xsl:text>
			<xsl:value-of select="substring-before(date:date(), '+')" />
	</xsl:copy>	
</xsl:template>


</xsl:stylesheet>

