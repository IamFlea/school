package sfcga;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

/**
 *
 * @author Flea
 */
public class Chromosome {
    public List<Integer> chrom;    // Using permutation encoding for TSP.
    public List<Double> chromReal; // Using real encoding for NN weights. 
    public double fitness; // Fitness of chromosome.
    
    private static int MAX_VALUE = 10000;
    /**
     * Init chromosomes
     */
    public Chromosome() {
        chrom = new ArrayList<>();
        chromReal = new ArrayList<>();
        fitness = 0;
    }
    
    /**
     * Clone chromosome into new allocated memory.
     * @return Chromosome
     */
    public Chromosome copy(){
        Chromosome result = new Chromosome();
        for(int i : this.chrom){
            result.chrom.add(i);
        }
        for(Double i : this.chromReal){
            result.chromReal.add(i);
        }
        result.fitness = this.fitness;
        return result;
    }
    
    /**
     * Mutate gene in chromosome, which is defined as permutation.
     */
    public void mutateSwap(){
        // Nahraj indexy ktere se swapnou
        int indexA = SfcGA.rand.nextInt(chrom.size());
        int indexB = SfcGA.rand.nextInt(chrom.size());
        while(indexA == indexB){
            indexB = SfcGA.rand.nextInt(chrom.size());
        }
        int val = chrom.get(indexA);
        chrom.set(indexA, chrom.get(indexB));
        chrom.set(indexB, val);
    }
    
    public Chromosome crossover(Chromosome another, int countOfPointsOfCrossover){
        Chromosome result = new Chromosome();
        boolean[] skip = new boolean[Chromosome.MAX_VALUE];
        List<Integer> fromParentA = new ArrayList<>();
        List<Integer> fromParentB = new ArrayList<>();
         
        // Vytvorim body krizeni kde se chromozomy budou krizit a seradim pole
        int[] pointsOfCrossover = new int[countOfPointsOfCrossover+1]; // bod navic
        for(int i = 0; i < countOfPointsOfCrossover; i++){
           pointsOfCrossover[i] = SfcGA.rand.nextInt(chrom.size());
        }
        pointsOfCrossover[countOfPointsOfCrossover] = -1; // Zarazka pro pointsOfXover[idx] == i, bo pak dojde k overflow
        Arrays.sort(pointsOfCrossover); 
        
        // Klasicke krizeni, zamenim usek jinym usekem.
        int idx = 0;
        int swap = 0;

        for(int i = 0; i < chrom.size(); i++) {
            if(pointsOfCrossover[idx] == i){
                idx++;
                swap++;
            }
            if((swap % 2) == 0){
                result.chrom.add(chrom.get(i));
                fromParentA.add(chrom.get(i));
                fromParentB.add(another.chrom.get(i));
            } else {
                result.chrom.add(another.chrom.get(i));
            }
        }
        
        // Ovsem pro chromozom reprezentovany permutaci je tato situace 
        // neprijemna. Krizenim dvou jedincu nemusime dostat znova permutaci.
        // Z tohoto duvodu jsem zavedl dve pomocna pole 'fromParentX', ktera
        // nam rikaji, ktere useky chromozomu byly pouzity pri krizeni.
        // Symetrickou diferenci pak ziskam geny, ktere je potreba zmenit.
        // Symetricka diferenece je definovana jako: (A U B) / (A prunik B)
        List<Integer> add = new ArrayList<>();
        List<Integer> remove = new ArrayList<>();
        for(int i = 0; i < fromParentA.size(); i++){
            if(-1 == fromParentB.indexOf(fromParentA.get(i))) // nebyl-li nalezen tak ho z decka odeber
                remove.add(fromParentA.get(i));              
        }                                                     
        for(int i = 0; i < fromParentB.size(); i++){
            if(-1 == fromParentA.indexOf(fromParentB.get(i))) // nebyl-li nalezen tak ho pak do decka pridej 
                add.add(fromParentB.get(i));
        }
        
        idx = 0;
        swap = 0;
        int idxForAdd = 0;
        for(int i = 0; i < chrom.size(); i++) {
            if(pointsOfCrossover[idx] == i){
                idx++;
                swap++;
            }
            if((swap % 2) != 0){
                for(int item : remove){
                    if(item == result.chrom.get(i)){
                        result.chrom.set(i, add.get(idxForAdd));
                        idxForAdd++;
                    }
                }
            }
        }
               
        return result;
    }

    public void mutationForReal(double deviation){
        for(int i = 0; i < chromReal.size(); i++){
            double rand = SfcGA.rand.nextGaussian() * deviation;
            chromReal.set(i, chromReal.get(i) + rand);
        }
    }
    
    public Chromosome crossoverAvg(Chromosome another){
        if(chromReal.size() != another.chromReal.size()){
            System.err.println("HAPALA");
            System.exit(0);
        }
        Double avg;
        Chromosome result = new Chromosome();
        for(int i = 0; i < chromReal.size(); i++){
            avg = (chromReal.get(i) + another.chromReal.get(i))/2;
            result.chromReal.add(avg);
        }
        return result;
    }
    
    
    public Chromosome crossoverDiscrete(Chromosome another){
        if(chromReal.size() != another.chromReal.size()){
            System.err.println("HAPALA");
            System.exit(0);
        }
        Chromosome result = new Chromosome();
        for(int i = 0; i < chromReal.size(); i++){
            if((SfcGA.rand.nextInt() % 2) == 0){
                result.chromReal.add(chromReal.get(i));
            } else {
                result.chromReal.add(another.chromReal.get(i));
            }
        }
        return result;
    }
    
    public String str(){
        String result = "";
        for (int i : chrom){
            result += i+" ";
        }
        return result;
    }
    
    public String strReal(){
        String result = "";
        for (double i : chromReal){
            result += i+" ";
        }
        return result;
    }
}



interface CrossoverType {
    String name();
    public Chromosome exec(Chromosome a, Chromosome b);    
};
class XoverAvg implements CrossoverType {
    @Override
    public String name() {
        return "Krizeni prumerem";
    }
    @Override
    public Chromosome exec(Chromosome chrom_a, Chromosome chrom_b) {
        return chrom_a.crossoverAvg(chrom_b);
    }
};
class XoverDet implements CrossoverType {
    @Override
    public String name() {
        return "Krizeni vyberem";
    }
    @Override
    public Chromosome exec(Chromosome chrom_a, Chromosome chrom_b) {
        return chrom_a.crossoverDiscrete(chrom_b);
    }
};