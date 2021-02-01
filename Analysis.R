# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Bootstrap and species analysis of LTSP damage from 2009 wind storm
# Chris Walter
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# bootstrap analysis ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# set seed
set.seed(35)

# load and set up data to bootstrap
analysis <- read.csv("analysisdata.csv", header = TRUE)
dat <- analysis[, c("trmt", "pctbadam", "pctstemdam", "pctbent", "pctsnap", "pcttipup",
                "pctseverE", "pctseverM", "pctseverP", "pctseverS", "pctprpedam",
                "pctlitudam", "pctprsedam", "pctbeledam", "pctprpebadam",
                "pctlitubadam", "pctprsebadam", "pctbelebadam")]
ref <- dat[dat$trmt == "Ref", -1]
n <- dat[dat$trmt == "N", -1]
nl <- dat[dat$trmt == "NL", -1]

# calculate emperical sample means and standard errors
refmeans <- as.data.frame(t(colMeans(ref)))
nmeans <- as.data.frame(t(colMeans(n)))
nlmeans <- as.data.frame(t(colMeans(nl)))
meanex <- rbind(refmeans, nmeans)
meanex <- rbind(meanex, nlmeans)
std <- function(x) sd(x)/sqrt(length(x))
meanex <- rbind(meanex, apply(ref, 2, std))
meanex <- rbind(meanex, apply(n, 2, std))
meanex <- rbind(meanex, apply(nl, 2, std))
rownames(meanex) <- c("Refmean", "Nmean", "NLmean", "Refse", "Nse", "NLse")
#write.csv(meanex, "means.csv", row.names = TRUE)

# initialize bootstrap iteration number and sample dataframes
iterations = 50000
bootref <- as.data.frame(matrix(ncol = 17, nrow = iterations))
colnames(bootref) <- colnames(ref)
bootn <- bootref
bootnl <- bootref

# bootstrap sample 17 variables in 3 treatments
for (i in 1:iterations){
  bootref[i, ] <- colMeans(ref[sample(rownames(ref), 24, replace = TRUE), ])
  bootn[i, ] <- colMeans(n[sample(rownames(n), 24, replace = TRUE), ])
  bootnl[i, ] <- colMeans(nl[sample(rownames(nl), 24, replace = TRUE), ])
}

# calculate hypothesis test p-values and store in new data frames
pngtref <- as.data.frame(t(colSums(bootn < refmeans[rep(seq_len(nrow(refmeans)), each = iterations), ]) / iterations))
pnltref <- as.data.frame(t(colSums(bootn > refmeans[rep(seq_len(nrow(refmeans)), each = iterations), ]) / iterations))
pnlgtref <- as.data.frame(t(colSums(bootnl < refmeans[rep(seq_len(nrow(refmeans)), each = iterations), ]) / iterations))
pnlltref <- as.data.frame(t(colSums(bootnl > refmeans[rep(seq_len(nrow(refmeans)), each = iterations), ]) / iterations))
pngtnl <- as.data.frame(t(colSums(bootn < nlmeans[rep(seq_len(nrow(nlmeans)), each = iterations), ]) / iterations))
pnltnl <- as.data.frame(t(colSums(bootn > nlmeans[rep(seq_len(nrow(nlmeans)), each = iterations), ]) / iterations))
allps <- rbind(pngtref, pnltref, pnlgtref, pnlltref, pngtnl, pnltnl)
row.names(allps) <- c("pngtref", "pnltref", "pnlgtref", "pnlltref", "pngtnl", "pnltnl")
write.csv(allps, "allps.csv")
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~















