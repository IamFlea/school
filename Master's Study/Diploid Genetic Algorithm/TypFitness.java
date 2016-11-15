package diploidga;


interface TypFitness {
    String name();
    int execute(int[] a); 
};
 
/** Implements the algorithm using the strategy interface */
class OneMax implements TypFitness {
    public String name(){ 
        return "OneMax";
    }
    public int execute(int[] chrom){
        int result = 0;
        for(int i = 0; i < chrom.length; i++){
            if(chrom[i] == 1) {
                result++;
            }
        }
        return result;
    }
};
 
class RoyalRoad implements TypFitness {
    public String name(){ 
        return "RoyalRoad";
    }
    public int execute(int[] chrom){
        int result = 0;
        for(int i = 0; i < chrom.length; i+=4){
            if(chrom[i] == 1 && chrom[i+1] == 1 && chrom[i+2] == 1 && chrom[i+3] == 1) {
                result+=4;
            }
        }
        return result;
    }
};
 
class Depicitve implements TypFitness {
    public String name(){ 
        return "Deceptive";
    }
    public int execute(int[] chrom){
        int result = 0;
        int tmp;
        for(int i = 0; i < chrom.length; i+=4){
            tmp = chrom[i] + chrom[i+1] + chrom[i+2] + chrom[i+3];
            if(tmp == 4){
                result += 4;
            } else {
                result += 3 - tmp;
            }
            
        }
        return result;
    }
};