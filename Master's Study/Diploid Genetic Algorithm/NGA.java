package diploidga;

/**
 *
 * @author Flea
 */
public class NGA extends DGA{
    public NGA(SendMsg tmp) {
        super(tmp);
        name = "NDGA-" + MainForm.cardinality +" :: "
                + "Pop: "+ MainForm.population+". Výběr pop: "+ MainForm.selectTypePopulation.name()+". "
                + "Dětí "+ MainForm.offsprings+". Výběr rodičů: "+ MainForm.selectTypeParent.name()+". "
                + "Křížení "+(int)(MainForm.probabilityCrossover*100.0)+"% " + MainForm.crossoverPoints +"-bodové. "
                + "Mutace "+(int)(MainForm.probabilityMutation*100.0)+"%.";

    }
    // 0 1 2 3 4 5
    // o i 0 1 O I
    // kardinalita = 6
    // alela = gen/2 
    // hodnota = gen%2
    void eval(Chromosome individual){
        for(int i = 0; i < MainForm.chromosomeLength; i++){
            int alela_a = individual.strand_a.get(i)/2; 
            int alela_b = individual.strand_b.get(i)/2; 
            int gen_a = individual.strand_a.get(i)%2;
            int gen_b = individual.strand_b.get(i)%2;
            
            if(alela_a > alela_b){
                phenotype[i] = gen_a;
            } else if(alela_a < alela_b){
                phenotype[i] = gen_b;
            } else {
                if(gen_a == gen_b) { // && alela_a == alela_b
                    phenotype[i] = gen_a;
                } else {
                    phenotype[i] = MainForm.rand.nextInt(2);
                }
            }
            
            phenotype[i] ^= enviroment[i];
        }
        individual.fitness = MainForm.fitnessType.execute(this.phenotype);
    }
}
