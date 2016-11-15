#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#XQR:xdvora0n

##########################################################################
# MAIN STUFF
# Projekt:         XML-Query
# Predmet:         IPP - Principy programocich jazyku
# Popis:           Skript provadi vyhodnoceni zadaneho dotazu, ktery je 
#                  podobny prikazu SELECT jazyka SQL, nad vstupem ve
#                  formatu XML. Vystupem je XML obsahujici elementy
#                  splnujici pozadavky dane dotazem. Dotazovaci jazyk ma
#                  zjednodusene podminky a syntaxi.
# Soubor:          xqr.py
# Vytvoreno:       15. dubna 2012
# Posledni uprava: Pred odevzdanim
# Nakodil:         Peta Dvoracek
#
# OTHER STUFFS
# Used tabbing:    2 (spaces)
# 
##########################################################################


#############
# Knihovny. #
#############
import sys                          # Systemovy modul
import re                           # Regularni vyrzy
import xml.etree.ElementTree as xml # Parsrovani XML



##########
# Makra. #
##########

# Ridici promenne
class CTRL:
  # Nastavuji argumenty programu
  DEFAULT      = 0x00000000
  PRINT_HELP   = 0x00000001
  INPUT_FILE   = 0x00000002
  OUTPUT_FILE  = 0x00000004
  QUERY        = 0x00000008 
  QUERY_FILE   = 0x00000010 
  NOT_XML_HEAD = 0x00000020
  ROOT         = 0x00000040
  # Nastavuje SQL dotaz
  LIMIT        = 0x00000100
  WHERE        = 0x00000200
  ASC          = 0x00000400
  DESC         = 0x00000800
  # Nastavuje XML, zda bylo spusteno razeni
  ORDERING     = 0x00001000

# Regularni vyrazy
class REGEXP:
  ELEMENT   = '(\w+|\w+\.\w+|\.\w+)'  # <elem,atrib>
  LEXEM     = '("[^"]*"|\d+)'         # <lexem>
  
  # Gramatika SQL dotazu
  G1        = '^\s*SELECT\s+(\w+)'    # SELECT element             | povinne
  G2        = '(\s+LIMIT\s+\d+)?'     # LIMIT n
  G3        = '\s+FROM\s+'+ ELEMENT   # FROM <elem,atrib>          | povinne
  G4        = '(\s+WHERE\s+.*?)?'     # WHERE <cokoli az po ORDER>
                                      # o samotny vyraz se stara trida ExpParse
                                      # ORDER BY <elem,atrib> ASC|DESC
  G5        = '(\s+ORDER\s+BY\s+'+ ELEMENT +'\s+(ASC|DESC))?\s*$' 
  GRAMATICS = G1 + G2 + G3 + G4 + G5
  

#################
# Nejake funkce #
#################
# Chybove stavy, enum... no mohl jsem to dat do jedne tridy, ale chuj s tim
class ECODE:
  BAD_PARAMS             = 1;
  BAD_PARAMS_COMBINATION = 1;
  INPUT_FILE             = 2;
  OUTPUT_FILE            = 3;
  FORMAT                 = 4;
  SYNTAX                 = 80;

# Funkce na tisk chyb,   
def errExit(message, eCode):
    sys.stderr.write("Chyba: "+message+"\n")
    sys.exit(eCode)

# Tisk napovedy
def printHelp():
  print("XML Query")
  print("Skript provadi vyhodnoceni zadaneho dotazu, ktery je podobny ")
  print("prikazu SELECT jazyka SQL, nad vstupem ve formatu XML. Vystupem") 
  print("je XML obsahujici elementy splnujici pozadavky dane dotazem.") 
  print("Dotazovaci jazyk ma zjednodusene podminky a syntaxi.")
  print("")
  print("Ridici parametry")
  print("    --help          tisk teto napovedy")
  print("    --input=soubor  vstupni soubor ve formatu XML")
  print("    --output=soubor vytvori vystupni soubor ve formatu XML")
  print("    --query='dotaz' dotaz ve formatu SQL viz zadani")
  print("    --qf=soubor     dotaz je ulozen v souboru")
  print("                    krizeni s parametrem --query je zapovezeno")
  print("    -n              negenerovat XML hlavicku")
  print("    --root=element  korenovy element")


 
