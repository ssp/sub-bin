<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    version="1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"
    xmlns:mabxml="http://www.ddb.de/professionell/mabxml/mabxml-1.xsd">

    <!-- define variables -->
    <!-- header variables: -->
    <xsl:variable name="headerRecordLength" select="'00000'"/>
    <!-- 00-04 -->
    <xsl:variable name="typeOfControlAndConstants" select="' a22'"/>
    <!-- 08 09 10 11 -->
    <xsl:variable name="addressFake" select="'00000'"/>
    <!-- 12 - 16 -->
    <xsl:variable name="encodingLevelAndConstants" select="'&#x20;&#x20;&#x20;'"/>
    <!--  17 18 19 -->
    <xsl:variable name="entryMap" select="'4500'"/>
    <!--  20 - 23 -->

		<!-- TODO parameterize this aleph-url -->
		<xsl:variable name="alephXUrl" select="'https://aleph.uibk.ac.at/X'" />

		<!-- TODO parameterize this alephBase -->
		<xsl:variable name="alephXBase" select="'UBI01'" />


    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:preserve-space elements="*"/>

    <xsl:template match="/">
        <collection xmlns="http://www.loc.gov/MARC21/slim"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/MARC21/slim
            http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
            <xsl:for-each select="present/record">
                <record xmlns="http://www.loc.gov/MARC21/slim"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:schemaLocation="http://www.loc.gov/MARC21/slim
            http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">

                    <!-- TODO what is ind1, ind2? -->
                    <!-- generate leader -->
                    <!-- 052 seems not to exist -->
                    <xsl:call-template name="generateLeader">
                        <xsl:with-param name="typeOfRecord">
                            <xsl:call-template name="getMarcLeader06ByMab050">
                                <xsl:with-param name="mab050">
                                    <xsl:value-of select="metadata/oai_marc/fixfield[@id='050']/text()"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="bibliographicLevel">
                            <xsl:call-template name="getMarcLeader07ByMab051AndMab52">
                                <xsl:with-param name="mab051">
                                    <xsl:value-of
                                        select="metadata/oai_marc/fixfield[@id='051']/text()"/>
                                </xsl:with-param>
                                <xsl:with-param name="mab052">
                                    <xsl:value-of
                                        select="metadata/oai_marc/fixfield[@id='052']/text()"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                    <!-- sysid: mab001 ==> marc001 -->
                    <xsl:call-template name="generateSysId">
                        <xsl:with-param name="field001">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='001']/subfield[@label='a']/text()"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <!-- 007:[0-1] contain info about type of record -->
                    <xsl:call-template name="generateMarc007">
                        <xsl:with-param name="pos0">
                            <xsl:call-template name="getMarc007Pos0ByMab50a">
                                <!-- acually its not 50a its 50! -->
                                <xsl:with-param name="mab050a">
                                    <xsl:value-of select="metadata/oai_marc/fixfield[@id='050']/text()"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="pos1">
                            <xsl:call-template name="getMarc007Pos1ByMab50a">
                                <xsl:with-param name="mab050a">
                                    <xsl:value-of select="metadata/oai_marc/fixfield[@id='050']/text()"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                    <!-- need to build 008 since i have leader07: (type of record) -->
                    <xsl:call-template name="generateMarc008">
                        <xsl:with-param name="pos21">
                            <xsl:call-template name="getMarc008Pos21ByMab52">
                                <xsl:with-param name="mab052">
                                    <xsl:value-of
                                        select="metadata/oai_marc/fixfield[@id='052']/text()"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                    <!-- 1.author: mab100a => marc100a -->
                    <!-- mab100b => marc700b -->
                    <xsl:call-template name="generateFirstAuthor">
                        <xsl:with-param name="firstAuthor">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='100']/subfield[@label='a']/text()"/>
                        </xsl:with-param>
                        <xsl:with-param name="firstAuthorsAddition">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='100']/subfield[@label='b']/text()"/>
                        </xsl:with-param>                        
                        <xsl:with-param name="mab010a">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='010']/subfield[@label='a']/text()"/>
                        </xsl:with-param>
                    </xsl:call-template>


                    <!-- mab100ind1="f" 700$4 "hnr" (honoree) -->
                    <!-- mab100ind1="e" 700$4 "prf" (performer) -->
                    
                    <!-- 2nd author: -->
                    <xsl:call-template name="generateOtherAuthor">
                        <xsl:with-param name="otherAuthor">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='104']/subfield[@label='a']/text()"/>
                        </xsl:with-param>
                        <xsl:with-param name="otherAuthorAddition">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='104']/subfield[@label='b']/text()"/>
                        </xsl:with-param>                        
                        <xsl:with-param name="parentRecordId">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='010']/subfield[@label='a']/text()"/>
                        </xsl:with-param>                        
                    </xsl:call-template>
                    
                    <!-- 3rd author: -->
                    <xsl:call-template name="generateOtherAuthor">
                        <xsl:with-param name="otherAuthor">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='108']/subfield[@label='a']/text()"/>
                        </xsl:with-param>
                        <xsl:with-param name="otherAuthorAddition">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='108']/subfield[@label='b']/text()"/>
                        </xsl:with-param>                        
                        <xsl:with-param name="parentRecordId">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='010']/subfield[@label='a']/text()"/>
                        </xsl:with-param>                     
                    </xsl:call-template>                    
                    
                    <!-- title: mab:331ab => marc:245ab -->
                    <!-- band: mab089a => marc 245n -->
                    <xsl:call-template name="generateTitle">
                        <xsl:with-param name="mabTitleA">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='331']/subfield[@label='a']/text()"/>
                        </xsl:with-param>
                        <xsl:with-param name="mabTitleB">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='331']/subfield[@label='b']/text()"/>
                        </xsl:with-param>
                        <xsl:with-param name="mab089a">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='089']/subfield[@label='a']/text()"/>
                        </xsl:with-param>
                        <xsl:with-param name="mab010a">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='010']/subfield[@label='a']/text()"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <!-- mab:412a => marc:260f (drucker) -->
                    <!-- publisher: mab:412a => 260f ?!-->
                    <xsl:call-template name="generatePublisher">
                        <xsl:with-param name="publisherName">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='412']/subfield[@label='a']/text()"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <!-- date published: 425 => marc: 260c ?! -->
                    <xsl:call-template name="generatePublishedDate">
                        <xsl:with-param name="publishingDate">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='425']/subfield[@label='a']/text()"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <!-- language: mab: 516a => marc: 041a -->

                    <!-- http://d-nb.info/gnd/4011882-4/about/html <=> http://138.232.114.235/vufind/Record/01441032 -->
                    <!-- schlagwort?: 902c?! -->
                    <!-- typ?: 902b -->
                    <!-- mab: 036 ind1=a din en 23166 laendercode => marc: -->

                    <!-- verleger: mab410,415,418 => marc ? -->
                    <!-- druckort: mab410a => marc260a -->
                    <xsl:call-template name="generatePlaceOfPublication">
                        <xsl:with-param name="mab410a">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='410']/subfield[@label='a']/text()"/>
                        </xsl:with-param>
                    </xsl:call-template>

                    <!-- mab417a => marc260b -->
                    <xsl:call-template name="generateNameOfPublisher">
                        <xsl:with-param name="mab417a">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='417']/subfield[@label='a']/text()"/>
                        </xsl:with-param>
                    </xsl:call-template>
