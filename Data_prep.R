# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Data prep for analysis of LTSP damage from 2009 wind storm
# Chris Walter
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



# load data and packages
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ba <- read.csv("ba.csv", header = TRUE)
dmg <- read.csv("damage.csv", header = TRUE)
packages <- c("ggplot2", "ggthemes", "tidyverse", "kknn", "nlme", "lme4", "dplyr")
lapply(packages, library, character.only = TRUE)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



# calculate percentage ba and stems damaged
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# sum total and damaged basal areas by square and calculate % ba damaged
ba <- ba[!ba$status == "D", ]  # remove dead trees from basal area estimate
basq <- aggregate(ba[, "ba_m2"], list(ba$uniq_square), sum)
dmgsq <- aggregate(dmg[, "ba_m2"], list(dmg$uniq_square), sum)
mis <- which(!(basq$Group.1 %in% dmgsq$Group.1))
df <- data.frame("Group.1" = basq$Group.1[mis], 
                 "x" = rep(0, length(mis)))
dmgsq <- as.data.frame(rbind(dmgsq, df))
badmg <- merge(basq, dmgsq, by = "Group.1")
colnames(badmg) <- c("uniq_square", "totalba", "damagba")
badmg$pctbadam <- (badmg$damagba / badmg$totalba) * 100
badmg$pctbadam[c(27, 34)] <- 100  # change two percents > 100 to 100

# sum total and damaged stems by square and calculate % stems damaged
totstem <- data.frame(table(ba$uniq_square))
damstem <- data.frame(table(dmg$uniq_square))
mis <- which(!(totstem$Var1 %in% damstem$Var1))
df <- data.frame("Var1" = totstem$Var1[mis], 
                 "Freq" = rep(0, length(mis)))
damstem <- as.data.frame(rbind(damstem, df))
pctstemdamsq <- merge(totstem, damstem, by = "Var1")
colnames(pctstemdamsq) <- c("uniq_square", "totstems", "damstems")
pctstemdamsq$pctstemdam <- (pctstemdamsq$damstems / pctstemdamsq$totstems) *100
pctstemdamsq$pctstemdam[27] <- 100 # change one percent > 100 to 100

# merge ba, and stem data frames
analysisdata <- merge(badmg, pctstemdamsq, by = "uniq_square")
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



# calculate precentage damage type and severity
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# sum number of each damage type in each square
type <- aggregate(spp ~ damagetype + uniq_square, data = dmg, FUN = length)
colnames(type)[3] <- "typesum"
b <- type[type$damagetype == "B", c(2:3)]
s <- type[type$damagetype == "S", c(2:3)]
t <- type[type$damagetype == "T", c(2:3)]
analysisdata <- merge(analysisdata, b, by = "uniq_square", all.x = TRUE)
analysisdata <- merge(analysisdata, s, by = "uniq_square", all.x = TRUE)
analysisdata <- merge(analysisdata, t, by = "uniq_square", all.x = TRUE)
colnames(analysisdata)[8:10] <- c("sumbent", "sumsnap", "sumtipup")
analysisdata[is.na(analysisdata)] <- 0
analysisdata$pctbent <- (analysisdata$sumbent  / analysisdata$damstems) * 100
analysisdata$pctsnap <- (analysisdata$sumsnap  / analysisdata$damstems) * 100
analysisdata$pcttipup <- (analysisdata$sumtipup  / analysisdata$damstems) * 100
analysisdata[is.na(analysisdata)] <- 0

# sum number of each damage severity in each square
sever <- aggregate(spp ~ degree + uniq_square, data = dmg, FUN = length)
colnames(type)[3] <- "seversum"
E <- sever[sever$degree == "E", c(2:3)]
M <- sever[sever$degree == "M", c(2:3)]
P <- sever[sever$degree == "P", c(2:3)]
S <- sever[sever$degree == "S", c(2:3)]
analysisdata <- merge(analysisdata, E, by = "uniq_square", all.x = TRUE)
analysisdata <- merge(analysisdata, M, by = "uniq_square", all.x = TRUE)
analysisdata <- merge(analysisdata, P, by = "uniq_square", all.x = TRUE)
analysisdata <- merge(analysisdata, S, by = "uniq_square", all.x = TRUE)
colnames(analysisdata)[14:17] <- c("sumseverE", "sumseverM", "sumseverP", "sumseverS")
analysisdata[is.na(analysisdata)] <- 0

