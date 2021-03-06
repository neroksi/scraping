

# installer le paquet "rvest" si ce n'est pas encore fait
# rvest permet d analyser du HTML === BeaufitulSoup
if (! ("rvest" %in% rownames(installed.packages())) )
{install.packages("rvest", dep=TRUE)}

# installer le paquet "httr" si ce n'est pas encore fait
# httr permet d'ouvrir des liens === requests
if (! ("httr" %in% rownames(installed.packages())) )
{install.packages("httr", dep=TRUE)}

require("rvest") # charger le paquet rvest === library("rvest")
require("httr") # charger le paquet httr  === library("httr")

# html est dans le paquet rvest par d�faut, mais est devenu pbsol�te
msn = html("https://www.msn.com/en-us/money/markets/currencies")


# La fonction GET est dans le paquet httr
msn = GET("https://www.msn.com/en-us/money/markets/currencies" )
print(paste( "code d'�tat :",  msn$status_code))


page =  content(msn) # Obtenir le contenu de la page

# *********** Q1  
currency_class = ".mjrcurrncsitem" # Le s�lecteur CSS ne change pas entre python et R
cur = html_node( page, currency_class) 

# ********** Q2
thead_class = '.mjrcurrncsrow.tblheaderrow'

header = html_node(page, thead_class)
headers = html_nodes(header, ".mctblheading") # Avez-vous pu retrouver la classe `mctblheading`  de vous m�mes ?
header_values = c()
i  = 1
for (header_element in headers){
  #*************** Note ******************#
  # La notation %>% est tr�s utile pour engencer des fonctions, et peut �tre
  # utilis�e m�me avec les fonctions d�finies par vous m�mes
  # Exemple:
  # f1 = function(x){ return(x +1)}
  # f2  = function(x){x^2}
  # print(f2(f1(2)))
  # print(f1(2) %>% f2())
  
  # header_values[i] = html_attr(html_node(header_element, "p[title]"), "title")
  header_values[i] = html_node(header_element, "p") %>% html_attr("title")
  i =  i + 1
}
print(header_values) # Affiche les en-t�tes de notre table



# ****** Q3  

trows_class = ".mjcurrncs-data" # Classe qui englobe le corps de la table

# rows_container = cur.select_one(trows_class)
rows_container = html_node(cur, trows_class)
# rows = rows_container.select( ".mcrow")
rows =  html_nodes(rows_container, ".mcrow") 
row = rows[1]
print(row)



# Cette fonction extraie les diff�rentes colonnes d'une ligen quelconque

get_row =  function(row){
  # flag = row.select_one( ".cntryflag").attrs["id"]
  flag = html_node( row, ".cntryflag") %>% html_attr("id")
  
  # cur_names = row.select_one( ".cntrycnvrsn")
  cur_names = html_node(row,  ".cntrycnvrsn") 
  # cur_name1 =  cur_names.select_one(  ".cntrycol p").attrs["title"]
  cur_name1 = html_node(cur_names,".cntrycol p" ) %>% html_attr("title") 
  # cur_name2 =  cur_names.select_one(  ".cnvrsncol p").attrs["title"]
  cur_name2 =  html_node(cur_names, ".cnvrsncol p") %>% html_attr("title")
  
  # price = row.select_one(".pricecol").select_one("p").attrs["title"]
  price = html_node(row, ".pricecol p") %>% html_attr("title")
  
  # changes = row.select_one(".chcpclub")
  changes = html_node(row, ".chcpclub")
  # chg_absolute = changes.select_one( ".chngcol p").attrs["title"]
  chg_absolute = html_node(changes, ".chngcol p") %>% html_attr("title")
  # chg_perc  = changes.select_one(  ".chpcol p").attrs["title"]
  chg_perc = html_node(changes, ".chpcol p" ) %>% html_attr("title")
  
  return(c(flag= flag, cur_name1 = cur_name1, cur_name2 = cur_name2,  price = price, 
    chg_absolute =  chg_absolute,  chg_perc =  chg_perc) )
  
}

get_row(row)


# data = [get_row(row) for row in rows]
# data = list()
data =  get_row(rows[1])
for (row in rows[-1] ){
  
  # data[i] = get_row(row)
  data = rbind(data, get_row(row))
}

class(data) # matrix

data = data.frame(data) # Conversion en data.frame

# Jusqu'ici le rpix est au fromat texte ==> conversion en num�rique
data$price = gsub(",", "", data$price,  fixed = TRUE) %>% as.character() %>%  as.numeric()

print(head(data))

print(summary(data))

barplot(data$price, names.arg = data$flag)