<!-- TODO 
    ind1=a 2buchatbiger laendercode
    ind1=b 3buchstabiger laendercode
    ind1=c  laendercode swd
    beispiel uibk:
    <varfield id="036" i1="a" i2=" ">
    <subfield label="a">GB</subfield>
    </varfield>
    konkordanz p12
    -->
                    
                    <xsl:call-template name="generateCountry">
                        <xsl:with-param name="dinEn23166countryCode">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='036']/subfield[@label='a']/text()"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <!-- uibk: mab 037 ind1=b  iso 639 -->
                    <!--  -->
                    <!-- marc language codes: http://www.loc.gov/standards/codelists/languages.xml -->
                    <!-- TODO get lang from parent if we have one! -->
                    <xsl:call-template name="generateMultiLanguage">
                        <xsl:with-param name="languages">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='037']/subfield[@label='a']/text()"/>
                        </xsl:with-param>
                    </xsl:call-template>

                    <!-- mab:088a url => marc: 856u -->
                    <!-- uibk: 655u => marc: 856u (konkordanz s96) -->
                    <xsl:call-template name="generateUrl">
                        <xsl:with-param name="url">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='655']/subfield[@label='u']/text()"/>
                        </xsl:with-param>
                    </xsl:call-template>

                    <!-- "umfangsangabe: mab 433a => marc300a -->
                    <xsl:call-template name="generatePhysicalDescription">
                        <xsl:with-param name="mab433a">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='433']/subfield[@label='a']/text()"/>
                        </xsl:with-param>
                    </xsl:call-template>

                    <!-- TODO get edition from parent -->
                    <xsl:call-template name="generateEdition">
                        <xsl:with-param name="mab403a">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='403']/subfield[@label='a']/text()" />
                        </xsl:with-param>
                    </xsl:call-template>

                    <!-- TODO: serie: mab454 => marc 800a?!?! konkordanz seite 64-->
                    <xsl:call-template name="generateSeries">
                        <xsl:with-param name="mab454a">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='454']/subfield[@label='a']/text()" />
                        </xsl:with-param>
                    </xsl:call-template>
                    
                    
                    <!-- herkunftsangaben mab525a => marc500a p71 -->
                    <xsl:call-template name="generateGeneralNote">
                        <xsl:with-param name="mab525a">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='525']/subfield[@label='a']/text()" />
                        </xsl:with-param>
                    </xsl:call-template>
                    
                    <!-- series statements: mab451a => marc490a -->
                    <xsl:call-template name="generateSeriesStatement">
                        <xsl:with-param name="mab451a">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='451']/subfield[@label='a']/text()" />
                        </xsl:with-param>
                    </xsl:call-template>
                    
                    <!-- mab527a => marc775a ?!?! -->
                    <!-- konkordanz p72 -->
                    <xsl:call-template name="generateOtherEditionEntry">
                        <xsl:with-param name="mab527a">
                            <xsl:value-of select="metadata/oai_marc/varfield[@id='527']/subfield[@label='a']/text()" />
                        </xsl:with-param>
                    </xsl:call-template>
                </record>
            </xsl:for-each>
        </collection>
    </xsl:template>

    <xsl:template name="getMarc007Pos0ByMab50a">
        <!-- TODO and others ?! -->
        <xsl:param name="mab050a"/>


        <!--
            050a:[10]:a   => 007:0:a  ()                   p20
            050a:08:a     => 007:0:c (computer file)      p19
            050a:[8]:b    => 007:0:c ()                   p19
            050a:[8]:c    => 007:0:c ()                   p19
            050a:[8]:d    => 007:0:c ()                   p19
            050a:[8]:e    => 007:0:c ()                   p19
            050a:[8]:f    => 007:0:c ()                   p19
            
            050a:4:a      => 007:0:f (tactile material) p16
            050a:[5-6]:be => 007:0:g (filmstreifen)       p17
            050a:[5-6]:bf => 007:0:g (filmstreifen-cartr)       p17
            050a:[5-6]:bg => 007:0:g (filmsstreifen-rolle)       p17
            050a:[5-6]:bh => 007:0:g (and.filmstreifen)       p17
            050a:[5-6]:bi => 007:0:g (diapositiv)       p17
            050a:3:a      => 007:0:h (microfilm) p15
            050a:3:b      => 007:0:h  (microfilm) p15
            050a:[5-6]:da => 007:0:k (kunstblatt)         p18
            050a:[5-6]:dc => 007:0:k (plakat)             p18
            050a:[5-6]:ba => 007:0:m (filmspule)       p17
            050a:[5-6]:bb => 007:0:m (filmkaset)       p17
            050a:[5-6]:bc => 007:0:m (filmcartridge)       p17
            050a:[5-6]:bd => 007:0:m (anderes film)       p17
            050a:[7]:a    => 007:0:o ()                   p19
            050a:[7]:b    => 007:0:o ()                   p19
            050a:[5-6]:ac => 007:0:s (soundrecording)
            050a:[5-6]:ah => 007:0:s (sound cartridge)
            050a:[5-6]:ai => 007:0:s (wire recording)
            050a:[5-6]:ak => 007:0:s (cylinder)
            050a:[5-6]:al => 007:0:s (klarvierrolle)
            050a:[5-6]:am => 007:0:s (soundtrack)       p17
            050a:0:a      => 007:0:t (text) p15
            050a:[5-6]:ca => 007:0:v (videokasette)       p18
            050a:[5-6]:cb => 007:0:v (videocartridge)       p18
            050a:[5-6]:cc => 007:0:v (video spulen)       p18
            050a:[5-6]:cd => 007:0:v (video spulen)       p18
            050a:[5-6]:ce => 007:0:v (video spulen)       p18
            050a:[5-6]:ab => 007:0:v (videorecording)
        -->


