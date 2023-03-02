BEGIN {

FS = "\t"
tblank = ""
# tblank = " target=\"_blank\""

search_prefix = "Unpublished \(more detailed\) version of "
title_prefix = "Unpublished (more detailed) version of "
prefix_len = length(title_prefix)

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
	filetype = "pdf"
	alt = "PDF"
}
else
{
	filetype = "other"
	alt = "???"
}

# column  9 is whether pdf file was downloaded
# column 10 is whether djvu file was downloaded
# column 11 is whether paper was scanned

altitle = $12

printf("<dt><table cellpadding=\"0\"><tbody><tr valign=\"top\"><td nowrap=\"nowrap\"> %3d.\n", item)

printf("<a href=\"pdfs/%s.pdf\"%s><img src=\"gifs/%s.gif\" alt=\"[%s]\" align=\"top\" border=\"1\" height=\"26\" width=\"24\"></a>\n", filedes, tblank, filetype, alt)

printf("</td><td>\n")

published = 1
if (title ~ search_prefix)
{
	printf("%s", title_prefix) 
	title = substr(title, prefix_len)
	published = 0
}
printf("<b>%s</b>\n", title)

if (author != "") printf("%s.\n", author)

if (pgnumelts > 0) printf("%d pages.\n", numpages)

if (published)
{
	if (altitle != "") printf ("%s.\n", altitle)
	printf("<i>%s</i> %s (%s)%s%s.\n", journal, vol, year, issue, pagestr) 
}

printf("</td></tr></tbody></table></dt>\n\n")

}

END { exit }
