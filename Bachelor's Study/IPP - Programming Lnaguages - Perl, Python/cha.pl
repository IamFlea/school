#!/usr/bin/perl

#CHA:xdvora0n

# Soubor:  cha.pl
# Projekt: Analyza hlavickovych souboru v perlu 
# Predmet: IPP
# Datum:   10.2. - 25.3.
# Autor:   Peta Dvoracek
# 
# Note:         I am not responsible of this code.                #
#             They made me write it, against my will.             #


###################################
# Potrebujem knihovny, liter-a-tury pro moduly
use locale;					# Nastaveni aktualniho jazyka.. viz ceske x anglicke razeni.
use File::Find;     # Ekvivalnce k linuxove fci: find [dir]
#use Getopt::Long;  # TLDR, priste az budes nekdy programovat v perlu. Tak to pouzij.. 
										# nechce se mi s tim tedkom srat ;)
use open IO => ":encoding(utf-8)";
use warnings;
#use strict;

###################################
# ZPRACOVANI PARAMETRU bez getopt...

# Inicializuji ridici promenne.
$help              = 0;
$c_input           = -1; #pokud je to string: ($input == 0) => true 
$c_output          = -1; #pokud je to string: ($output == 0) => true
$pretty_xml        = -1; #min pocet mezer muze byt 0 (w/o space), ale ne -1
$no_inline         = 0;
$max_params        = -1; #min pocet parametru muze byt 0, ale nesmi byt -1
$no_duplicates     = 0;
$remove_whitespace = 0;

