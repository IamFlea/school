# Projekt: Hledani ryziho Nashova equilibria pomoci GA 
# Autor: Petr Dvoracek
 
# Importnu nahodnou tridu (42)
import random


global players, matrix, magic_table, popsize, gen, chce_lahvi, zacatek_cen, g_methanol_v_lahvi, g_cena_jedne_lahve,max_generations
global skoncit


########################################################################
# CGP parametry: TOHLE MENIT!!!
#
hra = 5 # prijima 1 2 3 4 5,
# Hra 1 a 2 jsou nejake jednoduche hrz, viz matice dole, 
# Hra 3 je nahodne generovani a 4 obchodnik s napoji u obou plotime graf. (Nemusi byt nainstalovan)
if hra == 5:
	# Pro hru pet jsem zvolil jine parametry
	pop_size = 40              # Velikost populace
	max_generations = 500      # Pocet generaci
	probabilty_xover = 0.8     # Pravdepodobnost krizeni
	probabilty_mutation = 0.2  # Pravdepodobnost mutace, kdyz se to zkrizi 
	xover_count = 2            # Pocet bodu krizeni
	mutation_count = 3         # Pocet mutovanych genu
	kids_count = 20            # Pocet decek
	pocet_hracu = 10           # Pocet hracu
else:
	pop_size = 20              # Velikost populace
	max_generations = 50       # Pocet generaci
	probabilty_xover = 0.8     # Pravdepodobnost krizeni
	probabilty_mutation = 0.2  # Pravdepodobnost mtuace, kdyz se to zkrizi
	xover_count = 1            # Pocet bodu krizeni
	mutation_count = 1         # Pocet mutovanych genu
	kids_count = 10            # Pocet deti


# Parametry pro hru 4 - viz doku (Pozor pri blbe volbe, nemusi mit model PNE!)
chce_lahvi = 150             # Pocet lahvi L obchodnika
zacatek_cen = 20             # Zacatek cen napr pro S = (s1, s2 .. s25) -> S = (20 21 .. 44)
g_methanol_v_lahvi = [2,1]   # Faktor kvality, velikst = poctu hracu
g_cena_jedne_lahve = [15,20] # Cena lahve


# Na parametry nize se nedoporucuje sahat.
# Pozor pri spatne zmene, nemusi mit model PNE!
# Cellmodel pro hru 4
def cellModel_alkohol(profile):
	methanol_v_lahvi = g_methanol_v_lahvi[:len(profile)]
	cena_jedne_lahve = g_cena_jedne_lahve[:len(profile)]
	# Jak prasit v pythonu. By dvoracek.
	z_ceny_pdp_nakupu = lambda v : 0.0 if v > 20 else 1.0 - v*0.05
	cena = map(lambda x : x + zacatek_cen, profile)
	# Kolik koupi lahvi?
	koupi_lahvi = map(lambda x : x - min(cena), cena)
	koupi_lahvi_pdp = map(z_ceny_pdp_nakupu, koupi_lahvi)
	koupi_lahvi = map(lambda x : int(chce_lahvi*x/sum(koupi_lahvi_pdp)), koupi_lahvi_pdp)
	vydelek = map(lambda x , y,z  : (x - y)*z, cena, cena_jedne_lahve, koupi_lahvi)
	meth = map(lambda x, y : x*y, koupi_lahvi, methanol_v_lahvi)
	result = map(lambda x, y : x -y, vydelek, meth)
	return result

# Cellmodel pro hru 5
def cellModel_dominance(profile):
	return [sum(profile) for i in profile]

# Volba cellmodelu
if hra == 5:
	cellModel = cellModel_dominance
elif hra == 4:
	cellModel = cellModel_alkohol

# Dale uz radeji nesahat
#########################################################################

if pop_size < 3:
	print "Mala populace!!!"
	exit(1)
# Nebudeme tisknout graf, jen pro hru 4
plot = False
if hra == 1:
	# Dilemma vezneske
	players = [2,2] # |S1| |S2|
	matrix = [[10,10], # U1(1,1), U2(1,1)
			  [1, 30], # U1(1,2), U2(1,2)
			  [30,1 ], # U1(2,1), U2(2,1)
			  [2, 2 ]] # U1(2,2), U2(2,2) toto je PNE
elif hra == 2:
	# Nejaka vetsi hra
	players = [3,2,2] # metadata o hre
	matrix = [[1, 2, 3],    # U1(1,1,1), U2(1,1,1), U3(1,1,1) ...
			  [7, 8, 9],    # 1 1 2
			  [4, 5, 6],    # 1 2 1
			  [10, 11, 12], # 1 2 2
			  [13, 14, 4],  # 2 1 1
			  [3, 0, 21],   # 2 1 2
			  [16, 17, 18], # 2 2 1 toto je PNE (1 1 0) bo cislujeme od nuly
			  [2, 0, 1],    # 2 2 2 
			  [20, 5, 10],  # 3 1 1 toto je PNE (2 0 0)
			  [9,  9, 8],  # 3 1 2
			  [4, 3, 2],    # 3 2 1
			  [20, 10, 11]] # 3 2 2 toto je PNE (2 1 1)
			  # Pro gambid POZOR, ma tam cudne indexovani tretiho hrace!!
