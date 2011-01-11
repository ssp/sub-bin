<?xml version="1.0" encoding="UTF-8"?>
<!--
	Used on Pica MarcXML data to extract the editor ID of the record from field 201D $b.

	Stored at: https://gist.github.com/?

	December 2010
	Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output indent="no" method="xml" omit-xml-declaration="yes" version="1.0" encoding="UTF-8" media-type="text"/>



	<xsl:template match="datafield[@tag='201D']">
		<xsl:value-of select="//datafield[@tag='003@']/subfield[@code='0']"/>
		<xsl:text>	</xsl:text>
		<xsl:value-of select="subfield[@code='b']"/>
		<xsl:text>	</xsl:text>
		<xsl:value-of select="subfield[@code='a']"/>
		<xsl:text>	</xsl:text>
		<xsl:value-of select="subfield[@code='0']"/>
		<xsl:text>
</xsl:text>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>

</xsl:stylesheet>