<xsl:choose>
    <xsl:when test="$mab050a = ''">|</xsl:when><!-- no information here: default to 't' or '|' => text or No attempt to code -->
    <xsl:otherwise>
        
        <!-- TODO restructure (reduce otherwise statements) -->
        <xsl:variable name="mab50aPos10" select="substring($mab050a,11,1)"/>
        <xsl:variable name="mab50aPos08" select="substring($mab050a,9,1)"/>
        <xsl:variable name="mab50aPos04" select="substring($mab050a,5,1)"/>
        <xsl:variable name="mab50aPos5to6" select="substring($mab050a,6,2)"/>
        <xsl:variable name="mab50aPos03" select="substring($mab050a,4,1)"/>
        <xsl:variable name="mab50aPos07" select="substring($mab050a,8,1)"/>
        <xsl:variable name="mab50aPos00" select="substring($mab050a,1,1)"/>
        <xsl:choose>
            <xsl:when test="$mab50aPos10 = 'a'">a</xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$mab50aPos08 != '' and contains('abcdefgz',$mab50aPos08)">c</xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$mab50aPos04 = 'a'">f</xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$mab50aPos5to6 != '' and contains('be bf bg bh bi', $mab50aPos5to6)">g</xsl:when>
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <xsl:when test="$mab50aPos03 != '' and contains('ab', $mab50aPos03)">h</xsl:when>
                                            <xsl:otherwise>
                                                <xsl:choose>
                                                    <xsl:when test="$mab50aPos5to6 != '' and contains('da dc', $mab50aPos5to6)">k</xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:choose>
                                                            <xsl:when test="$mab50aPos5to6 != '' and contains('ba bb bc bd', $mab50aPos5to6)">m</xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:choose>
                                                                    <xsl:when test="$mab50aPos07 != '' and contains('ab', $mab50aPos07)">o</xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:choose>
                                                                            <xsl:when
                                                                                test="$mab50aPos5to6 != '' and contains('ac ah ai ak al am', $mab50aPos5to6)">s</xsl:when>
                                                                            <xsl:otherwise>
                                                                                <xsl:choose>
                                                                                    <xsl:when test="$mab50aPos00 = 'a'">t</xsl:when>
                                                                                    <xsl:otherwise>
                                                                                        <xsl:choose>
                                                                                            <xsl:when
                                                                                                test="$mab50aPos5to6 != '' and contains('ca cb cc cd ce ab', $mab50aPos5to6)">v</xsl:when>
                                                                                            <!-- default: a space -->
                                                                                            <xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
                                                                                        </xsl:choose>
                                                                                    </xsl:otherwise>
                                                                                </xsl:choose>
                                                                            </xsl:otherwise>
                                                                        </xsl:choose>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        
        
    </xsl:otherwise>
