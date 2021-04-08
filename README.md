# forest-wind-damage

### This repository contains the data and analysis for the paper *Nitrogen fertilization increases windstorm damage in an aggrading forest* by Walter, C.A., Fowler, Z.K., Adams, M.B., Burnham, M.B., McNeil, B.E., and W.T Peterjohn (2021) in the journal *Forests*, 12, 443. Open-access article available at [https://www.mdpi.com/1999-4907/12/4/443](https://www.mdpi.com/1999-4907/12/4/443).
<br>

### * *This dataset is also archived, accessible, and citeable with a DOI at [Zenodo](https://doi.org/10.5281/zenodo.4487873)*
<br>
<br>

**The analysis follows a two-step process**:
 1. Prepare data using ba.csv and damage.csv in the script Data_prep.R
 2. Use prepared data in analysis.csv to perform bootstrap analysis in the script Analysis.R
<br>

## Description

### Analysis
ba.csv and damage.csv are the datasheets corresponding to the 2009 forest inventory
and the 2011 forest damage assessment in the LTSP experiment. These datasheets are run 
through the analysis pipeline Data_prep.R to create the analysisdata.csv datasheet that is
used in the bootstrap analysis Analysis.R

Data_prep.R calculates the percentage of stems and the basal area damaged in each 
LTSP treatment subunits (called "square"). It does this for all spp. together, by spp., by
damage type, and by damage severity. This results in 17 response variables that are used 
in the bootstrap analysis. These data are written to analysisdata.csv.

Analysis.R uses the prepped datasheet analysisdata.csv to compute empirical means across
treatments, and create bootstrapped mean distributions using 50,000 random samples. The
empirical means are compared to the boostrapped mean distributions to calculate p-values.

