# PROJEKT 
# Autor: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
# Datum: 21. prosinec
# Soubor: proj.py  
# 
# Popis
# Napiste v Pythonu program, ktery vykona grafove shlukovani aminokyselin v
# proteinu podle sady volitelnych parametru (vzdalenost, chemicka pribuznost,
# vzdalenost od zvoleneho bodu) a vysledky zapise do PDB souboru, kde kazdy
# shluk bude tvorit vlastni skupinu (chain). Pomoci  programu a systemu Pymol
# vytvorte zajimavou vizualizaci Vami zvoleneho proteinu.

import sys
from math import sqrt
global sidechain_table, sidechain_index, sidechain_stats
# Chemical distance of each aminoacid parsed pages www.biochem.ucl.ac.uk/bsm/sidechains/ via script Novy1.py  Forgive me I was too lazy to rename file :)
#                    ALA   ARG   ASN   ASP   CYS   GLN   GLU   GLY   HIS   ILE   LEU   LYS   MET   PHE   PRO   SER   THR   TRP   TYR   VAL
sidechain_table = [[1834, 1001,  720,  712,  352,  635,  730, 1041,  505, 2617, 3880,  681,  866, 1985,  769,  827, 1187,  787, 1479, 2955], # ALA - Alanine
                   [1000, 1072,  898, 1993,  247,  799, 2183, 1036,  547, 1192, 1851,  563,  456, 1025,  798,  839, 1027,  556, 1287, 1274], # ARG - Arginine
                   [ 720,  900,  879,  878,  181,  642,  773,  881,  399,  758, 1083,  722,  349,  715,  555,  743,  918,  391,  874,  833], # ASN - Asparagine
                   [ 711, 1999,  880,  670,  185,  662,  500,  905,  743,  740, 1085, 1845,  301,  665,  522,  965, 1036,  426, 1090,  849], # ASP - Aspartate
                   [ 352,  247,  182,  185, 1252,  158,  144,  301,  172,  557,  845,  139,  233,  535,  236,  231,  265,  175,  384,  620], # CYS - Cysteine
                   [ 634,  800,  638,  661,  158,  551,  649,  647,  294,  787, 1327,  709,  344,  702,  521,  596,  774,  396,  789,  880], # GLN - Glutamine
                   [ 726, 2187,  766,  498,  144,  651,  514,  685,  610,  973, 1403, 2070,  380,  787,  610,  828, 1058,  421, 1060,  993], # GLU - Glutamate
                   [1041, 1039,  881,  906,  302,  648,  685,  828,  392, 1236, 1793,  736,  532, 1109,  636,  861, 1074,  558, 1115, 1356], # GLY - Glycine 
                   [ 505,  547,  400,  744,  172,  296,  612,  392,  550,  628,  970,  331,  307,  651,  384,  460,  582,  312,  705,  714], # HIS - Histidine
                   [2617, 1196,  757,  739,  557,  787,  976, 1236,  628, 4849, 6579,  935, 1359, 3065, 1016,  914, 1577, 1050, 2122, 4494], # ILE - Isoleucine
                   [3880, 1857, 1082, 1086,  844, 1331, 1410, 1792,  970, 6579,10732, 1452, 2127, 4973, 1594, 1424, 2111, 1672, 3145, 6664], # LEU - Leucine
                   [ 669,  562,  716, 1813,  138,  693, 2053,  727,  328,  923, 1439,  432,  362,  803,  439,  658,  839,  418, 1121, 1086], # LYS - Lysine
                   [ 865,  456,  347,  301,  233,  344,  384,  532,  306, 1357, 2128,  365,  584, 1186,  450,  383,  517,  432,  846, 1391], # MET - Methonine
                   [1985, 1028,  715,  665,  535,  702,  790, 1109,  651, 3065, 4975,  816, 1188, 2924, 1026,  895, 1189,  948, 1851, 3247], # PHE - Phenylalanine
                   [ 769,  801,  555,  522,  236,  522,  613,  636,  384, 1017, 1594,  447,  450, 1026,  584,  590,  702,  631, 1177, 1233], # PRO - Proline
                   [ 827,  840,  741,  963,  231,  596,  830,  861,  460,  913, 1422,  667,  383,  895,  589,  766,  944,  410,  918, 1056], # SER - Serine
                   [1187, 1032,  918, 1037,  265,  774, 1061, 1074,  582, 1577, 2110,  850,  518, 1189,  702,  945, 1244,  536, 1093, 1709], # THR - Threonine
                   [ 787,  557,  391,  425,  175,  396,  422,  558,  312, 1050, 1672,  423,  432,  948,  631,  410,  536,  484,  779, 1082], # TRP - Tryptophan
                   [1478, 1297,  875, 1093,  384,  791, 1062, 1115,  705, 2122, 3146, 1138,  848, 1850, 1177,  917, 1093,  779, 1558, 2111], # TYR - Tyrosine
                   [2955, 1280,  833,  851,  619,  881,  998, 1356,  713, 4496, 6665, 1101, 1392, 3247, 1233, 1056, 1709, 1082, 2111, 5162]] # VAL - Valine