</xsl:choose>        
        
    </xsl:template>

<xsl:template name="getMarc007Pos1ByMab50a">
    <!-- this is a copy of the dirty template above with some changes -->
    <!-- 
050a:0:a      => 007:1:u (text) p15
050a:4:a      => 007:1:b (tactile material) p16

050a:[5-6]:bb => 007:1:c (filmkaset)       p17
050a:[5-6]:bc => 007:1:c (filmcartridge)       p17
050a:[5-6]:bf => 007:1:c (filmstreifen-cartr)       p17
050a:[5-6]:cb => 007:1:c (videocartridge)       p18

050a:[5-6]:ab => 007:1:d (videorecording) 
050a:[5-6]:be => 007:1:d (filmstreifen)       p17
050a:[5-6]:cd => 007:1:d (video spulen)       p18

050a:[5-6]:ak => 007:1:e (cylinder)

050a:[5-6]:bh => 007:1:f (and.filmstreifen)       p17
050a:[5-6]:ca => 007:1:f (videokasette)       p18
050a:[5-6]:dc => 007:1:f (plakat)             p18

050a:[5-6]:ah => 007:1:g (sound cartridge)
050a:[5-6]:da => 007:1:h (kunstblatt)         p18
050a:[5-6]:bg => 007:1:o (filmsstreifen-rolle)       p17
050a:[5-6]:al => 007:1:q (klarvierrolle)
050a:[5-6]:ba => 007:1:r (filmspule)       p17
050a:[5-6]:cc => 007:1:r (video spulen)       p18
050a:[5-6]:bi => 007:1:s (diapositiv)       p17
050a:[5-6]:ac  => 007:1:t (soundrecording)
050a:[5-6]:ai => 007:1:w (wire recording)

050a:[5-6]:bd => 007:1:z (anderes film)       p17
050a:[5-6]:ce => 007:1:z (video spulen)       p18

050a:8:g => 007:1:r remote
050a:8:z => 007:1:z other

    -->
    <xsl:param name="mab050a"/>
    <xsl:variable name="mab50aPos10" select="substring($mab050a,11,1)"/>
    <xsl:variable name="mab50aPos08" select="substring($mab050a,9,1)"/>
    <xsl:variable name="mab50aPos04" select="substring($mab050a,5,1)"/>
    <xsl:variable name="mab50aPos5to6" select="substring($mab050a,6,2)"/>
    <xsl:variable name="mab50aPos03" select="substring($mab050a,4,1)"/>
    <xsl:variable name="mab50aPos07" select="substring($mab050a,8,1)"/>
    <xsl:variable name="mab50aPos00" select="substring($mab050a,1,1)"/>
    <xsl:choose>
        <xsl:when test="$mab50aPos10 = 'a'">u</xsl:when>
        <xsl:otherwise>
            <xsl:choose>
                <xsl:when test="$mab50aPos08 != '' and contains($mab50aPos08,'abcdef')">c</xsl:when>
                <xsl:when test="$mab50aPos08 = 'g'">r</xsl:when>
                <xsl:when test="$mab50aPos08 = 'z'">z</xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$mab50aPos04 = 'a'">b</xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <!-- assuming that all these cases eclude each other: -->
                                <xsl:when test="$mab50aPos5to6 = ''">|</xsl:when><!-- default to 'z' or '|' other or unspecified -->
                                <xsl:when test="contains('bb bc bf cb', $mab50aPos5to6)">c</xsl:when>
                                <xsl:when test="contains('ak',$mab50aPos03)">e</xsl:when>
                                <xsl:when test="contains('bh ca dc', $mab50aPos5to6)">f</xsl:when>
                                <xsl:when test="contains('ah', $mab50aPos5to6)">g</xsl:when>
                                <xsl:when test="contains('da', $mab50aPos07)">h</xsl:when>
                                <xsl:when test="contains('bg', $mab50aPos5to6)">o</xsl:when>
                                <xsl:when test="contains('al', $mab50aPos5to6)">q</xsl:when>
                                <xsl:when test="contains('ba cc', $mab50aPos5to6)">r</xsl:when>
                                <xsl:when test="contains('bi', $mab50aPos5to6)">s</xsl:when>
                                <xsl:when test="contains('ac', $mab50aPos5to6)">t</xsl:when>                                                                                           
                                <xsl:when test="contains('ai', $mab50aPos5to6)">w</xsl:when>
                                <xsl:when test="contains('bd ce', $mab50aPos5to6)">z</xsl:when>
                                <!-- default is ' ' -->
                                <xsl:otherwise> </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

    <xsl:template name="generateMarc007">
        <xsl:param name="pos0"/>
        <xsl:param name="pos1"/>
        <marc:controlfield tag="007">
            <xsl:value-of select="$pos0"/><xsl:value-of select="$pos1"/>
        </marc:controlfield>
    </xsl:template>
    <xsl:template name="generateMarc008">
        <xsl:param name="pos21"/>
        <!-- TODO a lot of fake here! actually all except pos21. -->
        <marc:controlfield tag="008">950930c19039999hu ar <xsl:value-of select="$pos21"/>|| | b0eng c</marc:controlfield>
    </xsl:template>

    <xsl:template name="getMarc008Pos21ByMab52">
        <!-- TODO and others?! -->
        <xsl:param name="mab052"/>
        <xsl:variable name="mab52pos00" select="substring($mab052,1,1)"/>
        <xsl:choose>
            <xsl:when test="$mab52pos00 = 'p'">p</xsl:when>
            <xsl:when test="$mab52pos00 = 'r'">m</xsl:when>
            <xsl:when test="$mab52pos00 = 'z'">n</xsl:when>
            <xsl:otherwise> </xsl:otherwise>
            <!-- TODO: nothing?! -->
        </xsl:choose>

    </xsl:template>

    <xsl:template name="getMarcLeader07ByMab051AndMab52">
        <!-- 
