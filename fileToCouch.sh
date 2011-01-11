#! /bin/sh

PPN=`echo $1 | sed 's/[0-9X*].xml//g'`

# echo $PPN

JSON=`cat $1 | xsltproc ~/bin/XSLT/PicaXMLCleaner.xsl - | xsltproc ~/bin/XSLT/MarcXML2TurboMarc.xsl - | php -f ~/bin/xml2json/xml2json_commandline.php`

curl -X PUT http://127.0.0.1:5984/pica/$PPN --data "$JSON"

