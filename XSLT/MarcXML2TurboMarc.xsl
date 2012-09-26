<?xml version="1.0" encoding="UTF-8"?>
<!--
	Converts MarcXML to TurboMarc
		(to benefit from pazpar2's improved tmarc.xsl)

	Also includes a provision to handle PicaMarc where datafield names can
		contain a @ that is changed to Ä to give valid XML.

	2010-2011
	Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:tmarc="http://www.indexdata.com/turbomarc">

<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>

<xsl:template match="@*|node()">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>


<xsl:template match="record">
	<xsl:element name="r" namespace="http://www.indexdata.com/turbomarc">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:element>
</xsl:template>


<xsl:template match="leader">
	<xsl:element name="l" namespace="http://www.indexdata.com/turbomarc">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:element>
</xsl:template>


<xsl:template match="controlfield|datafield|subfield">
	<!--
		Try to mock Index Data’s specification without regexps:
		Translate all allowed characters to 'a' and assume field names are
		shorter than 62 characters.
		Given the typical 3 digit Marc field numbers this seems
		safe in the practical cases I have seen.
		If a datafield’s name contains a / translate move rest of the name
		to the 'occurrence' attribute.

		http://www.indexdata.com/blog/2010/05/turbomarc-faster-xml-marc-records
		http://www.indexdata.com/yaz/doc/marc.html
	-->

	<xsl:variable name="allowedCharacters" select="'0123465789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@'"/>
	<xsl:variable name="manyAs" select="'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'"/>

	<xsl:choose>

		<xsl:when test="( name(.)='datafield' or name(.)='controlfield') and
						contains($manyAs, translate(@tag, concat($allowedCharacters, '/'), $manyAs))">

			<xsl:variable name="prepareTagname">
				<xsl:choose>
					<xsl:when test="contains(@tag, '/')">
							<xsl:value-of select="substring-before(@tag, '/')"/>
					</xsl:when>
					<xsl:otherwise>
							<xsl:value-of select="@tag"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="tagname">
				<xsl:value-of select="concat(substring(local-name(),1,1),
												translate($prepareTagname, '@', 'Ä'))"/>
			</xsl:variable>

			<xsl:variable name="occurrence">
				<xsl:if test="contains(@tag, '/')">
					<xsl:value-of select="substring-after(@tag, '/')"/>
				</xsl:if>
			</xsl:variable>

			<xsl:element name="{$tagname}" namespace="http://www.indexdata.com/turbomarc">
				<xsl:if test="$occurrence != ''">
					<xsl:attribute name="occurrence">
						<xsl:value-of select="$occurrence"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates select="@*[name(.)!='tag']|node()"/>
			</xsl:element>
		</xsl:when>

		<xsl:when test="name(.)='subfield' and
						contains($manyAs, translate(@code, $allowedCharacters, $manyAs))">
			<xsl:element name="{concat(substring(local-name(),1,1), @code)}"
							namespace="http://www.indexdata.com/turbomarc">
				<xsl:apply-templates select="@*[name(.)!='code']|node()"/>
			</xsl:element>
		</xsl:when>

		<xsl:otherwise>
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:otherwise>

	</xsl:choose>
</xsl:template>


</xsl:stylesheet>