051a:0:a  => leader07:a (monographic component part) p20
051a:0:m  => leader07:m (monographic component part) p20 [leader19: ]
051a:0:n  => leader07:m (monographic component part) p21 [leader19:a]
051a:0:s  => leader07:m (monographic component part) p21 [leader19:b]

TODO { 051a:[1-3]:o  => leader07:i (lose blattausgabe) p22  }
TODO { 051a:[1-3]:q  => leader07:i (lieferungswerk) p23  } [007t:01:d]
TODO { 051a:[1-3]:t  => leader07:a (aufsatz) p23  }


052:0:a   => leader07:d (unselbstaendig erschienenes werk)
TODO { 052:0:i   => leader07:i (continueing integrated resource) }


052a:0:p  => leader07:s (zeitschrift) + [008:21:p !!!!] sonst error! p26
052a:0:r  => leader07:s (schriftenreihe) + [008:21:m !!!!] sonst error?
052a:0:z  => leader07:s (zeitung) + [008:21:n !!!!] sonst error?
-->
        <xsl:param name="mab051" select="' '"/>
        <xsl:param name="mab052" select="' '"/>
        <xsl:variable name="mab51pos00" select="substring($mab051,1,1)"/>
        <xsl:variable name="mab52pos00" select="substring($mab052,1,1)"/>
        <xsl:choose>
            <xsl:when test="$mab51pos00 = 'a'">a</xsl:when>
            <!-- monographic component part -->
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$mab52pos00 != '' and contains('prz', $mab52pos00)">s</xsl:when>
                    <!-- zeitschrift, schriftenreihe, zeitung -->
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains('mns', $mab51pos00)">m</xsl:when>
                            <!-- monographic component part -->
                            <xsl:otherwise>m</xsl:otherwise>
                            <!-- defautlt to book! (monography) -->
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="getMarcLeader06ByMab050">
        <xsl:param name="mab050"/>
        <!--
050a:00:a  => leader06:a (book)       p14
050a:01:a  => leader06:t (manuscript) p15

050a:05:bX => leader06:g (filmX)
050a:05:cX => leader06:g (video)
050a:05:dX => leader06:k (foto)

050a:05:uu => leader06:g (video) p19
050a:05:yy => "
050a:05:zz => "

050a:07:a => leader06:p (mixed material)

050a:08:a => leader06:m,007c:c (computer file)
050a:08:b => leader06:m,007c:j
050a:08:c => leader06:m,007c:f
050a:08:d => leader06:m,007c:o
050a:08:e => leader06:m,007c:z
050a:08:f => leader06:m,007c:h
050a:08:g => leader06:m,007c:r
050a:08:z => leader06:m,007c:z

050a:09:a => leader06:r,008:g  (spiele)

050a:10:a => leader06:e,007:a:a  (map)
============================================
TODO:
051a:[1-3?!]:m => leader06:c,007q:q ?!  (musikalia) p27
052a:[1-6]:mu  => leader06:d,007q:q ?!  (musikalia) p28
        -->
        <!-- if there  is no mab50 bail out with a or t (Language material or Manuscript language material) -->
        <xsl:choose>
            <xsl:when test="$mab050 = ''">a</xsl:when>
            <xsl:otherwise>
                

        
        <xsl:variable name="pos00" select="substring($mab050,1,1)"/>
        <xsl:choose>
            <xsl:when test="$pos00 = 'a'">a</xsl:when>
            <!-- book -->
            <xsl:otherwise>
                <xsl:variable name="pos01" select="substring($mab050,2,1)"/>
                <xsl:choose>
                    <xsl:when test="$pos01 = 'a'">t</xsl:when>
                    <!-- manuscript -->
                    <xsl:otherwise>
                        <xsl:variable name="pos05" select="substring($mab050,6,1)"/>
                        <xsl:choose>
                            <xsl:when test="contains('bcuyz', $pos05)">g</xsl:when>
                            <!-- filmX -->
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$pos05 = 'd'">k</xsl:when>
                                    <!-- fotoX -->
                                </xsl:choose>
                                <xsl:variable name="pos07" select="substring($mab050,8,1)"/>
                                <xsl:choose>
                                    <xsl:when test="$pos07 = 'a'">p</xsl:when>
                                    <xsl:otherwise>
                                        <xsl:variable name="pos08" select="substring($mab050,9,1)"/>
                                        <xsl:choose>
                                            <xsl:when test="contains('abcdefg', $pos08)"/>
                                            <!--  a bis g => m  computer files -->
                                            <xsl:otherwise>
                                                <xsl:variable name="pos09"
                                                  select="substring($mab050,10,1)"/>
                                                <xsl:choose>
                                                  <xsl:when test="$pos09 = 'a'">r</xsl:when>
                                                  <!-- three dimensional artefact!? -->
                                                  <xsl:otherwise>
                                                  <xsl:variable name="pos10"
                                                  select="substring($mab050,11,1)"/>
                                                  <xsl:if test="$pos10 = 'a'">e</xsl:if>
                                                  <!-- carografic material -->
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>

            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