#############################
# Trida na parsovani vyrazu #
#############################
# Expression parsering
class ExpParse:
  def __init__ (self):
    # Definice a macra
    
    # Operace precedencni analyzy
    self.ER            = 0  # Chyba
    self.SHIFT         = 1  # Shift do zasobniku
    self.SPECIAL_SHIFT = 2  # Specialni shift
    self.REDUCE        = 3  # Redukce zasobniku
    self.OK            = 4  # Ukonceni cinnosti 
    # For debugging
    self.WTFTK = ['ERROR', 'SHIFT', 'SPECIAL_SHIFT', 'REDUCE', ':)']
    
    # Token
    # Pozor na konzistenci dat s precedencni tabulkou!!!! 
    # DO NOT TOUCH THIS!!!!!!!
    self.NOT         = 0
    self.AND         = 1
    self.OR          = 2
    self.LEFT_BARCET = 3
    self.RIGHT_BARCET= 4
    self.ID          = 5
    self.END         = 6
    self.EXPRESSION  = 7
    self.IDENT       = 8
    # For Debugging
    self.WTF = ['NOT', 'AND', 'OR', '(', ')', 'ID', '$', 'EXPR', '<']

    # PRECEDENCNI TABULKA
    # Upravim do citelne formy
    # Odradkovani v pythnu dela neplechu... :)
    OK = self.OK
    S  = self.SHIFT
    SS = self.SPECIAL_SHIFT
    R  = self.REDUCE
    E  = self.ER
    
    #          INPUT TOKENS       #
    #       !  && || (  )  i  $   # STACK TOKENS
    ROW1 = [S, R, R, S, R, S, R ] # !  -- NOT
    ROW2 = [S, R, R, S, R, S, R ] # && -- AND
    ROW3 = [S, S, R, S, R, S, R ] # || -- OR
    ROW4 = [S, S, S, S, SS,S, E ] # (  -- LEFT_BARCET
    ROW5 = [R, R, R, E, R, E, R ] # )  -- RIGHT_BARCET
    ROW6 = [R, R, R, E, R, E, R ] # i  -- ID
    ROW7 = [S, S, S, S, E, S, OK] # $  -- END
    self.PARSE_TABLE = [ROW1, ROW2, ROW3, ROW4, ROW5, ROW6, ROW7]
    
    # Promenne, se kterymi se pracuje
    self.rightParse  = []             # Vystupni pravy rozbor
    self.queue       = []             # Vstupni fronta
    self.stack       = [[self.END]]   # Pomocny stack
  # init
    
  # Upravi operator CONTAINS 
  # V pripade, ze jeho literal je cislo, zarve chybu
  # @param operator  retezec s operatorem
  # @param literal   literal 
  # @return          upraveny operator
  def fixOperator(self, operator, literal):
    number = 0;
    if re.search("^\s*\d+\s*$", literal):
      number = 1;
    if re.search("^\sCONTAINS\s$", operator):
      operator = "CONTAINS"
      # LEXEM NESMI BYT CISLO 
      if number:
        errExit("Na celociselny literal nelze aplikovat operator CONTAINS.", ECODE.SYNTAX)
    return operator
    
  # Lexikalni analyza podminky
  # Naplni vstupni frontu self.queue, v pripade chyby, zarve chybu
  # @param string  vstupni retezec
  def lexAnalysis(self, string):
    while not re.search("^\s*$", string, re.MULTILINE):
      if re.search("^\s*AND\s.*$", string, re.MULTILINE):
        tmp = re.search("^\s*AND(.*)$", string, re.MULTILINE)
        string = tmp.group(1)
        self.queue.append([self.AND])
      elif re.search("^\s*OR.*$", string, re.MULTILINE):
        tmp = re.search("^\s*OR(.*)$", string, re.MULTILINE)
        string = tmp.group(1)
        self.queue.append([self.OR])
      elif re.search("^\s*NOT.*$", string, re.MULTILINE):
        tmp = re.search("^\s*NOT(.*)$", string, re.MULTILINE)
        string = tmp.group(1)
        self.queue.append([self.NOT])
      elif re.search("^\s*\(\s*.*$", string, re.MULTILINE):
        tmp = re.search("^\s*\((.*)$", string, re.MULTILINE)
        string = tmp.group(1)
        self.queue.append([self.LEFT_BARCET])
      elif re.search("^\s*\).*$", string, re.MULTILINE):
        tmp = re.search("^\s*\)(.*)$", string, re.MULTILINE)
        string = tmp.group(1)
        self.queue.append([self.RIGHT_BARCET])
      # Parsrovani
      elif re.search("^\s*"+ REGEXP.ELEMENT +"\s*(=|<|>|\sCONTAINS\s)\s*"+ REGEXP.LEXEM +"\s*.*$", string, re.MULTILINE):
        tmp = re.search("^\s*"+ REGEXP.ELEMENT +"\s*(=|<|>|\sCONTAINS\s)\s*"+ REGEXP.LEXEM +"\s*(.*)$", string, re.MULTILINE)
        op = self.fixOperator(tmp.group(2), tmp.group(3))
        # Jedna se o cislo.. Tak ho preved na integer
        tmpb = tmp.group(3)
        if re.search("^\s*\".*?\"\s*$", tmp.group(3), re.MULTILINE):
          bezuvozovek = re.search("^\s*\"(.*?)\"\s*$", tmp.group(3), re.MULTILINE)
          tmpb = bezuvozovek.group(1)
        if re.search("^\s*\d+\s*$", tmpb):
          try: 
            tmpb = int(tmpb)
          except: 
            errExit("Syntax err. Sorry bro.", ECODE.SYNTAX)
        self.queue.append([self.ID, tmp.group(1), op, tmpb])
        string = tmp.group(4)
      else:
        errExit("Jedna se o neidentifikovatelny lexikalni predmet.", ECODE.SYNTAX)
    self.queue.append([self.END])
  # Konec lexikalni analyzy

  # Najde nejvrchnejsi terminal na zasobniku
  # @return to co nasel
  def topmostTerminal(self):
    length = len(self.stack) - 1
    token = self.stack[length]
    while token[0] == self.EXPRESSION:
      length = length - 1
      token  = self.stack[length]
    return token
  
  # Tiskne to, co je v zasobniku a ve fronte
  # Kvuli debuggingu
  def printMe(self):
    tmp = ""
    for i in range(0, len(self.queue)):
      tmp += self.WTF[self.queue[i][0]]
    print(("Fronta: ", tmp))
    
    tmp = ""
    for i in range(0, len(self.stack)):
      tmp += self.WTF[self.stack[i][0]]
    print(("Zasobnik: ", tmp))
  
  # Procedura pro shiftovani
  # Prida na zasobnik zarazku a aktualni token.
  # @param actToken   Akatualni token
  # @retrun           Dalsi token z fronty
  def shift(self, actToken):
    length = len(self.stack) -1    
    if self.stack[length][0] == self.EXPRESSION:
      self.stack.pop()
      self.stack.append([self.IDENT])
      self.stack.append([self.EXPRESSION])
    else:
      self.stack.append([self.IDENT])
    self.stack.append(actToken)
    return self.queue.pop(0)
    
  # Procedura pro specialni shiftovani.
  # Prida na zasobnik pouze aktualni token
  # @param token    Akatualni token
  # @retrun         Dalsi token z fronty
  def specialShift(self, token):
    self.stack.append(token)
    return self.queue.pop(0)

  # Redukce zasobniku, ukonci program pokud byla chybna redukce.
  # Aplikuje se nejake pravidlo, podle typu vstupniho tokenu
  # V pripade chyby, jedna se o syntaktickou chybu
  # V pripade uspechu, da aktualni token do seznamu rightParse
  # @param token   Aktualni token
  # @return        void
  def reduceStack(self, token):
    typ = token[0]
    t  = self.stack.pop()
    t2 = self.stack.pop()

    # Jedna se o identifikator
    if typ == self.ID:
      if t2[0] != self.IDENT or t[0] != self.ID:
        errExit("Spatna syntaxe podminky!", ECODE.SYNTAX)
      return;
    t3 = self.stack.pop()
    
    # Unarni operator
    if typ == self.NOT:
      if(t3[0] != self.IDENT or t2[0] != self.NOT or t[0] != self.EXPRESSION):
        errExit("Spatna syntaxe podminky!", ECODE.SYNTAX)
      return;
    t4 = self.stack.pop()
    
    # Binnarni operator
    if typ == self.AND or typ == self.OR:
      if(t4[0] != self.IDENT or t3[0] != self.EXPRESSION or t2[0] != typ or t[0] != self.EXPRESSION):
        errExit("Spatna syntaxe podminky!", ECODE.SYNTAX)
    
    # Zavorka
    if typ == self.RIGHT_BARCET:
      if(t4[0] != self.IDENT or t3[0] != self.LEFT_BARCET or t2[0] != self.EXPRESSION or t[0] != self.RIGHT_BARCET):
        errExit("Spatna syntaxe podminky!", ECODE.SYNTAX)
  # reduceStack

  # Syntakticka analyza 
  # Podle zasobniku a fronty urci dalsi operaci
  def syntaxAnalysis(self):
    actToken = self.queue.pop(0)
    while True:
      token = self.topmostTerminal();
      operation = self.PARSE_TABLE[token[0]][actToken[0]]

      # FOR DEBUGING
      #self.printMe()
      #print("token0:" + self.WTF[token[0]] + " vstupTyp: "+ self.WTFTK[actToken[0]] +" Table: "+ self.WTF[operation])

      # Tabulka rekne jakou operaci delat... 
      if operation == self.SHIFT: 
        actToken = self.shift(actToken)
      elif operation == self.SPECIAL_SHIFT:
        actToken = self.specialShift(actToken)
      elif operation == self.REDUCE:
        self.reduceStack(token)
        self.rightParse.append(token)
        self.stack.append([self.EXPRESSION])
      elif operation == self.OK:
        return
      else:
        errExit("Spatne zadany vyraz!", ECODE.SYNTAX)
  # syntaxAnalysis
    
  # Parsrovani vyrazu
  # @param string  vstupni vyraz v normalni notaci...
  # @return        vystupni vyraz v postfixove notaci
  def parse(self, string):
    self.lexAnalysis(string)
    self.syntaxAnalysis()
    return self.rightParse	
