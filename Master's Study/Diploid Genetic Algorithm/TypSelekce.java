package diploidga;

import java.util.List;


interface TypSelekce {
    String name();
    public Chromosome exec(List<Chromosome> pop);
};
 
/** Implements the algorithm using the strategy interface */
class Turnaj implements TypSelekce {
    public String name(){
        return "Turnaj";
    }
    public Chromosome exec(List<Chromosome> pop) {
        int a = MainForm.rand.nextInt(pop.size());
        int b = MainForm.rand.nextInt(pop.size());
        while(a == b) {
            b = MainForm.rand.nextInt(pop.size());
        }
        
        if(pop.get(a).fitness < pop.get(b).fitness){
            return pop.get(b).copy();
        } else{
            return pop.get(a).copy();
        }
    }
};
  
class Ruleta implements TypSelekce {
    public String name(){
        return "Ruleta";
    }
    public Chromosome exec(List<Chromosome> pop) {
        int sum = 0;
        for(int i = 0; i < pop.size(); i++) {
            sum += pop.get(i).fitness;
        }
        int rand = MainForm.rand.nextInt(sum);
        int i;
        for(i = 0; i < pop.size(); i++) {
            rand -= pop.get(i).fitness;
            if(rand < 0){
                break;
            }
        }
        return pop.get(i).copy();
    }
};

class Nahoda implements TypSelekce {
    public String name(){
        return "Nahoda";
    }
    public Chromosome exec(List<Chromosome> pop) {
        return pop.get(MainForm.rand.nextInt(pop.size()));
    }
}

class Deterministic implements TypSelekce {
    public String name(){
        return "Determ.";
    }
    int idx = -1;
    public Chromosome exec(List<Chromosome> pop) {
        for(int i = 0; i < pop.size(); i++){
            int tmp = i;
            for(int j = i; j < pop.size(); j++){
                if(pop.get(tmp).fitness < pop.get(j).fitness){
                    tmp = j;
                } 
            }
            Chromosome chrom = pop.get(tmp);
            pop.set(tmp, pop.get(i));
            pop.set(i, chrom);
        }
        idx++;
        if(idx == MainForm.population){
            idx = 0;
        }
        return pop.get(idx);
    }
    
}