# calculate percentage
analysisdata$pctseverE <- (analysisdata$sumseverE  / analysisdata$damstems) * 100
analysisdata$pctseverM <- (analysisdata$sumseverM  / analysisdata$damstems) * 100
analysisdata$pctseverP <- (analysisdata$sumseverP  / analysisdata$damstems) * 100
analysisdata$pctseverS <- (analysisdata$sumseverS / analysisdata$damstems) * 100
analysisdata[is.na(analysisdata)] <- 0
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



# calculate percentage stem and ba damage for four species
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# sum number of stems damaged by spp in each square
spdam <- aggregate(damagecat ~ spp + uniq_square, data = dmg, FUN = length)
colnames(spdam)[3] <- "sumsppdam"
prpe <- spdam[spdam$spp == "PRPE", c(2:3)]
litu <- spdam[spdam$spp == "LITU", c(2:3)]
prse <- spdam[spdam$spp == "PRSE", c(2:3)]
bele <- spdam[spdam$spp == "BELE", c(2:3)]
analysisdata <- merge(analysisdata, prpe, by = "uniq_square", all.x = TRUE)
analysisdata <- merge(analysisdata, litu, by = "uniq_square", all.x = TRUE)
analysisdata <- merge(analysisdata, prse, by = "uniq_square", all.x = TRUE)
analysisdata <- merge(analysisdata, bele, by = "uniq_square", all.x = TRUE)
colnames(analysisdata)[22:25] <- c("prpestemdam", "litustemdam", "prsestemdam", "belestemdam")
analysisdata[is.na(analysisdata)] <- 0

# sum number of stems by spp in each square
spstem <- aggregate(status ~ spp + uniq_square, data = ba, FUN = length)
colnames(spstem)[3] <- "sumsppstem"
prpe <- spstem[spstem$spp == "PRPE", c(2:3)]
litu <- spstem[spstem$spp == "LITU", c(2:3)]
prse <- spstem[spstem$spp == "PRSE", c(2:3)]
bele <- spstem[spstem$spp == "BELE", c(2:3)]
analysisdata <- merge(analysisdata, prpe, by = "uniq_square", all.x = TRUE)
analysisdata <- merge(analysisdata, litu, by = "uniq_square", all.x = TRUE)
analysisdata <- merge(analysisdata, prse, by = "uniq_square", all.x = TRUE)
analysisdata <- merge(analysisdata, bele, by = "uniq_square", all.x = TRUE)
colnames(analysisdata)[26:29] <- c("prpestem", "litustem", "prsestem", "belestem")
analysisdata[is.na(analysisdata)] <- 0

# calculate percentage of stems damage by spp
analysisdata$pctprpedam <- (analysisdata$prpestemdam  / analysisdata$prpestem) * 100
analysisdata$pctlitudam <- (analysisdata$litustemdam  / analysisdata$litustem) * 100
analysisdata$pctprsedam <- (analysisdata$prsestemdam  / analysisdata$prsestem) * 100
analysisdata$pctbeledam <- (analysisdata$belestemdam  / analysisdata$belestem) * 100
analysisdata[is.na(analysisdata)] <- 0
analysisdata$pctprpedam[c(26,27,34)] <- 100  # change 3 %age's > 100 to 100
analysisdata$pctlitudam[1] <- 0  # change 1 Inf to 0
analysisdata$pctprsedam[29] <- 100  # change 1 %age > 100 to 100
analysisdata$pctbeledam[8] <- 0  # change 1 Inf to 0

# sum damaged ba by spp in each square
spdmgba <- aggregate(ba_m2 ~ spp + uniq_square, data = dmg, FUN = sum)
prpe <- spdmgba[spdmgba$spp == "PRPE", c(2:3)]
litu <- spdmgba[spdmgba$spp == "LITU", c(2:3)]
prse <- spdmgba[spdmgba$spp == "PRSE", c(2:3)]
bele <- spdmgba[spdmgba$spp == "BELE", c(2:3)]
analysisdata <- merge(analysisdata, prpe, by = "uniq_square", all.x = TRUE)
analysisdata <- merge(analysisdata, litu, by = "uniq_square", all.x = TRUE)
analysisdata <- merge(analysisdata, prse, by = "uniq_square", all.x = TRUE)
analysisdata <- merge(analysisdata, bele, by = "uniq_square", all.x = TRUE)
colnames(analysisdata)[34:37] <- c("prpedamba", "litudamba", "prsedamba", "beledamba")
analysisdata[is.na(analysisdata)] <- 0

