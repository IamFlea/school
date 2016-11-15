package sfcga;

import java.util.List;


interface SelectionType {
    String name();
    public Chromosome exec(List<Chromosome> pop);
};
 
/** Implements the algorithm using the strategy interface */
class Tournament implements SelectionType {
    public String name(){
        return "Turnaj";
    }
    public Chromosome exec(List<Chromosome> pop) {
        int a = SfcGA.rand.nextInt(pop.size());
        int b = SfcGA.rand.nextInt(pop.size());
        while(a == b) {
            b = SfcGA.rand.nextInt(pop.size());
        }
        
        if(pop.get(a).fitness > pop.get(b).fitness){
            return pop.get(b).copy();
        } else{
            return pop.get(a).copy();
        }
    }
};
  
class Roulette implements SelectionType {
    public String name(){
        return "Ruleta";
    }
    public Chromosome exec(List<Chromosome> pop) {
        int sum = 0;
        for(int i = 0; i < pop.size(); i++) {
            sum += pop.get(i).fitness;
            //System.err.print(i);
            //System.err.print(" -> ");
            //System.err.println(pop.get(i).fitness);
        }
        int rand = SfcGA.rand.nextInt(sum);
        int i;
        //System.err.println("===");
        //System.err.print("rand ");
            System.err.println(rand);
        for(i = 0; i < pop.size(); i++) {
            rand -= (pop.get(i).fitness);
            if(rand < 0){
                break;
            }
        }
        //System.err.println(i);
        
        return pop.get(i).copy();
    }
};

class Nahoda implements SelectionType {
    public String name(){
        return "Nahoda";
    }
    public Chromosome exec(List<Chromosome> pop) {
        return pop.get(SfcGA.rand.nextInt(pop.size()));
    }
}

class Deterministic implements SelectionType {
    public String name(){
        return "Determ.";
    }
    int idx = -1;
    public Chromosome exec(List<Chromosome> pop) {
        for(int i = 0; i < pop.size(); i++){
            int tmp = i;
            for(int j = i; j < pop.size(); j++){
                if(pop.get(tmp).fitness > pop.get(j).fitness){
                    tmp = j;
                } 
            }
            Chromosome chrom = pop.get(tmp);
            pop.set(tmp, pop.get(i));
            pop.set(i, chrom);
        }
        idx++;
        if(idx == (SfcGA.popsize)){
            idx = 0;
        }
        return pop.get(idx);
    }
    
}