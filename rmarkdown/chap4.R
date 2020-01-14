if (!require("rvets" ,character.only = TRUE) )
{install.packages("rvest", dep=TRUE); require("rvest");}

if (!require("httr" ,character.only = TRUE) )
{install.packages("httr", dep=TRUE); require("httr");}

msn = html("https://www.msn.com/en-us/money/markets/currencies")
print(paste("taille de la reponse : ", length(msn) ))


msn = GET("https://www.msn.com/en-us/money/markets/currencies" )
print(paste( "code d'état :",  msn$status_code))
print(paste("taille de la reponse : ", length(msn) ))

page = content(msn)


currency_class <- ".mjrcurrncsitem"
cur = html_node(page, currency_class)

thead_class = '.mjrcurrncsrow.tblheaderrow'
header = html_node(cur,  thead_class)
headers = html_nodes(header, ".mctblheading") # Avez-vous pu retrouver la classe `mctblheading`  de vous mêmes ?
header_values = c()
i = 0
for (header in headers){
  header_values[i] = html_node(header, "p")%>%html_attr("title")
  i = i + 1
}
print(header_values)


l = list(a = 1, b = 2)
rbind(l, l)