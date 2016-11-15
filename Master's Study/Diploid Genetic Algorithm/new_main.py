#!/usr/bin/env python2
import random
from operator import itemgetter
from copy import deepcopy
random.seed()

CHROM_LENGTH = 100
CROSSOVER_PROBABILITY = 0.7
MUTATION_PROBABILITY = 0.01
ENVIROMENT_CHANGE = 50
CHANGES_COUNT=0.5
phenotype = [0]*CHROM_LENGTH 
enviroment = [0]*CHROM_LENGTH
ones = [1]*CHROM_LENGTH
template = [1]*CHROM_LENGTH
xor = lambda x, y: x ^ y


def initPop(population):
    """
    @param population Individuals count.
    @return population List of individuals chromosmes and it fitness
    """
    global CHROM_LENGTH
    result = []
    for i in xrange(population):
        individual_a = []
        individual_b = []
        for j in xrange(CHROM_LENGTH):
            individual_a.append(random.randint(0,2))
            individual_b.append(random.randint(0,2))
        result.append([individual_a, individual_b, 0]) # Default fitness is zero.
    return result


def enviromentChange():
    global enviroment
    global CHROM_LENGTH
    global CHANGES_COUNT
    global xor
    global template
    for i in xrange(CHROM_LENGTH):
        enviroment[i] ^= int(random.random() < CHANGES_COUNT)

def evalPop(population):
    global phenotype
    global template 
    global CHROM_LENGTH
    global xor
    for individual in population:
        # create phenotype
        for gene_idx in xrange(CHROM_LENGTH):
            # Holstain-holland representation of alleles. See pdf.
            phenotype[gene_idx] = int((individual[0][gene_idx] + individual[1][gene_idx]) >= 2) 
        template = map(xor, enviroment, phenotype)
        # Fitness jedince: xor vsech genu, 0 - spravne; 1 - spatne. sumujeme spatne geny -> potreba invertovat
        individual[2] = CHROM_LENGTH - sum(map(xor, ones, phenotype))
    return population

def mutation(chromosome):
    global MUTATION_PROBABILITY
    global CHROM_LENGTH
    for i in xrange(CHROM_LENGTH):
        if random.random() < MUTATION_PROBABILITY:
            rnd = random.randint(0,2)
            while chromosome[i] == rnd:
                rnd = random.randint(0,2)
            chromosome[i] = rnd

       
def reproduce(mother, father):
    global CROSSOVER_PROBABILITY
    global MUTATION_PROBABILITY
    global CHROM_LENGTH
    
    m = random.randint(0,1)
    f = random.randint(0,1)
    kid_a = [list(mother[m]), [], 0]
    kid_b = [list(father[f]), [], 0]
    m = 0 if m else 1
    f = 0 if f else 1

    rnd = random.random()
    if rnd < CROSSOVER_PROBABILITY/2:
        rnd_idx_a = random.randint(1,CHROM_LENGTH-1)
        rnd_idx_b = random.randint(1,CHROM_LENGTH-1)
        while rnd_idx_a == rnd_idx_b:
            rnd_idx_b = random.randint(1,CHROM_LENGTH-1)
        # Swap values
        if rnd_idx_a > rnd_idx_b: 
            rnd_idx_a, rnd_idx_b = rnd_idx_b, rnd_idx_a
        kid_a[1] = list(mother[m][:rnd_idx_a] + father[f][rnd_idx_a:rnd_idx_b] + mother[m][rnd_idx_b:])
        kid_b[1] = list(father[f][:rnd_idx_a] + mother[m][rnd_idx_a:rnd_idx_b] + father[f][rnd_idx_b:])
    elif rnd < CROSSOVER_PROBABILITY:
        rnd_idx = random.randint(1,CHROM_LENGTH-1)
        kid_a[1] = list(mother[m][:rnd_idx] + father[f][rnd_idx:])
        kid_b[1] = list(father[f][:rnd_idx] + mother[m][rnd_idx:])
    else:
        kid_a[1] = list(father[f])
        kid_b[1] = list(mother[m])

    # Mutace chromozomu
    mutation(kid_a[0])
    mutation(kid_a[1])
    mutation(kid_b[0])
    mutation(kid_b[1])

    return [kid_a, kid_b]
     