A more detailed explanation of the analysis is available in the paper (forests_paper.pdf), available at [https://www.mdpi.com/1999-4907/12/4/443](https://www.mdpi.com/1999-4907/12/4/443). 

### Data
There are three datasheets in this repository - ba.csv, damage.csv, and analysisdata.csv.
ba.csv is the data from the 2009 forest inventory in the LTSP (Fowler et al. 2014). 
damage.csv is the data from the 2011 damage survey in the LTSP. And analysisdata.csv is 
analysis product of both ba.csv and damage.csv, data for the percentage of trees 
(basal area or stems) damaged. The attributes are explained as follows:

**ba.csv**:<br>
block - LTSP block number [integer]<br>
trmt - LTSP treatment name [string]<br>
plot - LTSP plot number [integer]<br>
square - subunit of plot [integer]<br>
area_m2 - area of square in square meters [float]<br>
area_ha - area of square in ha [float]<br>
date - date square was sampled [date]<br>
spp - species four-letter code [string]<br>
tree - individual tree number [integer]<br>
branch - individual branch of individual tree number [integer]<br>
status - tree mortality status; L = live, D = Dead [binary string]<br>
dbh_cm - tree / branch diameter at breast height in centimeters [float]<br>
ba_m2 - tree / branch diameter at breast height in meters [float]<br>
baperham2 - basal area per hectare in square meters [float]<br>
uniq_square - concatenation of block|plot|square|trmt [string]<br>
uniq_plot - concatenation of block|plot|trmt [string]<br>
 
**damage.csv**:<br>
block - LTSP block number [integer]<br>
plot - LTSP plot number [integer]<br>
square - subunit of plot [integer]<br>
spp - species four-letter code [string]<br>
status - tree mortality status; L = live, D = Dead [binary string]<br>
damagetype - damage type designation; B = bent, T = tipup, S = snap [string]<br>
degree - damage degree; M = moderate, S = significant, E = extensive, P = prostrate [string]<br>
damagecat - concatenation of damagetype and degree [string]<br>
damagecont - arbitrarily designated ordinal scale of damagecat [integer]<br>
dbh_cm - tree / branch diameter at breast height in centimeters [float]<br>
ba_m2 - tree / branch diameter at breast height in meters [float]<br>
trmt - LTSP treatment name [string]<br>
uniq_square - concatenation of block|plot|square|trmt [string]<br>
uniq_plot - concatenation of block|plot|trmt [string]<br>

**analysisdata.csv**:
<br>
trmt - LTSP treatment name [string]<br>
uniq_square - concatenation of block|plot|square|trmt [string]<br>
totalba - total basal area in square meters of the square [float]<br>
damageba - damaged ba in square meters of the square [float]<br>
pctbadam - percentage of the totalba damaged [float]<br>
totstems - total number of stems in the square [integer]<br>
damstems - number of damages stems in the square [integer]<br>
pctstemdam - percentage of totstems damaged in the square [float]<br>
sumbent - sum of bent stems in the square [integer]<br>
sumsnap - sum of snap stems in the square [integer]<br>
sumtipup - sum of tiput stems in the square [integer]<br>
pctbent - percentage of damaged stems of damage type bent in the square [float]<br>
pctsnap - percentage of damaged stems of damage type snap in the square [float]<br>
pcttipup - percentage of damaged stems of damage type tipup in the square [float]<br>
sumseverE - sum of stems of damage severity class E (Extensive) in square [integer]<br>
sumseverM - sum of stems of damage severity class M (Moderate) in square [integer]<br>
sumseverP - sum of stems of damage severity class P (Prostrate) in square [integer]<br>
sumseverS - sum of stems of damage severity class S (Severe) in square [integer]<br>
pctseverE - percentage of damaged stems of damage severity class E (Extensive) in square [float]<br>
pctseverM - percentage of damaged stems of damage severity class M (Moderate) in square [float]<br>
pctseverP - percentage of damaged stems of damage severity class P (Prostrate) in square [float]<br>
pctseverS - percentage of damaged stems of damage severity class S (Severe) in square [float]<br>
prpestemdam - sum of prpe stems damaged in square [integer]<br>
litustemdam - sum of litu stems damaged in square [integer]<br>
prsestemdam - sum of prse stems damaged in square [integer]<br>
belestemdam - sum of bele stems damaged in square [integer]<br>
prpestem - sum of prpe stems in square [integer]<br>
litustem - sum of litu stems in square [integer]<br>
prsestem - sum of prse stems in square [integer]<br>
belestem - sum of bele stems in square [integer]<br>
pctprpedam - percentage of prpestem damaged in square [float]<br>
pctlitudam - percentage of litustem damaged in square [float]<br>
pctprsedam - percentage of prsestem damaged in square [float]<br>
pctbeledam - percentage of belestem damaged in square [float]<br>
prpedamba - sum of prpe basal area damaged in square meters in square [integer]<br>
litudamba - sum of litu basal area damaged in square meters in square [integer]<br>
prsedamba - sum of prse basal area damaged in square meters in square [integer]<br>
beledamba - sum of bele basal area damaged in square meters in square [integer]<br>
prpeba - sum of prpe basal area in square meters in square [integer]<br>
lituba - sum of litu basal area in square meters in square [integer]<br>
prseba - sum of prse basal area in square meters in square [integer]<br>
beleba - sum of bele basal area in square meters in square [integer]<br>
pctprpebadam - percentage of prpeba damaged in square [float]<br>
pctlitubadam - percentage of lituba damaged in square [float]<br>
pctprsebadam - percentage of prseba damaged in square [float]<br>
pctbelebadam - percentage of beleba damaged in square [float]<br>

### Field sampling protocol

Additional details and schematics of the field sampling of the forest survey and damage assessment are included in the MS Excel file field_sampling_protocol.xlsx. The file includes graphical layouts of the blocks, plots, and squares and details of the measurements taken during sampling. 

<br>

## License
### MIT License

Copyright (c) 2021 Chris Walter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software, data, code, and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.