sidechain_index = ["ALA","ARG","ASN","ASP","CYS","GLN","GLU","GLY","HIS","ILE","LEU","LYS","MET","PHE","PRO","SER","THR","TRP","TYR","VAL"]
sidechain_stats = sorted(reduce(lambda x, y : x + y, sidechain_table)) 
for row_idx in xrange(len(sidechain_table)):
    for col_idx in xrange(len(sidechain_table)):
        value = sidechain_table[row_idx][col_idx]
        index = sidechain_stats.index(value)
        if index <= len(sidechain_stats)/2: # lesser than magical median?
            value = 4 - index/200.0 * 3
        else:
            value = float(index-200)/400.0 +0.5 # int part avoids error in interpretation
        sidechain_table[row_idx][col_idx] = value

# Uses global values which are inicialized once! Code should be optimized.
def get_chemical_distance(ac_a, ac_b):
    """
    ac_a name of aminoacid
    ac_b name of aminoacid
    return weight, lesser weight -> acs are more likelz to be in pair.
    Calucalte the weight between two aminoacids.
    """
    row_idx = sidechain_index.index(ac_a)
    col_idx = sidechain_index.index(ac_b)
    return sidechain_table[row_idx][col_idx]
        



class ExceptionNotAtom(Exception):
    pass

def split_atom(string):
    if string[0:6] != "ATOM  " and string[0:6] != "HETATM" :
        raise ExceptionNotAtom("Not an atom!")
    atom_serial_number = int(string[6:11])
    atom_name = string[12:16]
    alt_location = string[16]
    residue_name = string[17:20]
    chain_id = string[21]
    residue_seq_number = int(string[22:26])
    code_insertion_residue = string[26]
    coord_x = float(string[30:38])
    coord_y = float(string[38:46])
    coord_z = float(string[46:54])
    occupancy = float(string[54:60])
    temperature_factor = float(string[60:66])
    segment_id = string[72:76]
    element_symbol = string[76:78]
    charge = string[78:80]
    return [string[0:6], atom_serial_number, atom_name, alt_location, residue_name, chain_id, 
            residue_seq_number, code_insertion_residue, coord_x, coord_y, coord_z, 
            occupancy, temperature_factor, segment_id, element_symbol, charge]



    
def print_help():
    print "SYNOPSIS"
    print "  python2 mol_cluster.py filename [-f filename] [-p double double double] [-k int] [-l double] [-tq] [-e double]"
    print
    print "DESCRIPTION"
    print "  filename"
    print "     PDB data file."
    print "  -p double double double"
    print "     Point coords in format x y z."
    print "  -l double"
    print "     Distance between aminoacid molecules."
    print "  -k int"
    print "     Density used in DBSCAN clustering"
    print "  -m int"
    print "     Minimal points in cluster to be a cluster"
    print "  -t"
    print "     Include chemical table"
    print "  -e double"
    print "     Distance tolerance of neighbour aminoacids in the chain. "
    print "  -f filename"
    print "     Output filename. Print into out_clusters.pdb if not any"
    print "  -q"
    print "     Quiet mode. Do not print info about clusters."


