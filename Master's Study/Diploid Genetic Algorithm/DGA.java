package diploidga;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Flea
 */
public class DGA extends Thread{
    String name;
    String problem;
    String subproblem;
    boolean DEBUG = true;
    List<Chromosome> population;
    int[] phenotype;
    int[] enviroment;
    int[] template;
    SendMsg sendMsg;
    DGA(SendMsg tmp){
        this.sendMsg = tmp;
        enviroment = new int[MainForm.chromosomeLength];
        phenotype = new int[MainForm.chromosomeLength];
        template = new int[MainForm.chromosomeLength];
        population = new ArrayList<>();
        for(int i = 0; i < MainForm.population; i++){
            population.add(new Chromosome());
        }
        evalParents();
        name = "DDGA-" + MainForm.cardinality +" :: "
                + "Pop: "+ MainForm.population+". Výběr pop: "+ MainForm.selectTypePopulation.name()+". "
                + "Dětí "+ MainForm.offsprings+". Výběr rodičů: "+ MainForm.selectTypeParent.name()+". "
                + "Křížení "+(int)(MainForm.probabilityCrossover*100.0)+"% " + MainForm.crossoverPoints +"-bodové. "
                + "Mutace "+(int)(MainForm.probabilityMutation*100.0)+"%.";
        problem = MainForm.fitnessType.name() + " "+ MainForm.chromosomeLength+" change["+MainForm.changeEnviromentGenerations+"]";
        subproblem = ((int)(MainForm.changeEnviromentProbability*100))+"%";
        
        if(MainForm.changeEnviromentType == 1){
            for(int i = 0; i < this.template.length; i++){
                this.template[i] ^= (MainForm.rand.nextDouble() < MainForm.changeEnviromentProbability) ? 1 : 0; // znegujeme
            }
        }
    }
    
    
    void eval(Chromosome individual){
        for(int i = 0; i < MainForm.chromosomeLength; i++){
            phenotype[i] = ((individual.strand_a.get(i) + individual.strand_b.get(i)) >= (MainForm.cardinality - 1)) ? 1 : 0;
            phenotype[i] ^= enviroment[i];
        }
        individual.fitness = MainForm.fitnessType.execute(this.phenotype);
        //System.err.println(str + " => "+individual.fitness);
        
    }
    
    void evalPop(){
        for(int i = 0; i < (MainForm.population + MainForm.offsprings); i++){
            eval(population.get(i));
        }
    }
    void evalParents(){
        for(int i = 0; i < (MainForm.population); i++){
            eval(population.get(i));
        }
    }
    void evalKids(){
        for(int i = MainForm.population; i < (MainForm.population + MainForm.offsprings); i++){
            eval(population.get(i));
        }
    }
    void changeEnviroment(){
        if(MainForm.changeEnviromentType == 0){
            for(int i = 0; i < this.enviroment.length; i++){
                this.enviroment[i] ^= (MainForm.rand.nextDouble() < MainForm.changeEnviromentProbability) ? 1 : 0; // znegujeme
            }
        }else{
            for(int i = 0; i < this.enviroment.length; i++){
                this.enviroment[i] ^= this.template[i];
            }
        }
    }
    void reproduce(Chromosome mother,  Chromosome father){
        Chromosome kid_a = mother.copy().crossover();
        Chromosome kid_b = father.copy().crossover();
        kid_a.mutate();
        kid_b.mutate();
        List<Integer> tmp = kid_a.strand_a;
        kid_a.strand_a = kid_b.strand_a;
        kid_b.strand_a = tmp;
        eval(kid_a);
        eval(kid_b);
        population.add(kid_a);
        population.add(kid_b);
    }
    int bestFitness(){
        int best = -1;
        for(Chromosome c : population){
            if(c.fitness > best){
                best = c.fitness;
            }
        }
        return best;
    }       
    int worstFitness(){
        int worst = Integer.MAX_VALUE;
        for(Chromosome c : population){
            if(c.fitness < worst){
                worst = c.fitness;
            }
        }
        return worst;
    }       
    int avgFitness(){
        double avg = 0.0;
        for(Chromosome c : population){
            avg += c.fitness;
        }
        return (int) (avg/((double)population.size()));
    }
    void sort(){
        for(int i = 0; i < population.size(); i++){
            int tmp = i;
            for(int j = i; j < population.size(); j++){
                if(this.population.get(tmp).fitness < this.population.get(j).fitness){
                    tmp = j;
                } 
            }
            Chromosome chrom = population.get(tmp);
            population.set(tmp, population.get(i));
            population.set(i, chrom);
        }
    }
    int[] min;
    int[] avg;
    int[] max;
    @Override
    public void run(){
        min = new int[MainForm.maxGenerations];
        avg = new int[MainForm.maxGenerations];
        max = new int[MainForm.maxGenerations];
        int start = (MainForm.strategy1plus1) ? MainForm.population : 0;
        for(int i = 0; i < MainForm.maxGenerations; i++){
            sendMsg.setBar((int) (((i+1)/(MainForm.maxGenerations+0.0))*100));
            for(int j = MainForm.population; j < (MainForm.population + MainForm.offsprings); j+=2){
                Chromosome parent_a = MainForm.selectTypeParent.exec(this.population);
                Chromosome parent_b = MainForm.selectTypeParent.exec(this.population);
                reproduce(parent_a, parent_b);
            }
            if((i%MainForm.changeEnviromentGenerations) == 0 ){
                int best = bestFitness();
                changeEnviroment();
                evalPop();
                print("Generation "+i+": "+best +"->"+bestFitness() + "");
            }
            List<Chromosome> newPopulation = new ArrayList<>();
            for(int j = 0; j < MainForm.population; j++){
                newPopulation.add(MainForm.selectTypePopulation.exec(population.subList(start, population.size())));
            }
            population = newPopulation;
            min[i] = worstFitness();
            avg[i] = avgFitness();
            max[i] = bestFitness();
        }
        sendMsg.plotMe(name, problem, subproblem, min, avg, max, MainForm.changeEnviromentGenerations);
    }
    
    
    
    
    void print(Object str){
        sendMsg.print(str.toString());
    }
    void print(){
        print("");
    }
}
