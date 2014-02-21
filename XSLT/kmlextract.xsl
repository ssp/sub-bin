<?xml version="1.0" encoding="UTF-8"?>
<!--
	Extrahieren von Koordinaten und Ortsnamen aus vom Wikimedia Toolserver erstellten KML Daten.

	2013 Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:kml="http://earth.google.com/kml/2.1">

	<xsl:output indent="no" method="xml" omit-xml-declaration="yes" version="1.0" encoding="UTF-8" media-type="text"/>

	<xsl:template match="/">
		<xsl:text>Breite (N/S)&#x9;Länge (O/W)&#x9;Wikipedia Link&#x9;Ortsname</xsl:text>
		<xsl:apply-templates/>
	</xsl:template>


	<xsl:template match="@*|node()">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>


	<xsl:template match="//kml:Placemark">
		<xsl:value-of select="substring-before(substring-after(kml:Point/kml:coordinates, ','), ',')"/>
		<xsl:text>&#x9;</xsl:text>
		<xsl:value-of select="substring-before(kml:Point/kml:coordinates, ',')"/>

		<xsl:variable name="beschreibung">
			<xsl:value-of select="translate(substring-before(substring-after(kml:description, 'href='), '&lt;'), '&#x22;', '&#x9;')"/>
		</xsl:variable>

		<xsl:value-of select="substring-before($beschreibung, '&gt;')"/>
		<xsl:value-of select="substring-after($beschreibung, '&gt;')"/>

		<xsl:text>&#xA;</xsl:text>
	</xsl:template>

</xsl:stylesheet>
