## Ukol 3 do predmetu PBI
## ======================
##
## Autor: Petr Dvoracek <xdvora0n@stud.fit.vutbr.cz>
## Datum: 10. prosinec 2014
## 
## Metriky kodu
## ------------
##   Pocet vypitych kav: 3
##   Pocet pismenek "i": vic jak 219
# Prolog:
source("http://bioconductor.org/biocLite.R")
biocLite()
biocLite("BSgenome.Celegans.UCSC.ce2")
biocLite(c("MotifDb",  "GenomicFeatures", 
           "TxDb.Scerevisiae.UCSC.sacCer3.sgdGene",
           "org.Sc.sgd.db", "BSgenome.Scerevisiae.UCSC.sacCer3",
           "vignettes",
           "motifStack", "seqLogo", "IRanges", "GRanges"))

library(seqLogo)
library(BSgenome.Celegans.UCSC.ce2)
library(IRanges)

# Bod 1.1
chrom <- Celegans$chrIII
countPattern("ATG", chrom)
# Celkem 228710 sekvenci

# Bod 1.2
tata <- matchPattern("---TATA---", chrom, max.mismatch=6)
tata
# Celkem 65033 sekvenci

# Bod 1.3
pwm <- PWM(DNAStringSet(tata), type = "prob", prior.params = c(A=0.25, C=0.25, G=0.25, T=0.25))

# Bod 1.4
seqLogo(t(t(pwm)) * 1/colSums(pwm)) # Nasel jsem nekde na netu

# Bod 1.5
# What the hell?


# Bod 2
# Nenastudoval. Bude to na zkousce? :)

# Bod 3    Seznamte se strukturou DataFrame a baliky IRanges a GRanges 
#   [DONE]
# Bod 3.1  Naleznete vyskyt retezcu TATA, CAAT a ATG v genomu Celegans na + vlakne.
tata <- matchPattern("TATA", chrom)
caat <- matchPattern("CAAT", chrom)
atg  <- matchPattern("ATG", chrom)
# Ulozte je jako datovou strukturu IRanges..
tata_irange <- as(tata, "IRanges")
caat_irange <- as(caat, "IRanges")
atg_irange  <- as(atg,  "IRanges")
## Tohle by mohlo byt jinak.. ale co nebudu opravovat fungujici kod.. 
iranges <- IRanges(c(start(tata_irange),start(caat_irange),start(atg_irange)), c(end(tata_irange),end(caat_irange),end(atg_irange)))
# ...a GRanges (pridejte ciselnou informaci o typu sekvence)
seqnames <- rep("chrIII", length(iranges))
ranges <- c(tata_irange, caat_irange, atg_irange)
strand <- rep("+", length(iranges))
gene_type <- c(rep(1, length(tata_irange)), rep(2, length(caat_irange)), rep(3, length(atg_irange)))
id_number <- c(1:length(iranges))
dataset <- data.frame(seqnames, ranges, strand, gene_type)
colnames(dataset) <- c('chro', 'start','end', 'width', 'strand', 'id')
grange <- with(dataset, GRanges(chro, IRanges(start, end), strand, id_number=id))
# vizualizujte urcitou oblast genomu s nekolika takovymi vyskyty 
#      (funkce plotRanges z vignetty IRanges nebo viz 4.1) 
#      a zobrazte prislusnou cast datove struktury GRanges.

# Cast prevzata z internetu: http://www.bioconductor.org/help/course-materials/2009/GenentechNov2009/Module7/IRanges.R
plotRanges <- function(x, xlim = x, main = deparse(substitute(x)),
                       col = "black", sep = 0.5, ...) 
{
  height <- 1
  if (is(xlim, "Ranges"))
    xlim <- c(min(start(xlim)), max(end(xlim)))
  bins <- disjointBins(IRanges(start(x), end(x) + 1))
  plot.new()
  plot.window(xlim, c(0, max(bins)*(height + sep)))
  ybottom <- bins * (sep + height) - height
  rect(start(x)-0.5, ybottom, end(x)+0.5, ybottom + height, col = col, ...)
  title(main)
  axis(1)
}
# Konec casti prevzate z internetu.
plotRanges(iranges)
plotRanges(tata_irange)
plotRanges(caat_irange)
plotRanges(atg_irange)

#4. Seznamte se s baliky rtracklayer, biomaRt OK.
biocLite(c("biomaRt", "rtracklayer", "GenomeGraphs"))
library(biomaRt)
library(rtracklayer)
library(GenomeGraphs)
#
#  Ukoly
#  4.1 Importujte data o pozici vsech HOX genu z databaze Ensembl,
ensembl = useMart("ensembl")
ensembl = useDataset("celegans_gene_ensembl",mart=ensembl)

attributes = listAttributes(ensembl)
attr = c(attributes[1], attributes[7:8])
# Podle internetu, ja nevim ja nejsem biolog. Jsem po dvou hodinach marneho hledani nasel tyto homeoticke geny.
# http://www.nematodes.org/teaching/gg3/Tech5_Databases/index.shtml
# ceh-13, lin-39, mab-5, egl-5, php-3, nob-1
hox_geny = c("ceh-13", "lin-39", "mab-5", "egl-5", "php-3", "nob-1")
hox = getBM(attributes=c('wormbase_locus', 'start_position', 'end_position', 'chromosome_name', 'ensembl_gene_id', 'strand'), filters='wormbase_locus', values=hox_geny, mart=ensembl)
#      vytvorte objekt GenomeRanges s temato daty 
seqnames <- rep("chrIII", nrow(hox))
ranges <- IRanges(start=hox[2][1:nrow(hox),], end=hox[3][1:nrow(hox),])
strand <- rep("+", nrow(hox)) # toz si to nejdriv inicializuju :)
for (idx in 1:length(strand)){
	if(hox[6][idx,] == -1){
		strand[idx] <- "-"
	}
}
gene_type <- c(hox[1][1:nrow(hox),])
id_number <- c(1:nrow(hox))
dataset <- data.frame(seqnames, ranges, strand, gene_type)
colnames(dataset) <- c('chro', 'start','end', 'width', 'strand', 'id')
grange <- with(dataset, GRanges(chro, IRanges(start, end), strand, gname=id))
# a nechte je zobrazit podel chromosomu  (GenomeGraphs, genoPlotR nebo quantsmooth).
# Zase cast z internetu, tedkom je verohodnejsi zdroj z manualove stranky GenomeGraphs.
plotGeneRegion <- function(chr = 3, minB = 9000, maxB = 13000, rot = 0, col = "green", strandin="+") {
		chrRoman <- as.character(as.roman(1:17)[chr])
		grP <- makeGeneRegion(start = minB, end = maxB,
				strand = strandin, chromosome = "III", biomart = ensembl,
				dp = DisplayPars(plotId = TRUE, idRotation = rot,
				idColor = col))
		#print(grP);
		gaxis <- makeGenomeAxis( add53 = TRUE, add35 = TRUE, littleTicks = FALSE)
		gdPlot(list(grP, gaxis), minBase = minB, maxBase = maxB)
	}
# Konec
for (idx in 1:length(ranges)){
	plotGeneRegion(col = "yellow", rot=90, minB=start(ranges[idx]), maxB=end(ranges[idx]), strandin=strand[idx])
	print("Stiskni enter na pokracovani")
	line <- readline()
}
# Hura muzu to odevzdat!