<!-- TODO put all 260 together?! -->
    <xsl:template name="generatePlaceOfPublication">
        <xsl:param name="mab410a"/>
        <xsl:if test="$mab410a != ''">
        <marc:datafield tag="260" ind1=" " ind2=" ">
            <marc:subfield code="a">
                <xsl:value-of select="$mab410a"/>
            </marc:subfield>
        </marc:datafield>
        </xsl:if>
    </xsl:template>

    <xsl:template name="generateNameOfPublisher">
        <xsl:param name="mab417a"/>
        <xsl:if test="$mab417a != ''">
        <marc:datafield tag="260" ind1=" " ind2=" ">
            <marc:subfield code="b">
                <xsl:value-of select="$mab417a"/>
            </marc:subfield>
        </marc:datafield>
        </xsl:if>
    </xsl:template>

    <xsl:template name="generatePublishedDate">
        <xsl:param name="publishingDate"/>
        <xsl:if test="$publishingDate != ''">
        <marc:datafield tag="260" ind1=" " ind2=" ">
            <marc:subfield code="c">
                <xsl:value-of select="$publishingDate"/>
            </marc:subfield>
        </marc:datafield>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="generatePublisher">
        <xsl:param name="publisherName"/>
        <xsl:if test="$publisherName != ''">
        <marc:datafield tag="260" ind1=" " ind2=" ">
            <marc:subfield code="f">
                <xsl:value-of select="$publisherName"/>
            </marc:subfield>
        </marc:datafield>
        </xsl:if>
    </xsl:template>    

    <xsl:template name="generateCountry">
        <xsl:param name="dinEn23166countryCode"/>
        <!-- 008 ?! -->
        <!-- 044a -->
        <!-- get marc coutnry code from xml: -->

        <xsl:if test="$dinEn23166countryCode != ''">
        <marc:datafield tag="044" ind1=" " ind2=" ">
            <marc:subfield code="a">
                code:<xsl:value-of select="$dinEn23166countryCode"/>
                <xsl:value-of select="document('country_code_translation.xml')//translate-country/marccountry[@mab=$dinEn23166countryCode]/text()"/>
            </marc:subfield>
        </marc:datafield>
        </xsl:if>
    </xsl:template>
    <xsl:template name="generateUrl">
        <xsl:param name="url"/>
        <xsl:if test="$url != ''">
            <marc:datafield tag="856" ind1=" " ind2=" ">
                <marc:subfield code="u">
                    <xsl:value-of select="$url"/>
                </marc:subfield>
            </marc:datafield>
        </xsl:if>
    </xsl:template>


    <xsl:template name="generateLanguage">
        <xsl:param name="language"/>
        <marc:datafield tag="041" ind1=" " ind2=" ">
            <marc:subfield code="a">
                <xsl:value-of select="$language"/>
            </marc:subfield>
        </marc:datafield>
    </xsl:template>

    <!-- just tokenize and output a 041a for each lang: -->
    <xsl:template name="generateMultiLanguage">
        <xsl:param name="languages"/>
        <xsl:param name="delimiter" select="' '"/>
        <xsl:if test="$languages != ''">
            <xsl:choose>
                <xsl:when test="$delimiter and contains($languages, $delimiter)">
                    <marc:datafield tag="041" ind1=" " ind2=" ">
                        <marc:subfield code="a">
                            <xsl:value-of select="substring-before($languages, $delimiter)"/>
                        </marc:subfield>
                    </marc:datafield>

                    <xsl:call-template name="generateMultiLanguage">
                        <xsl:with-param name="languages"
                            select="substring-after($languages, $delimiter)"/>
                        <xsl:with-param name="delimiter" select="$delimiter"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <marc:datafield tag="041" ind1=" " ind2=" ">
                        <marc:subfield code="a">
                            <xsl:value-of select="$languages"/>
                        </marc:subfield>
                    </marc:datafield>
                    <xsl:text> </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>



    <xsl:template name="generateFirstAuthor">
        <xsl:param name="firstAuthor"/>
        <xsl:param name="firstAuthorsAddition"/>
        <xsl:param name="mab010a"/>