# Class expParse



#################################
# Trida na parsovani SQL vyrazu #
#################################
class Sql:
  # Inicialzace tridy
  def __init__(self):
    self.query      = None    # Dotaz se selectem
    self.select     = ""      # Hledany element
    self.limit      = None    # Max. pocet elementu
    self.fromElem   = ""      # Zdrojovy element
    self.rightParse = None    # Pravy rozbor dotazu
    self.orderBy    = None    # Podle ceho se ma radit 
  
  
  # Otevreni souboru filename
  # @param filename  retezec s nazvem programu
  # @return          obsah souboru
  def openFile(self, filename):
    try:
      f = open(filename, mode="r", encoding="utf-8")
    except IOError:
      errExit("Nepodarilo se otevrit soubor s SQL prikazem.", ECODE.INPUT_FILE)
    result = f.read()
    f.close()
    return result
    
  # Ulozeni selectu do self.query
  # @param strQuery  retezec s SQL dotazem
  # @param flags     jedna se o soubor nebo o dotaz v argumentu
  def setQuery(self, strQuery, flags):
    if(flags & CTRL.QUERY):
      self.query = strQuery;
    else:
      self.query = self.openFile(strQuery);
  
  # Syntakticka analyza dotazu SQL
  # Vsechny potrebne tokeny jsou ukladany.
  #
  # SQL dotaz muze mit volitelne veci, jako je napr. LIMIT.
  # Tyto volitelene dotazy jsou ulozeny do promenne flags.
  # @return   flags
  def parse(self):
    expression = ExpParse()
    flags = CTRL.DEFAULT;
    
    # Aplikace reg. vyrazu
    if not re.search(REGEXP.GRAMATICS, self.query):
      errExit("Spatna syntaxe dotazu.", ECODE.SYNTAX)
    token = re.search(REGEXP.GRAMATICS, self.query)
    
    # Uloz povinne veci z reg. vyrazu
    self.select     = token.group(1)
    self.fromElem   = token.group(3)

    # Volitelne vyrazy
    # Byl-li zadan limit...
    if token.group(2) != None:
      tmp = re.search("^\s*LIMIT\s+(\d+)\s*$", token.group(2))
      self.limit      = tmp.group(1)
      flags           |= CTRL.LIMIT

    # Byl zadan where, projed ho expression parserem
    if token.group(4) != None:
      tmp2 = re.search("^\s*WHERE\s*(.*?)\s*$", token.group(4))
      self.rightParse = expression.parse(tmp2.group(1))
      flags           |= CTRL.WHERE

    # Byl zadan prikaz na serazeni...
    if token.group(5) != None: 
      tmp3 = re.search("^\s*ORDER\s+BY\s+"+REGEXP.ELEMENT+"\s+(ASC|DESC)\s*$", token.group(5))
      self.orderBy    = tmp3.group(1)
      if(tmp3.group(2) == "ASC"):
        flags         |= CTRL.ASC
      else:
        flags         |= CTRL.DESC
    return flags;
  # parse
 
  # Pro debugging
  def printMe(self):
    print ("Printing object in class SQL")
    print ("Select:      ", self.select)
    print ("Limit:       ", self.limit)
    print ("From:        ", self.fromElem)
    print ("Right parse: ", self.rightParse)
    print ("Order by:    ", self.orderBy)
