package sfcga;

import java.awt.Point;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;


/**
 *
 * @author Flea
 */
public class TSP{
    Point[] nodes = new Point[TSP.MAX_VALUE];
    int nodesIdx = 0; // Pocet pouzitych uzlu. 
    Double[][] distance = new Double[TSP.MAX_VALUE][TSP.MAX_VALUE];
    
    private static int MAX_VALUE = 10000;
    
    List<Chromosome> population;
    public int maxGenerations;
    public int popSize;
    public int offspringsSize;
    public int pointsOfXover;
    public double crossoverProbabilty;
    public double mutationProbabilty;
    public SelectionType selectionParents;
    public SelectionType selectionNewPop;
    public boolean strategy;
    
    public boolean runnable = false;
    
    SendMsg sendMsg;
    
    TSP(SendMsg tmp){
        sendMsg = tmp;
    }
    /**
     * Ohodnoceni jedince chrom fitness fci. 
     * @param chrom Dany jedinec.
     */
    private void evalFit(Chromosome chrom){
        double fitness = 0;
        for(int i = 1; i < chrom.chrom.size(); i++){
            fitness += distance[chrom.chrom.get(i-1)][chrom.chrom.get(i)];
        }
        fitness += distance[chrom.chrom.get(0)][chrom.chrom.get(chrom.chrom.size() - 1)];
        chrom.fitness = fitness;
    }
    
    /**
     * Ohodnoceni cele population
     */
    private void evalPop(){
        for(int i = 0; i < (popSize+offspringsSize); i++){
            evalFit(population.get(i));
        }
    }
    /**
     * Ohodnoceni rodicu
     */
    private void evalParents(){
        for(int i = 0; i < popSize; i++){
            evalFit(population.get(i));
        }
    }
    /**
     * Ohodnoceni deti
     */
    void evalKids(){
        for(int i = popSize; i < (popSize + offspringsSize); i++){
            evalFit(population.get(i));
        }
    }
    
    public void step(){
        double rand;
        
        //udelej deti
        for(int i = 0; i < offspringsSize; i++){
            rand = SfcGA.rand.nextDouble();
            Chromosome secondParent = selectionParents.exec(this.population);
            Chromosome kid; 
            if(rand < crossoverProbabilty)
                kid = secondParent.crossover(selectionParents.exec(this.population), SfcGA.rand.nextInt(pointsOfXover) +1);
            else {
                kid = secondParent.copy();
                kid.mutateSwap();
            }
            
            rand = SfcGA.rand.nextDouble();
            if(rand < mutationProbabilty)
                kid.mutateSwap();
            evalFit(kid);
            population.add(kid);
        }
        List<Chromosome> newPopulation = new ArrayList<>();
        int start = (strategy) ? popSize : 0;
        for(int j = 0; j < popSize; j++){
            newPopulation.add(selectionNewPop.exec(population.subList(start, population.size())));
            
        }
        population = newPopulation;
    }
        
    Chromosome getParent(){
        double best = Double.MAX_VALUE;
        Chromosome result = null;
        for(Chromosome c : population){
            if(c.fitness < best){
                best = c.fitness;
                result = c;
            }
        }
        return result;
    }  
        
    public void run(){
        for(int i = 0; i < maxGenerations; i++){
            step();
        }
    }
    
    /**
     * Inicializace vzdalenostni matice.
     */
    private void initDistances(){
        for(int i = 0; i < nodesIdx; i++){ // Pro kazde mesto mi najdi
            for(int j = i+1; j < nodesIdx; j++){ // Druhe mesto
                // Zajdete si za pythagorasem, ten vam poradi jak pocitat vzdalenost
                Double dist_x;
                Double dist_y;
                Double dist;
                if(nodes[i].x > nodes[j].x)
                    dist_x = (double)(nodes[i].x - nodes[j].x); 
                else
                    dist_x = (double)(nodes[j].x - nodes[i].x); 
                
                if(nodes[i].y > nodes[j].y)
                    dist_y = (double)(nodes[i].y - nodes[j].y);
                else
                    dist_y = (double)(nodes[j].y - nodes[i].y);
                
                dist = Math.sqrt(dist_x*dist_x + dist_y*dist_y);
                distance[i][j] = dist;
                distance[j][i] = dist; // Nepojedeme po jednosmerkach.
            }
        }
    }
    
    /**
     * Inicialiyace vstupnich hodnot.
     */
    public int init(){
        if(nodesIdx < 2){
            return 0;
        }
        initDistances();
        population = new ArrayList<>();
        for(int i = 0; i < popSize; i++){
            Chromosome jedinec = new Chromosome();
            for(int j = 0; j < nodesIdx; j++){
                jedinec.chrom.add(j);
            }
            for(int j = 0; j < TSP.MAX_VALUE; j++){
                jedinec.mutateSwap();
            }
            population.add(jedinec);
        }
        evalParents();
        return 1;
    }
}
