package diploidga;

import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Flea
 */
public class Chromosome implements Comparable<Chromosome>{
    public List<Integer> strand_a;
    public List<Integer> strand_b;
    public int fitness;

    public Chromosome() {
        strand_a = new ArrayList<>();
        strand_b = new ArrayList<>();
        fitness = 0;
        init();
    }
    
    public Chromosome copy(){
        Chromosome result = new Chromosome();
        result.strand_a.clear();
        result.strand_b.clear();
        for(int i : this.strand_a){
            result.strand_a.add(i);
        }
        for(int i : this.strand_b){
            result.strand_b.add(i);
        }
        result.fitness = this.fitness;
        return result;
    }
    public void init(){
        for(int j = 0; j < MainForm.chromosomeLength; j++){
            this.strand_a.add(MainForm.rand.nextInt(MainForm.cardinality));
            this.strand_b.add(MainForm.rand.nextInt(MainForm.cardinality));
        }
    }
    
    public void mutate(List<Integer> strand){
        for(int i = 0; i < strand.size(); i++){
            if(MainForm.rand.nextDouble() < MainForm.probabilityMutation) {
                int last_gene = strand.get(i);
                int rand = MainForm.rand.nextInt(MainForm.cardinality);
                while(rand == last_gene){
                    rand = MainForm.rand.nextInt(MainForm.cardinality);
                }
                strand.set(i, rand);
            }
        }
    }
    
    public void mutate(){
        mutate(strand_a);
        mutate(strand_b);
    }
    
    public void mutateJustOneStrand(){
        mutate(strand_a);
    }
    
    public Chromosome crossover(List<Integer> strand_b){
        //result.add(new ArrayList<>());
        //new ArrayList<>()};
        Chromosome result = new Chromosome();
        result.strand_a.clear();
        result.strand_b.clear();
        double rand = MainForm.rand.nextDouble();
        if(rand < MainForm.probabilityCrossover){
            double interval = MainForm.probabilityCrossover/ ((double) MainForm.crossoverPoints);
            int pocet_krizeni = 0; // pocet krizeni na chromozom
            while(rand >= 0.0) {
                rand -= interval;
                pocet_krizeni += 1;
            }
            
            // vytvorim body krizeni
            int[] body_krizeni = new int[pocet_krizeni+1];
            for(int i = 0; i < pocet_krizeni; i++){
                body_krizeni[i] = MainForm.rand.nextInt(MainForm.chromosomeLength-2) +1;
            }
            body_krizeni[pocet_krizeni] = MainForm.chromosomeLength+2;
            java.util.Arrays.sort(body_krizeni);
            
            int idx = 0;
            int swap = 0;
            for(int i = 0; i < MainForm.chromosomeLength; i++) {
                if(body_krizeni[idx] == i){
                    idx++;
                    swap++;
                }
                if((swap % 2) == 0){
                    result.strand_a.add(strand_a.get(i));
                    result.strand_b.add(strand_b.get(i));
                } else {
                    result.strand_a.add(strand_b.get(i));
                    result.strand_b.add(strand_a.get(i));
                }
            }
        } else {
            for(int i = 0; i < MainForm.chromosomeLength; i++) {
                result.strand_a.add(strand_b.get(i));
                result.strand_b.add(strand_a.get(i));
            }
        }
        return result;
    }
    public Chromosome crossover(){
        return crossover(strand_b);
    }

    @Override
    public int compareTo(Chromosome t) {
        if(this.fitness < t.fitness){
            return -1;
        }else if(this.fitness == t.fitness){
            return 0;
        }else {
            return 1;
        }
    }
    
}
