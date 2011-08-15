#! /bin/sh

wasMounted=`(/bin/mount | /bin/grep SUB1 | /usr/bin/wc -l)`

if [ $wasMounted -eq 0 ];
then
	echo "Mounting SUB1"
	/home/ssp/bin/novell-checker.sh
fi

cd /home/ssp/sub1/USER/user/INTRANET

fileName=`(ls -1t Tele*xls | head -1)`
echo "File $fileName"

libreoffice -nologo -convert-to html:Telefonbuch -outdir /home/ssp/Downloads/ $fileName;

cd /home/ssp/Downloads

xsltproc --html --stringparam fileName "$fileName" ~/bin/XSLT/Phonebook-Cleaner.xsl Telefonbuch.html > Telefonbuch-clean.html

scp Telefonbuch-clean.html vlib.sub.uni-goettingen.de:/home/vlib/demo-sites/ssp/phone/phone.html

ssh ssp@vlib.sub.uni-goettingen.de "cd /home/vlib/demo-sites/ssp/phone; git add .; git commit -m phone.html"

if [ $wasMounted -eq 0 ];
then
	echo "Unmounting SUB1"
	sudo umount /home/ssp/sub1
fi