foreach $i (0 .. $#ARGV)
{
	if (($ARGV[$i] eq "--help") &&  $help == 0)
	{
		$help = 1;
	}
	elsif (($ARGV[$i] =~ /--input=.+/) && $c_input == -1)
	{
		$c_input = 1;
		$input = ($ARGV[$i] =~ /--input=(.+)/)[0];
	}
	elsif (($ARGV[$i] =~ /--output=.+/) && $c_output == -1)
	{
		$c_output = 1;
		$output = ($ARGV[$i] =~ /--output=(.+)/)[0];
	}
	elsif (($ARGV[$i] eq "--pretty-xml") && $pretty_xml == -1)
	{
		$pretty_xml = 4;
	}
	elsif (($ARGV[$i] =~ /--pretty-xml=[0-9]+/) && $pretty_xml == -1)
	{
		$pretty_xml = ($ARGV[$i] =~ /--pretty-xml=([0-9]+)/)[0];
	}
	elsif (($ARGV[$i] eq "--no-inline") && $no_inline == 0)
	{
		$no_inline = 1;
	}
	elsif (($ARGV[$i] =~ /--max-par=[0-9]+/) && $max_params == -1)
	 {
		$max_params = ($ARGV[$i] =~ /--max-par=([0-9]+)/)[0];
	}
	elsif (($ARGV[$i] eq "--no-duplicates") && $no_duplicates == 0)
	{
		$no_duplicates = 1;
	}
	elsif (($ARGV[$i] eq "--remove-whitespace") && $remove_whitespace == 0)
	{
		$remove_whitespace = 1;
	}
	else
	{
		$! = 1;
		die "Chybne zadani parametru.\n";
	}

} # foreach - zpracovani parametru


###################################
## Tisk napovedy

if ($help == 1)
{
	if($c_input == -1 && $c_output == -1 && $pretty_xml == -1 && $no_inline == 0 && $max_params == -1 && $no_duplicates == 0 && $remove_whitespace == 0)
	{
		print "C Header Analysis\n";
		print "-----------------\n";
		print "Skript analyzuje hlavickove soubory jazyka C.\n";
		print "Vytvori databazi ve forme XML nalazenych funkci v techto souborech.\n";
		print "Pouziti:\n";
		print "\t--help              vypise tuto napovedu\n";
		print "\t--input=fileordir   vstupni soubor/adresar se zdrojaky,\n";
		print "\t                    neni-li pouzito, vstup je akt. adresar\n";
		print "\t--output=filename   vystupni soubor formatu XML,\n";
		print "\t                    neni-li pouzito, vystup je na stdout\n";
		print "\t--pretty-xml=k      kazde nove zanoreni odsadi o k mezer\n";
		print "\t                    vychozi zanoreni k je 4\n";
		print "\t--no-inline         preskoci fce se specifikatorem inline\n";
		print "\t--max-par=n         skript preskoci funkce s parametry\n";
		print "\t                    vetsi nez n (n musi byt vzdy zadano)\n";
		print "\t--no-duplicates     ulozi prvni vyskyt duplicitni fce\n";
		print "\t--remove-whitespace odstrani prebytecne mezery\n";
		print "Autor: Petr Dvoracek (xdvora0n)\n";
		exit;
	}
	else
	{
		$! = 1;
		die "Chyba: Nedovolena kombinace parametru!\n";
	}
} 
# tisk napovedy


###################################
# Nacteni cest souboru do pole...

# Nebyl zadany vstupni soubor => vstupem je aktualni adresar
if ($c_input == -1)
{
	$input = ".";
}

# Overim existenci souboru
if(! (-e $input))
{
	$! = 2;
	die "Chyba: Soubor nenalezeny. Zkuste se podivat pod stul.\n";
}

# Tento usek kodu dela to co: find $input | grep -e ".*\.h$"
# Soubor je adresarem
if(-d $input)
{
	$soubor = 0; # Jedna se o adresar
	# Subrutina nalezne hlavickovy soubor a pushne jej do pole
	sub find_files
	{
		if($File::Find::name =~ /.*\.h$/)
		{
			push(@header_files,  $File::Find::name); 
		}
	}
	find(\&find_files, $input); # find_files = subrutina; input == startDir;
}
# Soubor neni adresar
else
{
	@header_files = ($input);
	$input = "";
	$soubor = 1; # Jedna se o soubor
}

# Esteticna uprava, kvuli printovani... 
if($input eq ".")
{
	$input = "./";
}

##################################
# Ze souboru dostane do pole, pozadovane parametry.
# $header_files[$file_name]

$id_fce = 0;    # Index funkce, take udava celkovy pocet funkci
# Pro kazdy nalezeny soubor mi delej tyto veci...
foreach $file_name (@header_files)
{
	# Otevri jej... Nelze? Tak zavri zobak teda...program!
	if(! open(FILE, "<$file_name")) # To mensitko otevre v read only modu
	{
		$! = 2;
		die "Chyba: Nepodarilo se otevrit soubor. Jedete na prava....\n";
	}


	##
	# Nejdrive odstraneni blokovych komentaru!! 
	$temp_file = "ZACATEK SOUBORU;"; # Ulozim si soubor do retezce, 
	                	# abych se pak nesral s blokovymi komentari v c...
										# Strednik na zacatku souboru je proto,
										# aby mi to sezralo pozdejsi reg exp.
	foreach $line (<FILE>)
	{
		$temp_file .= "$line";
	}
	
	# Odstran blokove komentare....
	$temp_file =~ s/\/\*.*?\*\///gs;

	# Odstran makra a radkove komentare...
	$temp_file =~ s/\s*#.*$//gm;
	$temp_file =~ s/\s*\/\/.*$//gm;
	# $temp_file =~ s/^\s*\/\/.*$//gm;
	# Regexp, ktery mi u kazde funkce da do pole:
	#   navratovou hodnotu, jeji nazev, a retezec parametru. (viz *)
	#
	# [};]               // zacatek noveho prikazu... makra a includy jsou vyreseny....
	# \s*                // lib pocet mezer  
	# ([\w\*][\w\s\*]*)  // *navratovy typ funkce - musi zacinat * nebo pismenem, a muze obsahovat i mezery
	# (\b\w+)\s*         // *nazev funkce         - musi to byt cele slovo! -> \b = [bounded]
	# \(                 // zacatek parametru
	# ([,\.\w\s\*]*)     // *parametry funkce     - obsahuji krome slov (\w), i "," ba i "*", ba i "."!
	# \)[\s]*            // konec parametru, nasledovan libovolnym poctem mezer
	# (?=[;{])           // look ahead, takova pojistka zda to opravdu pokracuje zavorkou ci strednikem..
	#
	@parsed_functions = $temp_file =~ /[};]\s*([\w\*][\w\s\*]*)\s(\w+)\s*\(([,\w\s\*\.]*)\)[\s]*(?=[;{])/gs;
	
	$i = 0;         # Index ve "vyparsrovanych" hodnotach z predchoziho regexpu
	$ok = 1;        # Ridici promenna, jestli se ma ulozit funkce.. 
	foreach $item (@parsed_functions)
	{

		# Kazda prvni polozka pole je navratova hodnota funkce
		if($i == 0)
		{
			$function_return = ($item =~ /^\s*(.+?)\s*$/)[0];

			# Bylo-li zadano --no-inline, preskoc pak takovou fci.
			if($no_inline && ($function_return =~ /inline/))
			{
				$ok = 0;
			}

			# Odstraneni bilych mezer
			if($remove_whitespace)
			{
				$function_return =~ s/\s+/ /gs;
				$function_return =~ s/\s\*/\*/gs;
				$function_return =~ s/\*\s/\*/gs;
			}
			$i++; # Prejdi na dalsi polozku..
		} # return_fce

		# Kazda druha polozka je nazev funkce
		elsif($i == 1)
		{
			$function_name = ($item =~ /^\s*(.+?)\s*$/)[0];
			
			# Pokud se jedna o duplikat funkce, preskoc prosim.i
			if($no_duplicates)
			{
				# Prohledam cele pole funkci.
				for($j = 0; $j < $id_fce; $j++)
				{
					if($function_name eq $function[$j][1][0])
					{
						$ok = 0;	#Preskoc funkci
					}
				}
			}
			$i++; # Prejdi na dalsi polozku
		} #nazev
		
		# Kazda treti polozka jsou parametry funkce
		elsif($i == 2)
		{
			$varargs = "no";
			if($item =~ /^\s*$/) # ma vubec nejake parametry?
			{
				$total_params = 0;
			}
			elsif($item =~ /^\s*void\s*$/)
			{
				$total_params = 0;
			}
			else
			{
				# Rozdel mi skupinu parametru, na parametry...
				@params = split(",", $item);					# rozdel pomoci , 
				$total_params = scalar @params; 			# pocet parametru celkem

				for($j = 0; $j < $total_params; $j++)
				{
					# Jsou parametry variabilni?
					if($params[$j] =~ /\.\.\./)
					{
						$varargs = "yes";
						$total_params--;
					}
					else
					{
						# Odstraneni prebytecnych mezer na zacatku a na konci
						$params[$j] = ($params[$j] =~ /^\s*(.*?)\w+\s*$/)[0];
						$params[$j] = ($params[$j] =~ /^(.*?)\s*$/)[0];
						# Odstraneni bilych mezer uprsotred
						if($remove_whitespace)
						{
							$params[$j] =~ s/\s+/ /gs;
							$params[$j] =~ s/\s\*/\*/gs;
							$params[$j] =~ s/\*\s/\*/gs;
						}
					}
				}
				
				# Jestlize byl nastaveny maximalni pocet parametru, zkontroluj to...
				if($max_params != -1)
				{
					# ...pokud nevyhovuje... danou fci preskoc
					if($max_params < $total_params)
					{
						$ok = 0;
					}
				}
			}#parametry

			## UKLADANI
			# Pokud vse probehlo v poradku, uloz funkci
			if($ok)
			{
				$function[$id_fce][0][0] = ($file_name =~ /^$input(.*)$/)[0]; # Soubor - adresar
				$function[$id_fce][1][0] = $function_name;
				$function[$id_fce][2][0] = $varargs;
				$function[$id_fce][3][0] = $function_return;
				$function[$id_fce][4][0] = $total_params;
				# Uloz parametry funkce od 1ky!!
				for($j = 0; $j < $total_params; $j++)
				{	
					$function[$id_fce][5][$j+1] = $params[$j]; # Inkrementuje poradove cislo!
				}

				$id_fce++;		# Inkrementuj index funcke
			}
			$ok = 1;    # Nastaveni ridici promenne
			$i = 0;     # Pocitadlo vyresetuj.
		} # zpracovani prametru + ulozeni
	} # fce
	close FILE;
} # soubor

####
# Graficka uprava vystupniho souboru..
$pretty_n = "";
$pretty   = "";
if($pretty_xml != -1)
{
	$pretty_n = "\n";
	for($i = 0; $i < $pretty_xml; $i++)
	{
		$pretty = $pretty." ";
	}
}
if($soubor == 1)
{
	$input = "";
}
##
# Le print na stdout
if($c_output == -1)
{
	print "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
	print $pretty_n;
	print "<functions dir=\"$input\">";
	print $pretty_n;
	for($i = 0; $i < $id_fce; $i++)
	{	
		print	$pretty;
		print "<function file=\"$function[$i][0][0]\" name=\"$function[$i][1][0]\" varargs=\"$function[$i][2][0]\" rettype=\"$function[$i][3][0]\">";
		print $pretty_n;
		for($j = 1; $j <= $function[$i][4][0]; $j++)
		{
			# Dvoji odsazeni!
			print $pretty;
			print $pretty;
			print "<param number=\"$j\" type=\"$function[$i][5][$j]\" />";
			print $pretty_n;
		}
		print $pretty;
		print "</function>";
		print $pretty_n;
	}
	print "</functions>\n";
}
#####
# Le print do souboru
else
{
	if(! open(FILE, ">$output")) # To vetsitko je write only mod
	{
		$! = 3;
		die "Chyba: Nepodarilo se otevrit vystupni soubor. Jedete na prava....\n";
	}

	print FILE "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
	print FILE $pretty_n;
	print FILE "<functions dir=\"$input\">";
	print FILE $pretty_n;
	for($i = 0; $i < $id_fce; $i++)
	{	
		print FILE $pretty;
		print FILE "<function file=\"$function[$i][0][0]\" name=\"$function[$i][1][0]\" varargs=\"$function[$i][2][0]\" rettype=\"$function[$i][3][0]\">";
		print FILE $pretty_n;
		for($j = 1; $j <= $function[$i][4][0]; $j++)
		{
			# Dvoji odsazeni!
			print FILE $pretty;
			print FILE $pretty;
			print FILE "<param number=\"$j\" type=\"$function[$i][5][$j]\" />";
			print FILE $pretty_n;
		}
		print FILE $pretty;
		print FILE "</function>";
		print FILE $pretty_n;
	}
	print FILE "</functions>\n";
}
# Konec souboru: cha.pl
