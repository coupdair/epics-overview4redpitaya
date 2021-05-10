#!/bin/bash

#create the TOC (i.e. Table Of Contents) of a MarkDown file
#usage: ./ReadMe_TOC.sh
#usage: ./ReadMe_TOC.sh > ReadMe_TOC.md; cat ReadMe_TOC.md ReadMe.md > ReadMe_with_TOC.md; mv ReadMe_with_TOC.md ReadMe.md

version="v0.0.4"

#TODO: replace previous TOC by new one (e.g. using [begin,end]@of@TOC marker as TOC paragraph)

f=ReadMe.md
ft=`basename $0 .sh`.tmp

#get TOC
grep '# ' $f | grep -v '(#' | grep -v '# Table of contents' > $ft

#header
echo '<!--- begin@of@TOC --->'
echo '# Table of contents'
echo

#MarkDown links
while read l
do
#echo ":$l:"
  #title
  t=`echo "$l" | sed 's/# //;s/#//g'`
  #rank and link
  k=`echo "$l" | sed 's/# /#@/;s/  / /g;s/  / /g;s/  / /g;s/ /-/g;s/\.//g' | tr [:upper:] [:lower:]`
#echo "$t $k"
  #gather
  /bin/echo -e -n $k | sed "s/@/@[$t](/" | sed 's/#@/# /;s/###/          1./;s/##/     1./;s/#/1./;'
  echo ')'
done < $ft | sed 's/(/(\#/'

#footer
echo '<!--- end@of@TOC --->'

#clean
rm $ft