# Sql

##################################
# Trida na parsovani XML souboru #
##################################
class Xml:
  # Inicialzace
  def __init__(self):
    self.flags  = None   # Flagy ridici cinnost programu
    self.root   = None   # Korenovy element vstupniho XML
    self.result = []     # Vystup na tisk
    self.limit  = 4      # Kolik se ma tisknout, ta 4ka se stejne prepise :)

    # Definice
    self.FROM_ROOT         = 0
    self.ELEMENT           = 1
    self.ATTRIBUTE         = 2
    self.ELEMENT_ATTRIBUTE = 3
    
    
  # Nastaveni flagu, ridici cinnost teto tridy
  def setXml(self, iFlags):
    self.flags = iFlags

  # Nastaveni korenoveho elementu vstupu
  def setOutputRoot(self, root):
    self.outputRoot = root

  # Otevreni souboru, zda existuje
  # @param filename  retezec s nazvem programu
  def checkFile(self, filename):
    try:
      f = open(filename, mode="r", encoding="utf-8")
    except IOError:
      errExit("Nepodarilo se otevrit soubor k parsrovani.", ECODE.INPUT_FILE)
    f.close()
  
  # Element je ve formatech: (\w+|\w+\.\w+|\.\w+)
  # @param element  vstupni element
  # @return         typ elemntu
  def getTypeElem(self, element):
    if re.search("^\s*\w+\s*$", element, re.MULTILINE):
      return self.ELEMENT
    elif re.search("^\s*\w+\.\w+\s*$", element, re.MULTILINE):
      return self.ELEMENT_ATTRIBUTE
    elif re.search("^\s*\.\w+\s*$", element, re.MULTILINE):
      return self.ATTRIBUTE
    else:
      # This part of code shouldn't print...  ale jistota je jistota
      errExit("Chybny syntax...", ECODE.SYNTAX)
  
  # Vyhleda vhodneho kandidata na chteny korenovy element.
  # @param element  Element, ktery hledame.
  # @return         To co nasel.
  def getRootElem(self, element):
    typeElem = self. getTypeElem(element)

    # Format je: (\w+|\w+\.\w+|\.\w+)
    tmp = element.split('.')              
    element = tmp[0]
    if typeElem != self.ELEMENT:
      atributElem = tmp[1]
    
    # Jedna-li se o koren XML souboru
    treeRoot = (self.tree.getroot()).tag
    if element == "ROOT" or element == treeRoot:
      return self.tree.getroot()
    elif typeElem == self.ELEMENT:
      return self.tree.find(".//"+element)    #.// -- projede xml do hloubky..
    elif typeElem == self.ELEMENT_ATTRIBUTE:
      roots = self.tree.findall(".//"+element) 
      #pridat korenovy element
      root = self.tree.getroot() 
      if root.tag == element:
        roots.insert(0, root)
      for item in roots:
        for attribute in item.attrib:
          if attribute == atributElem and item.attrib[atributElem]:
            return item;
    elif typeElem == self.ATTRIBUTE:
      first = self.tree.getroot()
      roots = self.tree.findall(".//")
      roots.insert(0, first)
      for item in roots:
        for attribute in item.attrib:
          if attribute == atributElem and item.attrib[atributElem]:
            return item;
    return None
  # getRootElem
  
  # Ziskaj hodnotu elementu, podobne predchozi funkci
  # Akorat to neni uplne to same jako predchozi fce... :)
  # V pripade chybneho XML souboru, zarve chybu... 
  # @param element  Ze ktereho elementu mame ziskat hodnotu
  # @param root     Zdrojovy element, ve kterem hledame hledany element
  # @return         To, co nasel.. 
  def getValue(self, element, root):
    typeElem = self.getTypeElem(element)
    
    # Format je: (\w+|\w+\.\w+|\.\w+)
    tmp = element.split('.')
    element = tmp[0]
    if typeElem != self.ELEMENT: 
      atributElem = tmp[1]
    
    if typeElem == self.ELEMENT:
      # Koren -- tisknutelny element -- muzeme radit!!
      if self.flags & CTRL.ORDERING and root.tag == element:
        foundRoot = root;
      else:
        foundRoot = root.find(".//"+element)                #.// -- projede xml do hloubky..
        if foundRoot is None:
          return None
      # Nalazeny element, nesmi obsahovat podelementy...
      validRoot = foundRoot.findall(".//")
      if len(validRoot) == 0:
        return foundRoot.text
      else:
        errExit("Element ["+element+"] ve Vasem XML souboru obsahuje dalsi elementy, misto textove hodnoty!", ECODE.FORMAT)
    elif typeElem == self.ELEMENT_ATTRIBUTE:  # v tmp[0] je elem v tmp[1] atrib
      roots = root.findall(".//"+element) 
      roots.insert(0, root)
      for item in roots:
        for attribute in item.attrib:
          if attribute == atributElem and item.attrib[atributElem]:
            return item.get(atributElem);
    elif typeElem == self.ATTRIBUTE:
      roots = root.findall(".//")
      roots.insert(0, root)
      for item in roots:
        for attribute in item.attrib:
          if attribute == atributElem and item.attrib[atributElem]:
            return item.get(atributElem);
    return None        
  # getValue
    
  # Porovna hodnotu elementu s literalem na zaklade operace
  # @param element  element ze kterho se pak sebere jeho hodnota
  # @param item     kde se dany element nachazi
  # @param operator podle ktereho se porovnava hodnota elementu s literalem
  # @param literal  literal
  def compare(self, element, operator, literal, item):
    value = self.getValue(element, item)
    if value is None:
      return False
    # Literal je cislo, zkus prevest hodnotu elementu na cislo.
    # Kdyz to nepujde, preved element na retezec
    if isinstance(literal, int):
      try:
        value = float(value)
        value = int(value)
      except:
        literal = str(literal)
    
    # Aplikace operaci
    if operator == "CONTAINS":
      if(re.search(literal, value, re.MULTILINE)):
        return True
      else:
        return False
    elif operator == ">":
      return value > literal
    elif operator == "<":
      return value < literal
    elif operator == "=":
      return value == literal
  # compare
      
  # Funkce overi, jestli element [item] vyhovuje cele podmince,
  # jez je v postfixove notaci -- rightParse [rp]
  # @param item   element, koren, idk what... :D
  # @param rp     podminka SQL dotazu v postfixove notaci (rightParse)
  # @return       boolean, zda hledny element vyhovuje podmince 
  def match(self, item, rp):
    TK = ExpParse()   # Pouze pro konstanty, nazvy tokenu
    result = []
    # Dokud je neco v pravemRozboru
    while(len(rp) > 0):
      token = rp.pop(0)
      tokenType = token[0]
      if tokenType == TK.ID:
        tmp = self.compare(token[1], token[2], token[3], item)
        result.append(tmp)
      elif tokenType == TK.NOT:
        # Prevrat posledni prvek v seznamu
        result[-1] = not result[-1]
      elif tokenType == TK.AND:
        tmp = result.pop()
        result[-1] = result[-1] and tmp
      elif tokenType == TK.OR:
        tmp = result.pop()
        result[-1] = result[-1] or tmp
    assert len(result) == 1
    return result[0]
  # match
  
  # Seradeni vysledku
  # @param orderBy  podle jakeho elementu se ma radit
  def sortResult(self, orderBy):
    self.flags |= CTRL.ORDERING
    sorting = {}
    # Ziskam jejich hodnoty...
    for item in self.result:
      value = self.getValue(orderBy, item)
      sorting[item] = value
    # Ktere seradim
    try:
      self.result = sorted(self.result, key=sorting.__getitem__)
    except:
      errExit("Hele, nenasel element, podle ktereho se ma radit. Zkus to jeste raz.", ECODE.FORMAT)
    # Reverzuju, pokud hledame od nejvyssiho
    if self.flags & CTRL.DESC:
      self.result.reverse()
    # Nyni je pole serazeno. Prihod do pole atribut order s jejich indexem
    index = 1;
    for item in self.result:
      item.set("order", str(index))
      index += 1
  
  # Parsrovani souboru podle SQL dotazu
  # Pred volanim teto funkce nezapomen nastavit flagy, 
  # @param filename  nazev souboru k parsrovani
  # @param sql       instance me tridy Sql, s parametry
  def parse(self, filename, sql):
    self.checkFile(filename)
    # Otevri soubor a rozparsruj jej pomoci modulu xml.etree.ElementTree
    try:
      self.tree = xml.parse(filename)
    except:
      errExit("Spatny format souboru.", ECODE.FORMAT)
      
    # Najdi mi korenovy element
    rootElement = self.getRootElem(sql.fromElem)
    if rootElement is None:
      return;
      
    # Najdi mi hledane elementy
    selectedItems = rootElement.findall(".//"+sql.select)
    if selectedItems is None:
      return;
      
    # Uloz elementy splnujici podminku
    if self.flags & CTRL.WHERE: # Jestli byla zadana..
      for item in selectedItems:
        if self.match(item, sql.rightParse[:]): # [:] => nedojebe sql.rightParse
          self.result.append(item)
    else:
      for item in selectedItems:
        self.result.append(item)
      
    # Pokud je chceme seradit...
    if self.flags & CTRL.ASC or self.flags & CTRL.DESC:
      self.sortResult(sql.orderBy)
    
    # Nastavime limit pro pozdejsi tisknuti...
    if self.flags & CTRL.LIMIT:
      try:
        self.limit = int(sql.limit)
      except:
        errExit("Syntax error", ECODE.SYNTAX)
  # parse
  
  # Vystup upravi do chtene podoby, zalezi jak jsou nastavene flagy!
  # @return  retezec s obsahem vystupniho souboru
  def getResult(self):
    result = "" 
    if not self.flags & CTRL.NOT_XML_HEAD:
      result += "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    if self.flags & CTRL.ROOT:
      result += "<"
      result += self.outputRoot
      result += ">\n"
    if self.flags & CTRL.LIMIT:
      self.result = self.result[:self.limit]
    for record in self.result:
      tmp = xml.tostring(record)
      if isinstance(tmp, bytes):
        result += tmp.decode('utf-8') +"\n"
      else:
        result += tmp + "\n"
    if self.flags & CTRL.ROOT:
      result += "</"
      result += self.outputRoot 
      result += ">\n"
    return result
  # getResult
  
  # Tiskne do souboru, podle getResult
  # @param filename  nazev vystupniho souboru, nebyl-li zadan, tiskne se na stdout
  def printXml(self, filename):
    if self.flags & CTRL.OUTPUT_FILE:
      try:
        fileHandler = open(filename,  mode="w", encoding="utf-8")
      except:
        errExit("Nepodarilo se otevrit vystupni soubor!", ECODE.OUTPUT_FILE)
      fileHandler.write(self.getResult())
    else:
      sys.stdout.write(self.getResult())

      
