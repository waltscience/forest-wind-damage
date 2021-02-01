Analysis and data explanation for Walter et al. (2012) Forests;
"Nitrogen fertilization increases windstorm damage in an aggrading forest"

Analysis:
ba.csv and damage.csv are the datasheets corresponding to the 2009 forest inventory
and the 2011 forest damage assessment in the LTSP experiment. These datasheets are run 
through the analysis pipeline Data_prep.R to create the analysisdata.csv datasheet that is
used in the bootstrap analysis Analysis.R

Data_prep.R calculates the percentage of stems and the basal area damaged in each 
LTSP treatment subunits (called "square"). It does this for all spp. together, by spp., by
damage type, and by damage severity. This results in 17 response variables that are used 
in the bootstrap analysis. These data are written to analysisdata.csv.

Analysis.R uses the prepped datasheet analysisdata.csv to compute empirical means across
treatments, and create bootstrapped mean distributions using an 50,000 random samples. The
empirical means are compared to the boostrapped mean distributions to calculate p-values.


Data:
There are three datasheets in this repository - ba.csv, damage.csv, and analysisdata.csv.
ba.csv is the data from the 2009 forest inventory in the LTSP (Fowler et al. 2014). 
damage.csv is the data from the 2011 damage survey in the LTSP. And analysisdata.csv is 
analysis product of both ba.csv and damage.csv, data for the percentage of trees 
(basal area or stems) damaged. The attributes are explained as follows:

ba.csv:
block - LTSP block number [integer]
trmt - LTSP treatment name [string]
plot - LTSP plot number [integer]
square - subunit of plot [integer]
area_m2 - area of square in square meters [float]
area_ha - area of square in ha [float]
date - date square was sampled [date]
spp - species four-letter code [string]
tree - individual tree number [integer]
branch - individual branch of individual tree number [integer]
status - tree mortality status; L = live, D = Dead [binary string]
dbh_cm - tree / branch diameter at breast height in centimeters [float]
ba_m2 - tree / branch diameter at breast height in meters [float]
baperham2 - basal area per hectare in square meters [float]
uniq_square - concatenation of block|plot|square|trmt [string]
uniq_plot - concatenation of block|plot|trmt [string]
 
damage.csv:
block - LTSP block number [integer]
plot - LTSP plot number [integer]
square - subunit of plot [integer]
spp - species four-letter code [string]
status - tree mortality status; L = live, D = Dead [binary string]
damagetype - damage type designation; B = bent, T = tipup, S = snap [string]
degree - damage degree; M = moderate, S = significant, E = extensive, P = prostrate [string]
damagecat - concatenation of damagetype and degree [string]
damagecont - arbitrarily designated ordinal scale of damagecat [integer]
dbh_cm - tree / branch diameter at breast height in centimeters [float]
ba_m2 - tree / branch diameter at breast height in meters [float]
trmt - LTSP treatment name [string]
uniq_square - concatenation of block|plot|square|trmt [string]
uniq_plot - concatenation of block|plot|trmt [string]

analysisdata.csv:
trmt - LTSP treatment name [string]
uniq_square - concatenation of block|plot|square|trmt [string]
totalba - total basal area in square meters of the square [float]
damageba - damaged ba in square meters of the square [float]
pctbadam - percentage of the totalba damaged [float]
totstems - total number of stems in the square [integer]
damstems - number of damages stems in the square [integer]
pctstemdam - percentage of totstems damaged in the square [float]
sumbent - sum of bent stems in the square [integer]
sumsnap - sum of snap stems in the square [integer]
sumtipup - sum of tiput stems in the square [integer]
pctbent - percentage of damaged stems of damage type bent in the square [float]
pctsnap - percentage of damaged stems of damage type snap in the square [float]
pcttipup - percentage of damaged stems of damage type tipup in the square [float]
sumseverE - sum of stems of damage severity class E (Extensive) in square [integer]
sumseverM - sum of stems of damage severity class M (Moderate) in square [integer]
sumseverP - sum of stems of damage severity class P (Prostrate) in square [integer]
sumseverS - sum of stems of damage severity class S (Severe) in square [integer]
pctseverE - percentage of damaged stems of damage severity class E (Extensive) in square [float]
pctseverM - percentage of damaged stems of damage severity class M (Moderate) in square [float]
pctseverP - percentage of damaged stems of damage severity class P (Prostrate) in square [float]
pctseverS - percentage of damaged stems of damage severity class S (Severe) in square [float]
prpestemdam - sum of prpe stems damaged in square [integer]
litustemdam - sum of litu stems damaged in square [integer]
prsestemdam - sum of prse stems damaged in square [integer]
belestemdam - sum of bele stems damaged in square [integer]
prpestem - sum of prpe stems in square [integer]
litustem - sum of litu stems in square [integer]
prsestem - sum of prse stems in square [integer]
belestem - sum of bele stems in square [integer]
pctprpedam - percentage of prpestem damaged in square [float]
pctlitudam - percentage of litustem damaged in square [float]
pctprsedam - percentage of prsestem damaged in square [float]
pctbeledam - percentage of belestem damaged in square [floatr]
prpedamba - sum of prpe basal area damaged in square meters in square [integer]
litudamba - sum of litu basal area damaged in square meters in square [integer]
prsedamba - sum of prse basal area damaged in square meters in square [integer]
beledamba - sum of bele basal area damaged in square meters in square [integer]
prpeba - sum of prpe basal area in square meters in square [integer]
lituba - sum of litu basal area in square meters in square [integer]
prseba - sum of prse basal area in square meters in square [integer]
beleba - sum of bele basal area in square meters in square [integer]
pctprpebadam - percentage of prpeba damaged in square [float]
pctlitubadam - percentage of lituba damaged in square [float]
pctprsebadam - percentage of prseba damaged in square [float]
pctbelebadam - percentage of beleba damaged in square [float]

















