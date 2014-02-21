<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xmap="urn:xmind:xmap:xmlns:content:2.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xd" version="1.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 26, 2012</xd:p>
            <xd:p><xd:b>Author:</xd:b> cmahnke</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:output method="text"/>
    <xsl:strip-space elements="*"/>
    <xsl:variable name="br"><xsl:text>
</xsl:text>
</xsl:variable>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="xmap:title">
            <xsl:if test="./ancestor::xmap:children">
                <xsl:for-each select="1 to count(./ancestor::xmap:children)">
                    <xsl:text>*</xsl:text>
                </xsl:for-each>        
            </xsl:if>
        <xsl:value-of select="."/>
        <xsl:value-of select="$br"/>

    </xsl:template>
    <xsl:template match="xmap:*">
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>