# sum total ba by spp in each square
spba <- aggregate(ba_m2 ~ spp + uniq_square, data = ba, FUN = sum)
prpe <- spba[spba$spp == "PRPE", c(2:3)]
litu <- spba[spba$spp == "LITU", c(2:3)]
prse <- spba[spba$spp == "PRSE", c(2:3)]
bele <- spba[spba$spp == "BELE", c(2:3)]
analysisdata <- merge(analysisdata, prpe, by = "uniq_square", all.x = TRUE)
analysisdata <- merge(analysisdata, litu, by = "uniq_square", all.x = TRUE)
analysisdata <- merge(analysisdata, prse, by = "uniq_square", all.x = TRUE)
analysisdata <- merge(analysisdata, bele, by = "uniq_square", all.x = TRUE)
colnames(analysisdata)[38:41] <- c("prpeba", "lituba", "prseba", "beleba")
analysisdata[is.na(analysisdata)] <- 0

# calculate percentage of ba damaged by species
analysisdata$pctprpebadam <- (analysisdata$prpedamba  / analysisdata$prpeba) * 100
analysisdata$pctlitubadam <- (analysisdata$litudamba  / analysisdata$lituba) * 100
analysisdata$pctprsebadam <- (analysisdata$prsedamba  / analysisdata$prseba) * 100
analysisdata$pctbelebadam <- (analysisdata$beledamba  / analysisdata$beleba) * 100
analysisdata$pctprpebadam[c(22, 26, 27, 34, 36)] <- 100  # change 5 %age's > 100 to 100
analysisdata$pctlitubadam[1] <- 0  # change 1 Inf to 0
analysisdata$pctlitubadam[c(25, 26, 27, 29, 30, 34, 48)] <- 100 # change 7 %age's > 100 to 100
analysisdata$pctprsebadam[c(5, 29, 31, 32)] <- 100 # change 4 %age's > 100 to 100
analysisdata$pctbelebadam[8] <- 0  # change 1 Inf to 0
analysisdata$pctbelebadam[c(9, 34)] <- 100 # change 2 %age's > 100 to 100
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



# write all damage respone variables to data to file for analysis
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
write.csv(analysisdata, "analysisdata.csv", row.names = FALSE)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



# # calculate species composition from 2009 composition survey
# # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# # sum basal area by species and square
# baspsq <- aggregate(ba_m2 ~ uniq_square + spp, data = ba, FUN = sum)
# baspsq <- merge(baspsq, basq, by.x = "uniq_square", by.y = "Group.1")
# colnames(baspsq)[4] <- "totalba"
# baspsq$pctbaspp <- (baspsq$ba_m2 / baspsq$totalba) * 100
# 
# # include species with 0 ba
# allspp <- expand.grid(unique(baspsq$uniq_square), unique(baspsq$spp))
# colnames(allspp) <- c("uniq_square", "spp")
# allspp <- full_join(allspp, baspsq, by = c("uniq_square", "spp"))
# allspp[is.na(allspp)] <- 0
# 
# # sum stems by species and square
# sppstems <- data.frame(table(ba$uniq_square, ba$spp))
# colnames(sppstems) <- c("uniq_square", "spp", "sppstems")
# colnames(totstem) <- c("uniq_square", "totalstems")
# sppstems <- merge(sppstems, totstem, by = "uniq_square")
# sppstems$pctstemspp <- (sppstems$sppstems / sppstems$totalstems) * 100
# 
# # merge stems and ba data
# composition <- full_join(allspp, sppstems, by = c("uniq_square", "spp"))
# 
# # write all composition data to file
# write.csv(composition, "compositiondata.csv", row.names = FALSE)
# # added treatment labels in excel outside R
# 
# # read composition data
# comp <- read.csv("compositiondata.csv", header = TRUE)
# 
# # calculate mean percent ba and stems in each square for each species
# sppba <- aggregate(pctbaspp ~ trmt_spp, data = comp, FUN = mean)
# sppst <- aggregate(pctstemspp ~ trmt_spp, data = comp, FUN = mean)
# meancomp <- merge(sppba, sppst, by = "trmt_spp")
# write.csv(meancomp, "meancomposition.csv", row.names = FALSE)
# # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




