package diploidga;

/**
 *
 * @author Flea
 */
public class GA extends DGA { //haha
    public GA(SendMsg tmp) {
        super(tmp);
        name = "GA :: "
                + "Pop: "+ MainForm.population+". Výběr pop: "+ MainForm.selectTypePopulation.name()+". "
                + "Dětí "+ MainForm.offsprings+". Výběr rodičů: "+ MainForm.selectTypeParent.name()+". "
                + "Křížení "+(int)(MainForm.probabilityCrossover*100.0)+"% " + MainForm.crossoverPoints +"-bodové. "
                + "Mutace "+(int)(MainForm.probabilityMutation*100.0)+"%.";

    }
    @Override
    void reproduce(Chromosome mother,  Chromosome father){
        Chromosome kid_a = mother.copy().crossover(father.strand_a);
        Chromosome kid_b = new Chromosome();
        kid_b.strand_a = kid_a.strand_b;
        kid_a.mutate(kid_a.strand_a);
        kid_b.mutate(kid_b.strand_a);
        eval(kid_a);
        eval(kid_b);
        population.add(kid_a);
        population.add(kid_b);        
    }
    
    
    void eval(Chromosome individual){
        for(int i = 0; i < MainForm.chromosomeLength; i++){
            phenotype[i] = individual.strand_a.get(i);
            phenotype[i] ^= enviroment[i];
        }
        individual.fitness = MainForm.fitnessType.execute(this.phenotype);
    }
}