<xsl:choose>
    <xsl:when test="$firstAuthor = '' and $mab010a != ''">
        <xsl:call-template name="generateFirstAuthorByParent">
            <xsl:with-param name="parentId"> <xsl:value-of select="$mab010a"/></xsl:with-param>
        </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
        <marc:datafield tag="100" ind1=" " ind2=" ">
            <marc:subfield code="a">
                <xsl:value-of select="$firstAuthor"/>
            </marc:subfield>
            <!-- TODO try to get from parent if not there -->
            <xsl:if test="$firstAuthorsAddition != ''">
            <marc:subfield code="b">
                <xsl:value-of select="$firstAuthorsAddition"/>
            </marc:subfield>
            </xsl:if>
        </marc:datafield>        
    </xsl:otherwise>
</xsl:choose>
    </xsl:template>



    <xsl:template name="generateFirstAuthorByParent">
        <xsl:param name="parentId"/>
<!-- TODO parameterize this url!!! -->
        <xsl:variable name="findUrl">https://aleph.uibk.ac.at/X?op=find&amp;base=UBI01&amp;request=<xsl:value-of select="$parentId"/></xsl:variable>
        <xsl:variable name="setNumber">
		<xsl:value-of select="document($findUrl)//find/set_number/text()"/>
        </xsl:variable>
<!-- TODO parameterize this url!!! -->
        <xsl:variable name="presentUrl">https://aleph.uibk.ac.at/X?op=present&amp;set_number=<xsl:value-of select="$setNumber"/>&amp;set_entry=1-1</xsl:variable>
        <marc:datafield tag="100" ind1=" " ind2=" ">
            <marc:subfield code="a">
                <xsl:value-of select="document($presentUrl)//present/record/metadata/oai_marc/varfield[@id='100']/subfield[@label='a']/text()"/>
            </marc:subfield>
        </marc:datafield>        
    </xsl:template>

<xsl:template name="generateFirstAuthorsAddition">
    <xsl:param name="mab100b"/>
    <!-- TODO get this from parent. see generateAuthor -->
    <xsl:if test="$mab100b != ''">
    <marc:datafield tag="700" ind1="1" ind2=" ">
        <marc:subfield code="b">
            <xsl:value-of select="$mab100b"/>
        </marc:subfield>
    </marc:datafield>        
    </xsl:if>
</xsl:template>
    
    <!-- other author is just a repeating 700 field -->
    <!-- TODO try to get things from parent record if not there: -->
    <xsl:template name="generateOtherAuthor">
        <xsl:param name="otherAuthor"/>
        <xsl:param name="otherAuthorAddition"/>
        <xsl:param name="parentRecordId"/>
        <!-- TODO what is ind1, ind2? -->
        <xsl:if test="$otherAuthor != ''">
        <marc:datafield tag="700" ind1=" " ind2=" ">
            <marc:subfield code="a">
                <xsl:value-of select="$otherAuthor"/>
            </marc:subfield>
            <marc:subfield code="b">
                <xsl:value-of select="$otherAuthorAddition"/>
            </marc:subfield>
        </marc:datafield>
        </xsl:if>
    </xsl:template>


    <xsl:template name="generateSysId">
        <xsl:param name="field001"/>
        <marc:controlfield tag="001">
            <xsl:value-of select="$field001"/>
        </marc:controlfield>
    </xsl:template>

    <xsl:template name="generateTitle">
        <xsl:param name="mabTitleA" select="''"/>
        <xsl:param name="mabTitleB" select="''"/>
        <xsl:param name="mab089a" select="''"/>
        <xsl:param name="mab010a"/>
        <xsl:choose>
            <xsl:when test="$mabTitleA = '' and $mab010a != ''">
                <!-- generate title by parent record -->
                <xsl:call-template name="generateTitleByParent">
                    <xsl:with-param name="parentId">
                        <xsl:value-of select="$mab010a"/>
                    </xsl:with-param>
                    <xsl:with-param name="mabTitleB"><xsl:value-of select="$mabTitleB"/></xsl:with-param>
                    <xsl:with-param name="mab089a"><xsl:value-of select="$mab089a"/></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <marc:datafield tag="245" ind1=" " ind2=" ">
                    <marc:subfield code="a">
                        <xsl:value-of select="$mabTitleA"/>
                    </marc:subfield>
                    <marc:subfield code="b">
                        <xsl:value-of select="$mabTitleB"/>
                    </marc:subfield>
                    <marc:subfield code="n">
                        <xsl:value-of select="$mab089a"/>
                    </marc:subfield>
                </marc:datafield>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="generateTitleByParent">
        <xsl:param name="parentId"/>
        <xsl:param name="mabTitleB" select="''"/>
        <xsl:param name="mab089a" select="''"/>
        
<!-- TODO parameterize this url!!! -->
        <xsl:variable name="findUrl">https://aleph.uibk.ac.at/X?op=find&amp;base=UBI01&amp;request=<xsl:value-of select="$parentId"/></xsl:variable>
        <xsl:variable name="setNumber">
            <xsl:value-of select="document($findUrl)//find/set_number/text()"/>
        </xsl:variable>
