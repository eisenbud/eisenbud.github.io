BEGIN { FS = "\t" }

(NR == 1) { next }
(NR == 2) { next }

{
item = NR - 2

if (item > 71) exit
else if (item <= 3) gif = "pdf"
else gif = "other"

# remove the double-quote string delimiters
gsub("\"", "")

year = $1

title = $2

author = $3

journal = $4

vol = $5

printf("<dt><table cellpadding=\"0\"><tbody><tr valign=\"top\"><td nowrap=\"nowrap\"> %3d.\n", item)

printf("<a href=\"pdfs/%s-%03d.pdf\"><img src=\"gifs/%s.gif\" alt=\"[PDF]\" align=\"top\" border=\"1\" height=\"26\" width=\"24\"></a>\n", year, item, gif) 

printf("</td><td>\n")

printf("<b>%s.</b>\n", title)

printf("%s.\n", author)

printf("<i>%s.</i> %s (%s).\n", journal, vol, year)

printf("</td></tr></tbody></table></dt>\n\n")

# <dt><table cellpadding="0"><tbody><tr valign="top"><td nowrap="nowrap">1.
#  <a href="http://www.sciencedirect.com/science?_ob=MImg&_imagekey=B6WH2-4D7K6GW-182-1&_cdi=6838&_user=10&_orig=search&_coverDate=09%2F30%2F1970&_qd=1&_sk=999839998&view=c&wchp=dGLbVtz-zSkWz&md5=35dec34a89f979f92ccf63860421d905&ie=/sdarticle.pdf"><img src="gifs/pdf.gif" alt="[PDF]" align="top" border="1" height="26" width="24"></a>
# </td>
# <td>
# <b>Modules over Dedekind prime rings.</b>
# David Eisenbud, J. C. Robson. 9 pages. <i>Journal of algebra</i> 16 (1970), no. 1, 67-85.  
# </td></tr></tbody></table>
# </dt>
# 

}
