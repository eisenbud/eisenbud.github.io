BEGIN {

	FS = "\t"
	tblank = ""
	# tblank = " target=\"_blank\""
	
	search_prefix = "Unpublished \(more detailed\) version of "
	title_prefix = "Unpublished (more detailed) version of "
	prefix_len = length(title_prefix)
	
	printf "<table>\n"
}

(NR == 1) { next }
(NR == 2) { next }

{

# remove the double-quote string delimiters
gsub("\"", "")

item = $1

if (item == 0) exit

year = $2

title = $3
if (title !~ /\?$/) title = title "."
sub("\.\.$", ".", title)

author = $4
# remove a final "." because it would print two, e.g., "Jr."
sub("\.$", "", author)

journal = ($5 != "") ? ($5 ".") : ""

numelts = split($6, volume, ":")
vol = volume[1]
issue = ""
if (numelts > 1) issue = ", no." volume[2]

pagestr = ""
pgnumelts = split($7, page, "-")
if (pgnumelts > 0)
{
    if (pgnumelts == 1)
	{
		numpages = page[1]
		if (numpages ~ /\+/)
		{
			split(numpages, tmpary, "+") # e.g., xvii+173
			numpages = tmpary[2]
	    }
	}
	else numpages = page[2] - page[1] + 1
	if ($7 == "ix-xiv") numpages = 6  # special case
	pagestr = ", " $7
}

filedes = $8

filepath = "pdfs/" filedes ".pdf"

if (!(system("test -r " filepath)))
{
	pfiletype = "pdf"
	palt = "PDF"
}
else
{
	pfiletype = "other"
	palt = "???"
}

filepath = "djvus/" filedes ".djvu"

if (!(system("test -r " filepath)))
{
	dfiletype = "djvu"
	dalt = "DJVU"
}
else
{
	dfiletype = "other"
	dalt = "???"
}

# column  9 is whether pdf file was downloaded
# column 10 is whether djvu file was downloaded
# column 11 is whether paper was scanned

altitle = $12

printf("<tr valign=\"top\"><td>%3d.</td>\n", item)

printf("<td><a href=\"pdfs/%s.pdf\"%s><img src=\"gifs/%s.gif\" alt=\"[%s]\" align=\"top\"></a></td>\n", filedes, tblank, pfiletype, palt)
printf("<td><a href=\"djvus/%s.djvu\"%s><img src=\"gifs/%s.gif\" alt=\"[%s]\" align=\"top\"></a></td>\n", filedes, tblank, dfiletype, dalt)

published = 1
if (title ~ search_prefix)
{
 	printf("<td>%s", title_prefix) 
 	title = substr(title, prefix_len)
	published = 0
    printf("<b>%s</b>\n", title)
}
else printf("<td><b>%s</b>\n", title)

if (author != "") printf("%s.\n", author)

if (pgnumelts > 0) printf("%d pages.\n", numpages)

if (published)
{
	if (altitle != "") printf ("%s.\n", altitle)
	printf("<i>%s</i> %s (%s)%s%s.\n", journal, vol, year, issue, pagestr) 
}

printf("</td></tr>\n\n")

}

END {

	printf "</table>\n"
	exit
}