<!-- TODO parameterize this url!!! -->
        <xsl:variable name="presentUrl">https://aleph.uibk.ac.at/X?op=present&amp;set_number=<xsl:value-of select="$setNumber"/>&amp;set_entry=1-1</xsl:variable>
        <marc:datafield tag="245" ind1=" " ind2=" ">
            <marc:subfield code="a">
                <xsl:value-of select="document($presentUrl)//present/record/metadata/oai_marc/varfield[@id='331']/subfield[@label='a']/text()"/>
            </marc:subfield>
            <marc:subfield code="b">    
            <xsl:choose>
                <xsl:when test="$mabTitleB != ''"><xsl:value-of select="$mabTitleB"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="document($presentUrl)//present/record/metadata/oai_marc/varfield[@id='331']/subfield[@label='b']/text()"/></xsl:otherwise>
            </xsl:choose>
            </marc:subfield>            
            <marc:subfield code="n">
                <xsl:choose>
                    <xsl:when test="$mab089a != ''"><xsl:value-of select="$mab089a"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="document($presentUrl)//present/record/metadata/oai_marc/varfield[@id='089']/subfield[@label='a']/text()"/></xsl:otherwise>
                </xsl:choose>
            </marc:subfield>
        </marc:datafield>
    </xsl:template>

    <xsl:template name="generateLeader">
        <xsl:param name="recordStatus" select="'n'"/>
        <!-- 05: n => new -->
        <xsl:param name="typeOfRecord" select="'a'"/>
        <!-- 06: a => language material -->
        <xsl:param name="bibliographicLevel" select="'m'"/>
        <!-- rewrite typeOfRecord (default) -->
        <xsl:variable name="actualTypeOfRecord">
            <xsl:choose>
                <xsl:when test="$typeOfRecord = ''">a</xsl:when>
                <xsl:otherwise><xsl:value-of select="$typeOfRecord"/></xsl:otherwise>
            </xsl:choose>
            
        </xsl:variable>
        <!-- 07: m => mongraph -->
        <!-- example: 01361pam a2200385   4500 -->
        <!--leader><xsl:value-of select="$headerRecordLength"/><xsl:value-of select="$recordStatus"/><xsl:value-of select="$typeOfRecord"/><xsl:value-of select="$bibliographicLevel"/></leader-->
        <xsl:if test="$typeOfRecord = ''"></xsl:if>
        <marc:leader><xsl:value-of xml:space="preserve" select="concat($headerRecordLength, $recordStatus, $actualTypeOfRecord, $bibliographicLevel,$typeOfControlAndConstants,$addressFake)"/><xsl:text>   </xsl:text><xsl:value-of select="$entryMap"/></marc:leader>
    </xsl:template>

    <xsl:template name="generateEdition">
        <xsl:param name="mab403a"/>
        <xsl:if test="$mab403a != ''">
            <marc:datafield tag="250" ind1=" " ind2=" ">
                <marc:subfield code="a">
                    <xsl:value-of select="$mab403a"/>
                </marc:subfield>
            </marc:datafield>
        </xsl:if>
    </xsl:template>

    <xsl:template name="generatePhysicalDescription">
        <xsl:param name="mab433a"/>
        <xsl:if test="$mab433a != ''">
            <marc:datafield tag="300" ind1=" " ind2=" ">
                <marc:subfield code="a">
                    <xsl:value-of select="$mab433a"/>
                </marc:subfield>
            </marc:datafield>
        </xsl:if>
    </xsl:template>


<xsl:template name="generateSeries">
    <xsl:param name="mab454a"/>
    <xsl:if test="$mab454a != ''">
    <marc:datafield tag="800" ind1=" " ind2=" ">
        <marc:subfield code="a">
            <xsl:value-of select="$mab454a"/>
        </marc:subfield>
    </marc:datafield>
     </xsl:if>
</xsl:template>
    
<xsl:template name="generateGeneralNote">
    <xsl:param name="mab525a"/>
    <xsl:if test="$mab525a != ''">
    <marc:datafield tag="500" ind1=" " ind2=" ">
        <marc:subfield code="a">
            <xsl:value-of select="$mab525a"/>
        </marc:subfield>
    </marc:datafield>    
    </xsl:if>
</xsl:template>

<!-- konkordanz p62 -->
<xsl:template name="generateSeriesStatement">
    <xsl:param name="mab451a"/>
    <xsl:if test="$mab451a != ''">
    <marc:datafield tag="490" ind1=" " ind2=" ">
        <marc:subfield code="a">
            <xsl:value-of select="$mab451a"/>
        </marc:subfield>
    </marc:datafield>    
    </xsl:if>
</xsl:template>
<!-- konkordanz p72 -->

<xsl:template name="generateOtherEditionEntry">
    <xsl:param name="mab527a"/>
    <xsl:if test="$mab527a != ''">
    <marc:datafield tag="775" ind1=" " ind2=" ">
        <marc:subfield code="a">
            <xsl:value-of select="$mab527a"/>
        </marc:subfield>
    </marc:datafield>     
    </xsl:if>        
</xsl:template>

</xsl:stylesheet>