elif hra == 3:
	players = [30,30] # 30**2 reseni
	plot = True
	matrix_cells_cnt = reduce(lambda x,y : x*y, players) # Vypoctu kolik ma matice bunek 
	matrix = [[random.randint(0,100) for i in xrange(len(players))] for i in xrange(matrix_cells_cnt)]      # Lets rock
	# Ma to pokracovani...
elif hra == 4: 
	players = [30,30] # |S1|, |S2|, |S3|
	plot = True # Vykreslit graf, pouze pro hru 4
	# Ma to pokracovani, amtici definuju poydeji, potrebuju magic_table kolik ma rha hracu
elif hra == 5:
	players = [30]*pocet_hracu
else:
	print "Typ hrz ma nabyvat arabskych cislic 1 2 3 4 anebo 5!"
	exit(1)



# Abrakadabra tabulka pro vypocet indexu (jeji velikost len() = pocet hracu)
# Oro matrix_b je vysledek [1 2 4 12], mely by to byt indexy kdy se meni strategie hracu v tabulce.
magic_table = list([1] + players[::-1])  # prvni idx ma vahu 1 // vzdy
magic_table = [magic_table[:i+1] for i in xrange(len(players))] # Zbytek zalezi na poctu opakovani
magic_table = map(lambda x: reduce(lambda y,s: y*s, x), magic_table)
magic_table = magic_table[::-1] # reversed

# Funkce na ziskani indexu do ohodnocovaci matice dane strategie.
def get_idx(strat):
	return sum(map(lambda x, y : x * y, strat, magic_table))

if hra == 3:
	# Vpichneme injekci Nashova equilibria, jedna se best response... Toz at ho ten program najde ne??
	idx = [random.randint(0,strat-1) for strat in players]
	matrix[get_idx(idx)] = [120 for i in xrange(len(players))]
	print idx, "by melo byt PNE"
elif hra == 4:
	# Vygeneruje celou matici
	matrix_cells_cnt = reduce(lambda x,y : x*y, players) # Vypoctu kolik ma matice bunek 
	t =  magic_table
	matrix = []
	for i in xrange(matrix_cells_cnt):
		x = []
		val = i
		for s in t:
			x.append(val/s)
			val = val%s
		matrix.append(x)
	for idx in xrange(len(matrix)):
		matrix[idx] = cellModel(matrix[idx])
# 
	
global haxx_matrix
haxx_matrix = {}
# Ohodnoceni daneho progilu vzuyivajici cellModel
def eval_better(profile):
	global gen, skoncit
	fitness = 0
	try:
		haxx_cell = haxx_matrix[str(profile)]
	except:
		haxx_matrix[str(profile)] = cellModel(profile)
		haxx_cell = haxx_matrix[str(profile)]
	for i in xrange(len(profile)):
		profile_tmp = list(profile)
		# Vypocteme max[]
		maximum = 0
		for j in xrange(players[i]):
			profile_tmp[i] = j
			try:
				haxx_cell_tmp = haxx_matrix[str(profile_tmp)]
			except:
				haxx_matrix[str(profile_tmp)] = cellModel(profile_tmp)
				haxx_cell_tmp = haxx_matrix[str(profile_tmp)]
			tradeoff = haxx_cell_tmp[i]
			if tradeoff > maximum:
				maximum = tradeoff
		tradeoff = haxx_cell[i] # Uzitek hrace i pro dany profil hry
		fitness += maximum - tradeoff
	if not plot and fitness == 0:
		skoncit = True
	return fitness 


# Ohodnoceni daneho profilu, nepouziva cellmodel
def evaluate_naive(profile):
	# Ziskame profil indexu
	fitness = 0
	profile_idx = get_idx(profile)
	for i in xrange(len(players)):
		profile_tmp = list(profile)
		# Vypocteme max[]
		maximum = 0
		for j in xrange(players[i]):
			profile_tmp[i] = j
			idx = get_idx(profile_tmp)
			tradeoff = matrix[idx][i]
			if tradeoff > maximum:
				maximum = tradeoff
		tradeoff = matrix[profile_idx][i] # Uzitek hrace i pro dany profil hry
		fitness += maximum - tradeoff
	if not plot and fitness == 0 and hra == 4:
		print "Found PNE", profile ,"at generation", gen
		exit(1)
	return fitness 

if hra == 5 :
	evaluate = eval_better
else:
	evaluate = evaluate_naive