"""
Main function
"""
def main():
    # Print help if there are few arguments
    if len(sys.argv) < 2:
        print_help()
        return
    use_table = False
    point_distance = False
    point_idx = 3
    point = [0.0,0.0,0.0]
    eps_tolerance = 0.0
    default_value = 10.0
    density = 0
    min_points = 10
    state = 0
    printinfo = True
    out_fname = "output.pdb"
    try:
        for i in sys.argv[1:]:
            if point_idx < 3: # 3 or more -> not loading point 
                point[point_idx] = float(i)
                point_idx += 1
                point_distance = True
            elif state == 1:
                default_value = float(i)
                state = 0
            elif state == 2:
                eps_tolerance = float(i)
                state = 0
            elif state == 3:
                density = int(i) 
                state = 0
            elif state == 4:
                min_points = int(i)
                state = 0
            elif state == 5:
                out_fname = i
                state = 0
            elif i == "-p":
                point_idx = 0
            elif i == "-t":
                use_table = True
            elif i == "-k":
                state = 3
            elif i == "-e":
                state = 2
            elif i == "-l":
                state = 1
            elif i == "-m":
                state = 4
            elif i == "-f":
                state = 5
            elif i == "-q":
                printinfo = False
    except: 
        print_help()
        return
    if point_idx != 3 or state != 0:
        print_help()
        return



    # Get all atoms
    atoms = []
    real_id = 1
    f = open(sys.argv[1])
    for line in f:
        # Nahrajeme atom po atomu
        try:
            atom_info = split_atom(line)
            atom = [real_id,  atom_info[6], atom_info[4], atom_info[8], atom_info[9], atom_info[10], line]
            atoms.append(atom)
            real_id += 1
        except ExceptionNotAtom:
            continue
        except: 
            sys.stderr.write("Bad pdb fileformat!\n")
            return
    f.close()

    # Create aminoacid molecule from atoms.
    mols = []
    mol = []
    seq_id = atoms[0][1]
    for atom in atoms:
        if atom[1] == seq_id:
            mol.append(atom)
        else:
            if len(mol) != 0:
                mols.append(mol)
            mol = []
            seq_id = atom[1]
    
    # I will take an avarage position from each atom in aminoacid. 
    for mol in mols:
        sum_x = 0
        sum_y = 0
        sum_z = 0
        name = mol[0][2]
        for atom in mol:
            sum_x += atom[3]
            sum_y += atom[4]
            sum_z += atom[5]
        avg_x = sum_x / len(mol)
        avg_y = sum_y / len(mol)
        avg_z = sum_z / len(mol)
        mol.append([avg_x, avg_y, avg_z, name])

    # I will calucalte a distance matrix
    matrix = []
    for mol_a_idx in xrange(len(mols)):
        row = []
        for mol_b_idx in xrange(len(mols)):
            if mol_a_idx <= mol_b_idx:
                continue
            distance = 0.0
            distance += (mols[mol_a_idx][-1][0] - mols[mol_b_idx][-1][0])**2
            distance += (mols[mol_a_idx][-1][1] - mols[mol_b_idx][-1][1])**2
            distance += (mols[mol_a_idx][-1][2] - mols[mol_b_idx][-1][2])**2
            if point_distance:
                distance += (mols[mol_a_idx][-1][0] - point[0])**2
                distance += (mols[mol_a_idx][-1][1] - point[1])**2
                distance += (mols[mol_a_idx][-1][2] - point[2])**2
                distance += (mols[mol_b_idx][-1][0] - point[0])**2
                distance += (mols[mol_b_idx][-1][1] - point[1])**2
                distance += (mols[mol_b_idx][-1][2] - point[2])**2
            if use_table: 
                name_a = mols[mol_a_idx][-1][3]
                name_b = mols[mol_b_idx][-1][3]
                distance *= get_chemical_distance(name_a, name_b)
            distance = sqrt(distance)
            row.append(distance)
        matrix.append(row)
    # DEFAULT Weight the neighbour molecules
    for row in matrix:
        # Back iterate
        previous_distance = 0.0
        for i in xrange(len(row)-1, -1, -1):
            if row[i] < (previous_distance - eps_tolerance):
                break
            else:
                previous_distance = row[i]
                row[i] = default_value    
    # Dopnit celou tabulku

    idx = 0
    for row in matrix:
        for row_tmp in matrix[idx+1:]:
            row.append(row_tmp[idx])
        row.insert(idx, default_value)
        idx += 1

    # Punk code ted jsem zjistil, ze vzdalenostni matici nepotrebuju ale co tak kdyz uz to mam predpocitane.. 
    for mol in mols:
        mol[-1].append(False) # Visted mol
        mol[-1].append(-1) # Cluster nepatri nikomu


    def region_query(mol_idx, distance):
        result = []
        for idx in xrange(len(mols)):
            if matrix[mol_idx][idx] < distance:
                result.append(idx)
        return result


    def nasty(q, mols, default_value, cluster, density):
        for neighbour_idx in q:
            if mols[neighbour_idx][-1][-1] == -1:
                mols[neighbour_idx][-1][-1] = cluster
            if not mols[neighbour_idx][-1][-2]: 
                mols[neighbour_idx][-1][-2] = True
                l = region_query(neighbour_idx, default_value)
                if len(l) >= density:
                    nasty(l, mols, default_value, cluster, density)

    # DBSCAN
    cluster = 1
    k = []
    for idx in xrange(len(mols)): 
        if mols[idx][-1][-2]: # Visited dude
            continue
        mols[idx][-1][-2] = True # Mark as visited
        q = region_query(idx, default_value) # sousediii
        if len(q) < density: # nejedna se o sum?
            mols[idx][-1][-1] = 0   # -> je to sum
        else:
            mols[idx][-1][-1] = cluster # je to v clusteru
            for nidx in q:
                if not mols[nidx][-1][-2]:
                    mols[nidx][-1][-2] = True
                    l = region_query(nidx, default_value)
                    if len(l) >= density:
                        q = q + l
                if mols[nidx][-1][-1] == -1:
                    mols[nidx][-1][-1] = cluster
            cluster += 1

    skipped = []
    for i in xrange(cluster):
        cnt = 0
        idx = 0
        # Spocitam pocet jednotek v danem clusteru
        for mol in mols:
            idx += 1
            if mol[-1][-1] == i:
                cnt += 1
        # POkud jich ma min, tak se jedna o sum
        if cnt < min_points:
            skipped.append(i)
            for mol in mols:
                if mol[-1][-1] == i:
                    mol[-1][-1] = 0
    
    string = ""
    c = 0
    for i in xrange(cluster):
        cnt = 0
        idx = 0
        for mol in mols:
            idx += 1
            if mol[-1][-1] == i:
                cnt += 1
        if i == 0:
            string += "Noise aminoacids: "+str(cnt) + "\n"
        elif cnt != 0:
            string += "Cluster "+str(i)+": "+str(cnt) + "\n"
            c+=1

    if printinfo:
        sys.stderr.write("Clusters found: "+ str(c)+"\n")
        sys.stderr.write(string)
    

    cluster_char = map(lambda x: chr(x), range(ord('A'), ord('z')))
    used = []
    max_clusters = len(cluster_char)
    if c > max_clusters:
        sys.stderr.write("Error! Too many clusters were found!!\n")
        return

    cluster_Stringing = ""
    result = ""
    cnt = 0
    f = open(out_fname, 'w')
    for mol in mols:
        cluster = mol[-1][-1]
        try:
            idx_cluster_char = used.index(cluster) 
        except:
            idx_cluster_char = len(used)
            used.append(cluster)
        char = cluster_char[idx_cluster_char]
        cluster_Stringing += char

        for atom in mol[:-1]:
            cnt+=1
            atomid = str(cnt).rjust(5)
            line = atom[-1][:21] +char+  atom[-1][22:]
            result_line = line[:6] + atomid+ line[11:]
            f.write(result_line)
    f.write("END\n")
    
        

    if printinfo:
        print "Clusters:"
        print cluster_Stringing



        








    """          

        DBSCAN(D, eps, MinPts)
   C = 0
   for each unvisited point P in dataset D
      mark P as visited
      NeighborPts = regionQuery(P, eps)
      if sizeof(NeighborPts) < MinPts
         mark P as NOISE
      else
         C = next cluster
         expandCluster(P, NeighborPts, C, eps, MinPts)

expandCluster(P, NeighborPts, C, eps, MinPts)
   add P to cluster C
   for each point P' in NeighborPts 
      if P' is not visited
         mark P' as visited
         NeighborPts' = regionQuery(P', eps)
         if sizeof(NeighborPts') >= MinPts
            NeighborPts = NeighborPts joined with NeighborPts'
      if P' is not yet member of any cluster
         add P' to cluster C
          
regionQuery(P, eps)
   return all points within P's eps-neighborhood (including P)
    """
    




if __name__ == '__main__':
    main()