################################################################################ 
# Hlavni funkce
# @parm argv parametry programu
def main(argv):
  sql = Sql()
  xml = Xml()
  argInputFile  = None
  argOutputFile = None
  flags = CTRL.DEFAULT  # Natavim vlajky na defaultni hodnotu
  first = 1             # Pro preskoceni nazvu programu
  # Iteruj argumentama
  for actArg in sys.argv:
    tmp = re.search('^\s*(.+)\s*$', actArg) # Orezani aktualniho argumentu
    actArg = tmp.group(1)
    # Byl=li zadan parametr
    tmp = re.search('^[^=]+=(.+)$', actArg)
    if actArg == "--help":
      printHelp()
      exit()
    elif re.search('^--input=.+$', actArg) and not flags & CTRL.INPUT_FILE:
      flags |= CTRL.INPUT_FILE
      argInputFile = tmp.group(1)
    elif re.search('^--output=.+$', actArg) and not flags & CTRL.OUTPUT_FILE:
      flags |= CTRL.OUTPUT_FILE
      argOutputFile = tmp.group(1)
    elif re.search('^--query=.+$', actArg) and not flags & CTRL.QUERY:
      flags |= CTRL.QUERY
      argQuery = tmp.group(1)
    elif re.search('^--qf=.+$', actArg) and not flags & CTRL.QUERY_FILE:
      flags |= CTRL.QUERY_FILE
      argQuery = tmp.group(1)
    elif re.search('^-n$',actArg) and not flags & CTRL.NOT_XML_HEAD:
      flags |= CTRL.NOT_XML_HEAD
    elif re.search('^--root=.+', actArg) and not flags & CTRL.ROOT:
      flags |= CTRL.ROOT
      argRoot = tmp.group(1)
      xml.setOutputRoot(argRoot)
    # Prvni iterace jest jmeno souboru.
    elif first == 1:
      first = 0;
    else:
      errExit("Nezname parametry. Spustte program s prikazem --help.", ECODE.BAD_PARAMS)
  # End for, iterace
  
  # Nedovolena kombinace parametru...
  if flags & CTRL.QUERY and flags & CTRL.QUERY_FILE:
    errExit("Spatna kombinace parametru", ECODE.BAD_PARAMS_COMBINATION)
  if not flags & CTRL.QUERY and not flags & CTRL.QUERY_FILE:
    errExit("Spatna kombinace parametru", ECODE.BAD_PARAMS_COMBINATION)
  
  # Nastavim flags a parsruju SQL dotaz.
  sql.setQuery(argQuery, flags)
  flags |= sql.parse()
  # Nastavim flags a parsruju XML soubor, ktery pak vytiskneme
  xml.setXml(flags)
  xml.parse(argInputFile, sql)
  xml.printXml(argOutputFile)
# end function main 

main(sys.argv)
exit(0)
# Konec souboru: xqr.py
