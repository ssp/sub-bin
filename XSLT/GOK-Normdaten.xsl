<?xml version="1.0" encoding="UTF-8"?>
<!--
	Used on OPAC XML output to create a sorted HTML list of GOK Normdaten.

	The data to process with this script can be retrieved using the OPACQuery.py command:
	
		OPACQuery.py "lkl [abcdefghijklmnopqrstuvwxyz]*" a "REC=2/PRS=XML"
	
	Or it can be retrieved directly from the OPAC using queries like
	
		http://opac.sub.uni-goettingen.de/DB=1/XML=1/SHRTST=500/FRST=1/CMD?ACT=SRCHA&IKT=1016&SRT=YOP&TRM=LKL+IA*" + query
	
	January 2011
	Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output indent="no" method="xml" omit-xml-declaration="yes" version="1.0" encoding="UTF-8" media-type="text"/>


	<xsl:template match="@*|node()">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>


	<xsl:template match="SET">
		<html>
		<head>
			<title>GOK</title>
			<style type="text/css">
				body {font-family: "Hoefler Text", Palatino, Georgia, serif;}
				.label {font-style:italic; color: #999;}
			</style>
		</head>
		<body>
			<h1>GOK</h1>
			<ul>
				<xsl:for-each select="SHORTTITLE">
					<xsl:sort select="translate(record/datafield[@tag='045A']/subfield[@code='a'], ' X', '')"/>
					<xsl:element name="li">
						<xsl:attribute name="style">margin-left: <xsl:value-of select="record/datafield[@tag='009B']/subfield[@code='a']"/>em;</xsl:attribute>
						<xsl:value-of select="record/datafield[@tag='044E']/subfield[@code='a']"/>
						<span class="label">
							<xsl:value-of select="record/datafield[@tag='045A']/subfield[@code='a']"/>
						</span>
					</xsl:element>
				</xsl:for-each>
			</ul>
		</body>
		</html>
	</xsl:template>


</xsl:stylesheet>