# Implementace turnaje
# POZOR VRACI REFERENCE!!
def tournament(pop, fit):
	a_idx = random.randint(0,len(pop)-1)
	while True: # Zachovani diverzity
		b_idx = random.randint(0,len(pop)-1)
		if b_idx != a_idx:
			break
	if fit[a_idx] < fit[b_idx]: # Fitness minimalizujeme
		return pop[a_idx], fit[a_idx]
	else:
		return pop[b_idx], fit[b_idx]


	
# Predehra rodicu
def foreplay(pop, fit): 
	# Aby to bylo dramaticke, tak si rodice zahrajou turnaj. 
	while True:
		father = tournament(pop, fit)
		mother = tournament(pop, fit)
		if mother[0] is not father[0]: # FUJ
			return list(father[0]), list(mother[0])

# Vztvoreni nove populace (selekce populace do dalsi generace)
def new_pop(pop, fit):
	new_pop = []
	new_fit = []
	for i in xrange(pop_size):
		chrom, fit_value = tournament(pop, fit)
		new_pop.append(list(chrom))
		new_fit.append(fit_value)
	return new_pop, new_fit

# Vygeneruju pocatecni populaci kandidatnich nashovych equilibrii
pop = [[random.randint(0, strategy_cnt-1) for strategy_cnt in players] for i in xrange(pop_size)]
# Ohodnotim populaci
fit = map(lambda x : evaluate(x), pop)
skoncit = False
for gen in xrange(max_generations):
	# Vyroba miminek....
	kids = []
	for kid_idx in xrange(kids_count): 
		kid_a, kid_b = foreplay(pop, fit) # Ziskam informaci rodicu (Escalted quickly!)
		
		# Zkrizim
		if random.random() < probabilty_xover:
			for variable in xrange(xover_count):
				point_xover = random.randint(1,len(players)-1)
				kid_a = kid_a[:point_xover] + kid_b[point_xover:]
			# S nejakou pravdepodbnosti pridam izotop Uranu 238 
			if random.random() < probabilty_mutation:
				for variable in xrange(mutation_count):
					gene_idx = random.randint(0,len(players)-1)
					value = kid_a[gene_idx]
					while value == kid_a[gene_idx]:
						kid_a[gene_idx] = random.randint(0, players[gene_idx]-1)
		else:
			# Aby byla zachovana diverzita jedincu davam na deti rovnou mutaci
			gene_idx = random.randint(0,len(players)-1)
			value = kid_a[gene_idx]
			while value == kid_a[gene_idx]:
				kid_a[gene_idx] = random.randint(0, players[gene_idx]-1)
		kids.append(kid_a)
	# Ohodnotim deti
	fit_kids = map(lambda x : evaluate(x), kids)
	if skoncit:
		pop = pop + kids
		fit = fit + fit_kids
		break
	# Pridam je do stavajici populace, ze ktere vytvorim NOVOU populaci.
	pop, fit = new_pop(pop + kids, fit + fit_kids)

print "Nejlepsi nalezeny vysledek v generaci:", gen
print "Souradnice:",pop[fit.index(min(fit))],"S fitness:",min(fit)
if len(haxx_matrix) != 0:
	print "Velikost slovniku:",len(haxx_matrix)
else:
	print "Velikost slovniku:",len(matrix)



def makeplot(): 
	# Prevzaty kus kodu z knihovny mplot3d
	# Jsem rad ze jsem vyplotil, to co jsem vyplotil v doku
	from mpl_toolkits.mplot3d import Axes3D
	from matplotlib import cm
	from matplotlib.ticker import LinearLocator, FormatStrFormatter
	import matplotlib.pyplot as plt
	import numpy as np
	
	minim = 999999
	fig = plt.figure()
	ax = fig.gca(projection='3d')
	X = np.arange(0, players[0], 1)
	Y = np.arange(0, players[1], 1)
	X, Y = np.meshgrid(X, Y)
	T = []
	for i in xrange(players[0]):
		K = []
		for j in xrange(players[1]):
			s = evaluate([i,j])
			K.append(s)
			if s < minim:
				minim =s
		T.append(np.asarray(K))
	Z = np.asarray(T)
	#print "Minimum: ", minim

	surf = ax.plot_surface(X, Y, Z, rstride=1, cstride=1, cmap=cm.coolwarm,
	        linewidth=0, antialiased=False)
	if hra == 3:
		ax.set_zlim(0, 200)
	else:
		ax.set_zlim(0, 2800)
	
	ax.zaxis.set_major_locator(LinearLocator(10))
	ax.zaxis.set_major_formatter(FormatStrFormatter('%.02f'))
	
	fig.colorbar(surf, shrink=0.5, aspect=5)
	
	plt.show()
try:
	if plot:
		makeplot()
except:
	# YOU SHALL NOT
	pass