def run(max_generation, population_cnt, mating_pool):
    """
    @param max_generation The number of iteration when appocalpse happens.
    @param population_cnt Size of population; count of individuals.
    @param mating_pool Size of mating pool; sex happens there between some individuals.
    """
    global ENVIROMENT_CHANGE
    global CHROM_LENGTH # max fitness
    MAX_FITNESS = CHROM_LENGTH
    if (mating_pool % 2) == 1 or (population_cnt % 2) == 1: # or population_cnt < mating_pool: 
        print "Bad params"
        return

    get_fitness = lambda tmp : tmp[2]

    sex_count = mating_pool / 2
    population = initPop(population_cnt)
    evalPop(population)
    population = sorted(population,reverse=True, key=itemgetter(2))
    print "Init fitness: " + str(population[0][2])

    avg_fit = [[] for _ in xrange(ENVIROMENT_CHANGE)]
    prev_fit = [0]*population_cnt
    for generation in xrange(max_generation):
        # Reprodukce
        newpopulation = population
        for j in xrange(sex_count):
            """
            #random
            a = random.randint(0,population_cnt-1)
            b = random.randint(0,population_cnt-1)
            while a == b: # Zakazeme seberprodukci hermafroditu..
                b = random.randint(0,population_cnt-1)
            """
            # Styl vyberu rodicu: tournament
            # vybereme dva jedince `tmp` a urcime podle fitness rodice.
            tmp = random.sample(population, 2)
            parent_a = tmp[0] if tmp[0][2] > tmp[1][2] else tmp[1]
            tmp = random.sample(population, 2)
            parent_b = tmp[0] if tmp[0][2] > tmp[1][2] else tmp[1]
            # zakazeme hermafrodity
            if parent_a == parent_b:  
                a = random.randint(0,len(population)-1)
                b = random.randint(0,len(population)-1)
                while a == b: b = random.randint(0,len(population)-1)
                parent_a = population[a] if population[a][1] > population[b][1] else population[1] 
                a = random.randint(0,len(population)-1)
                b = random.randint(0,len(population)-1)
                while a == b: b = random.randint(0,len(population)-1)
                parent_b = population[a] if population[a][1] > population[b][1] else population[1] 
            # zreprodukujeme jedince a ohodnotime fitness
            offsprings = evalPop(reproduce(parent_a, parent_b))
            newpopulation = newpopulation + evalPop(reproduce(parent_a, parent_b))
        population = newpopulation
        # Po uplynuti 10 generaci nastane valka a prostredi se zmeni -> budeme potrebovat nove ohodnoceni populace
        if (generation % ENVIROMENT_CHANGE) == 0:
            population = sorted(population, reverse=True, key=itemgetter(2))
            for i in xrange(population_cnt):
                prev_fit[i] = population[i][2]
            enviromentChange()
            evalPop(population)
            for i in xrange(population_cnt):
                if (population[i][2] - prev_fit[i])/float(MAX_FITNESS) < 0.2:
                    for j in xrange(CHROM_LENGTH):
                        population[i][0][j] = (population[i][0][j] - 1) % 3 
                        population[i][1][j] = (population[i][1][j] - 1) % 3 


            population = sorted(population, reverse=True, key=itemgetter(2))
            print "BestFitness: "+str(prev_fit[0])+" -> "+str(population[0][2])
        
        # Kdo prezije v dalsi generaci?
        # Half tournament: polovina nejlepsich a polovina si zahraje turnaj. 
        half = population_cnt/2
        population = sorted(population,reverse=True, key=itemgetter(2))
        avg_fit[generation % ENVIROMENT_CHANGE].append(deepcopy(population[0][2]))
        new_population = population[:half] 
        for j in xrange(half): # melo by to byt i pro lichy pocet...
            a = random.randint(0, half + mating_pool - 1)
            b = random.randint(0, half + mating_pool - 1)
            if population[half:][a][2] > population[half:][b][2]:
                new_population += [population[half:][a]]
            else:
                new_population += [population[half:][b]]
        population = new_population
    idx = 0
    for i in avg_fit:
        idx += 1
        print "Env "+str(idx) + " avg fit: "+str(sum(i)/len(i))
        #exit()
        #idx += 1 
        #print str(idx) + ": " + str(sum(i)/len(i))


if __name__ == "__main__":
    run(2000, 10, 10)
    print "Hello world!"
 