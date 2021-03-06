# These scripts reproduce the analysis in the paper: van Kempen et al.,
# (2018) 'Behavioural and neural signatures of perceptual evidence
# accumulation are modulated by pupil-linked arousal'
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the 
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#   
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 
# Jochem van Kempen, 2018
# Jochemvankempen@gmail.com
# https://github.com/jochemvankempen/2018_Monash
# 
# -------------------------------------------------------------------------
  
# analyse participant level data

# load the relevant libraries
x<-c("tidyverse","car", "nlme", "lme4", "ez", "dplyr", "ggplot2", "knitr","stringr","nortest","gridExtra","png","R.matlab","lmerTest","simpleboot")
lapply(x, function(x) {if (!require(x, character.only=T)) {install.packages(x);require(x)}})

# clear all
rm(list=ls(all=TRUE)) 

# which dataset?
dataset2use = 'bigDots'; nSub = 80;
# dataset2use = 'CD'; nSub = 17;


filedir = str_c('E:/Monash/', dataset2use, '/data/population/')
figDir  = str_c(filedir, 'fig/R/' )
dir.create(figDir, showWarnings = TRUE)
# load useful functions ---------------------------------------------------
wddir   = str_c('C:/Jochem/repositories/2019_pupil_decisionMaking/utilities/')
setwd(wddir)
source("summarySE.R") 
source('two_lines_JvK.R')

# a few settings defined in Matlab, goes in the filename that will be loaded
scaleVariables = 1;
CSD = 0
nChanAlpha = 3

# what is the number of bins etc?
nside           = 1;
nbin            = 5;
bintype         = 'equal';

# pupil_filterSettings = c(0.05, 4)
pupil_filterSettings = c(0.01, 6)

# GLM settings
meanCenter = 0;
orthogonalPredictors = 0;
normalisePupil = 0;
GLM_bl = 800;

# which sorting?


### Baseline pupil diameter
bin2use = 'pupil_lp_baseline_regress_iti_side'
# # bin2use = 'pupil_lp_1Hz_baseline_regress_iti_side'
# bin2use = 'pupil_lp_baselineSlope_regress_iti_side'
# bin2use = 'pupil_lp_baselineDiff_regress_iti_side'
# bin2use = 'pupil_bp_baseline_regress_iti_side'
# bin2use = 'pupil_bp_baselinePhase_regress_iti_side'
# bin2use = 'pupil_bp_baselinePhase_regress_iti_side_fix'

# 
# # 
# # ### Pupil RT
# bin2use = 'pupil_bp_RT_neg200_200_regress_bl_iti_side'
# bin2use = 'pupil_bp_RT_neg200_200_regress_bl_iti_side_RT'
# 
# # ### Pupil around max derivative of IRF
# # bin2use = 'pupil_bp_average_maxDiff_pupilIRF_neg200_200_regress_bl_iti_side';
# bin2use = 'pupil_bp_slope_maxDiff_pupilIRF_neg200_200_regress_bl_iti_side';
# bin2use = 'pupil_bp_diff_maxDiff_pupilIRF_200_200_regress_bl_iti_side';
# bin2use = 'pupil_bp_linearProjection_maxDiff_pupilIRF_neg200_200_regress_bl_iti_side';
# # # 
# # # # ### GLM estimated Pupil
# bin2use = 'GLM_pupil_StimResp_stim_regress_bl_iti_side';
# bin2use = 'GLM_pupil_Ramp_stim_regress_iti_side';
# bin2use = 'GLM_pupil_Ramp_stim_regress_bl_iti_side';
# bin2use = 'GLM_pupil_Ramp_stim_regress_blPhase_iti_side';
# bin2use = 'GLM_pupil_Ramp_stim_regress_bl_blPhase_iti_side';
# 
# bin2use = 'GLM_pupil_Ramp_sust_regress_bl_iti_side';
# 
# bin2use = 'GLM_pupil_Ramp_stim_VIF5_regress_bl_iti_side';
# 
# ### Other
# bin2use = 'pretarget_alpha';


# ------------------------------------------------------------------------
# look at data averaged for each participannt
# ------------------------------------------------------------------------

# # load participant level data
if((bin2use=='pretarget_alpha') || 
   (bin2use=='pupil_lp_baseline_regress_iti_side') || 
   (bin2use=='pupil_lp_baselineSlope_regress_iti_side') || 
   (bin2use=='pupil_lp_baselineDiff_regress_iti_side') || 
   (bin2use=='pupil_bp_baseline_regress_iti_side') || 
   (bin2use=='pupil_bp_baselinePhase_regress_iti_side') || 
   (bin2use=='pupil_bp_baselinePhase_regress_iti_side_fix') || 
   (bin2use=='pupil_lp_1Hz_baseline_regress_iti_side') ||
   (bin2use=='pupil_bp_RT_neg200_200_regress_bl_iti_side') ||
   (bin2use=='pupil_bp_RT_neg200_200_regress_bl_iti_side_RT') ||
   (bin2use=='pupil_bp_average_maxDiff_pupilIRF_neg200_200_regress_bl_iti_side') ||
   (bin2use=='pupil_bp_slope_maxDiff_pupilIRF_neg200_200_regress_bl_iti_side') ||
   (bin2use=='pupil_bp_diff_maxDiff_pupilIRF_200_200_regress_bl_iti_side') ||
   (bin2use=='pupil_bp_linearProjection_maxDiff_pupilIRF_neg200_200_regress_bl_iti_side'))
{
  filename = str_c('participant_level_scaleVar(', scaleVariables ,')_side(',nside ,')_bin(', nbin, ')_', bin2use ,
  '_equal_pupil_', pupil_filterSettings[1], '_', pupil_filterSettings[2], 'Hz_CSD(', CSD, ')_','chAlpha(', nChanAlpha, ')_review' )
} else {
  filename = str_c('participant_level_scaleVar(', scaleVariables ,')_side(',nside ,')_bin(', nbin, ')_', bin2use ,
  '_equal_pupil_', pupil_filterSettings[1], '_', pupil_filterSettings[2], 'Hz_CSD(', CSD, ')_','chAlpha(', nChanAlpha, ')_review',
  '_GLM_meanC(', meanCenter ,')_orthPr(', orthogonalPredictors ,')_normPu(', normalisePupil ,')_bin(RT)_bl_', GLM_bl )
}

data_p_level = read_csv(str_c(filedir, filename,'.csv'))

data_p_level$Subject <- factor(data_p_level$Subject)
data_p_level$Side <- factor(data_p_level$Side)
data_p_level$Bin <- factor(data_p_level$Bin,labels=c("1", "2", "3", "4", "5"))

#  ------------------------------------------------------------------------
## check number of trials in each condition

sum_trials <- summarySE(data_p_level, measurevar="nTrial", groupvars=c("Bin","Side"))

sum_trials <- data.frame(sum_trials)
tt <- ttheme_default(colhead=list(fg_params = list(parse=TRUE)))
tbl <- tableGrob(sum_trials, rows=NULL, theme=tt)

png(str_c(figDir,'nTrials', bin2use, '.png'))
grid.arrange(tbl)
dev.off()
#  ------------------------------------------------------------------------


data_p_level$Bin <- as.numeric(data_p_level$Bin) # for polynomial contrasts to be set
data_p_level <- within(data_p_level, polyBin <- poly(Bin,2)) # define orthogonal polynomial


# our model has a random intercept for each subject (repeated measrures analysis)
model.Intercept     <- lme4::lmer(preTargBetaAT ~ 1 +
                                    (1|Subject),
                                  data = data_p_level, na.action = na.omit, REML=FALSE) # baseline model to compare the effect of bin to.
model.bin       <- update(model.Intercept, .~. + polyBin[, 1]) # test linear polynomial
model.binQ      <- update(model.bin, .~. + polyBin[, 2])# test quadratic polynomial

# model.bin       <- update(model.Intercept, .~. + Bin) # test linear polynomial, not orthogonal!!
# model.binQ      <- update(model.bin, .~. + I(Bin^2))# test linear polynomial, not orthogonal!!

anova(model.Intercept, model.bin, model.binQ) #compare likelihood of models

library(broom)
summary(model.binQ)
kable(tidy(model.binQ),digits = 3)
library(MuMIn)
r.squaredGLMM(model.binQ)
# see https://jonlefcheck.net/2013/03/13/r2-for-linear-mixed-effects-models/ for an explanation of marginal and conditional R2
library(piecewiseSEM)
rsquared(list(model.Intercept,model.binQ))
# 


# exclude some variables
all.dependent.variables <- data_p_level %>%
  dplyr::select(-one_of("Subject"), -one_of("Side"), -one_of("Bin"), -one_of("polyBin"), 
                -one_of("nTrial"),
                -one_of("pupil_bl_lp"), -one_of("pupil_bl_bp")) %>%
  names()

# reg2_JvK(data_p_level$Bin, data_p_level$RT, 3, data_p_level, 0)

fitlist_lme4 <- lapply(all.dependent.variables, function(i) {
  eval(parse(text=
               paste0('
                      model.baseline     <- lme4::lmer(', i, ' ~ (1|Subject), data = data_p_level, na.action = na.omit, REML=FALSE) # baseline model to compare the effect of bin to
                      model.bin          <- update(model.baseline, .~. + polyBin[, 1]) # test model with Bin, linear
                      model.binQ         <- update(model.bin, .~. + polyBin[, 2]) # test model with Bin, quadratic
                      stat <- anova(model.baseline, model.bin,model.binQ)
                      stat$ushape = reg2_JvK(data_p_level$Bin, data_p_level$', i, ', 3, data_p_level, 0)

                      if (stat$ushape[1] == 0) {stat$ushape = reg2_JvK(data_p_level$Bin, data_p_level$', i, ', 2, data_p_level, 0)}
                      if (stat$ushape[1] == 0) {stat$ushape = reg2_JvK(data_p_level$Bin, data_p_level$', i, ', 3, data_p_level, 1)}

                      # model.bin <- as(model.bin,"merModLmerTest") # use the lmerTest package to obtain a p-value for the coefficients
                      trend <- coef(summary(model.binQ))

                      fit_Y_L <- predict(model.bin)
                      mat_fitL <- matrix(NA, nrow =1, ncol = (nSub*nbin))
                      mat_fitL[as.numeric(names(fit_Y_L))] <-  unname(fit_Y_L)
                      # mat_fitL <- matrix(mat_fitL, nrow = nSub, byrow = FALSE)

                      fit_Y_Q <- predict(model.binQ)
                      mat_fitQ <- matrix(NA, nrow =1, ncol = (nSub*nbin))
                      mat_fitQ[as.numeric(names(fit_Y_Q))] <-  unname(fit_Y_Q)
                      # mat_fitQ <- matrix(mat_fitQ, nrow = nSub, byrow = FALSE)

                      list(stat=stat, trend=trend, fitL=mat_fitL, fitQ=mat_fitQ)
                      ')
               ))
})

# write the results to a csv file
### lme4 stats
lme_stat <- as.data.frame(sapply(fitlist_lme4, "[[", 1))
colnames(lme_stat) <- all.dependent.variables
lme_stat <- t(lme_stat)
lme_stat <- cbind(rownames(lme_stat), lme_stat)
rownames(lme_stat) <- NULL
colnames(lme_stat)[1] <- c("key")
lme_stat <- as_tibble(lme_stat)
lme_stat$key <- as.character(lme_stat$key)
lme_stat2 <- lme_stat[,1]
lme_stat2$Df_Intercept <- sapply(lme_stat$Df, "[[", 1)
lme_stat2$Df_L <- sapply(lme_stat$Df, "[[", 2)
lme_stat2$Df_Q <- sapply(lme_stat$Df, "[[", 3)
lme_stat2$Chisq_L <- sapply(lme_stat$Chisq, "[[", 2)
lme_stat2$Chisq_Q <- sapply(lme_stat$Chisq, "[[", 3)
lme_stat2$P_L <- sapply(lme_stat$`Pr(>Chisq)`, "[[", 2)
lme_stat2$P_Q <- sapply(lme_stat$`Pr(>Chisq)`, "[[", 3)
lme_stat2$U <- sapply(lme_stat$ushape, "[[", 3)

### lme4 trends
row2get = c(2,3)
col2get = c(1,2,3)
trendlist_colnames <- names(data.frame(fitlist_lme4[[1]]$trend))
trendlist_rownames <- rownames(data.frame(fitlist_lme4[[1]]$trend))
trendlist_rownames <- rownames(data.frame(fitlist_lme4[[1]]$trend))
trendlist_colnames[which(trendlist_colnames=="Estimate")] <- 'Estimate_Trend'
trendlist_colnames[which(trendlist_colnames=="Std..Error")] <- 'SE_Trend'
trendlist_colnames[which(trendlist_colnames=="t.value")] <- 't_Trend'
trendlist_rownames[which(trendlist_rownames=="(Intercept)")] <- 'Intercept'
trendlist_rownames[which(trendlist_rownames=="polyBin[, 1]")] <- 'BinL'
trendlist_rownames[which(trendlist_rownames=="polyBin[, 2]")] <- 'BinQ'
trends <- as.data.frame(sapply(1:length(fitlist_lme4), function(i) as.numeric(fitlist_lme4[[i]]$trend[row2get,col2get])))
newcolnames <- apply(expand.grid(trendlist_rownames[row2get], trendlist_colnames[col2get]), 1, function(x) paste(x[1], x[2], sep="_"))
colnames(trends) <- all.dependent.variables
trends <- t(trends)
trends <- cbind(rownames(trends), trends)
rownames(trends) <- NULL
trends <- as_tibble(trends)
colnames(trends) <- c("key", newcolnames)
trends$key <- as.character(trends$key)

# get linear fits
lme_fitL <- as.data.frame(sapply(fitlist_lme4, "[[", 3))
colnames(lme_fitL) <- lme_stat$key
lme_fitL <- t(lme_fitL)
colnames(lme_fitL) <- paste(rep('fitL',(nSub*nbin)), 1:(nSub*nbin), sep="_", collapse = NULL)
lme_fitL <- cbind(rownames(lme_fitL), lme_fitL)
colnames(lme_fitL)[1] <- c("key")
lme_fitL <- as_tibble(lme_fitL)

# get quadratic fits
lme_fitQ <- as.data.frame(sapply(fitlist_lme4, "[[", 4))
colnames(lme_fitQ) <- lme_stat$key
lme_fitQ <- t(lme_fitQ)
colnames(lme_fitQ) <- paste(rep('fitQ',(nSub*nbin)), 1:(nSub*nbin), sep="_", collapse = NULL)
lme_fitQ <- cbind(rownames(lme_fitQ), lme_fitQ)
colnames(lme_fitQ)[1] <- c("key")
lme_fitQ <- as_tibble(lme_fitQ)

# merge
Output_mat <- lme_stat2 %>%  
  merge(., trends,  by = "key") %>%
  merge(., lme_fitL,  by = "key") %>%
  merge(., lme_fitQ,  by = "key")


Output_mat <- as_tibble(Output_mat)

Output_mat$Df_Intercept  <- as.character(Output_mat$Df_Intercept)
Output_mat$Df_L  <- as.character(Output_mat$Df_L)
Output_mat$Df_Q  <- as.character(Output_mat$Df_Q)
Output_mat$Chisq_L  <- as.character(Output_mat$Chisq_L)
Output_mat$Chisq_Q  <- as.character(Output_mat$Chisq_Q)
Output_mat$P_L  <- as.character(Output_mat$P_L)
Output_mat$P_Q  <- as.character(Output_mat$P_Q)

write.csv(Output_mat, str_c(filedir, filename, '_R_statistics','.csv'),row.names = FALSE, na="")

# 
# #
# Now the complete regression analysis ------------------------------------
# we sequentially put the predictors of behavioural performance in a hierarchical model, to investigate which predictors improve model fit, over and above that of the previous predictor

# here we can only use the subjects that have complete data, so we delete subjects with NA values in CPP_onset
probeColumns = c('CPP_onset')
reduced_data <- data_p_level %>%
  dplyr::select( 1:3, one_of("RT"), one_of("RT_CV"),
          one_of("alpha"),
          one_of("N2c_latency"), one_of("N2c_amplitude"), one_of("N2i_latency"), one_of("N2i_amplitude"),
          one_of("CPP_onset"), one_of("CPP_csd_slope2"), one_of("CPPr_csd_amplitude"), one_of("CPP_ITPC"),
          one_of("preRespBeta_baseAT"), one_of("preRespBeta_slope"))

reduced_data <- plyr::ddply(reduced_data, "Subject",
                            function(df)if(any(is.na(df[, probeColumns]))) NULL else df)

reduced_data$Bin <- as.numeric(reduced_data$Bin)
# test the sequential addition of each variable and see which ones explain a significant part of the data
model.baseline    <- lme4::lmer(RT ~ Bin + (Bin|Subject), data = reduced_data, na.action = na.omit, REML=FALSE) # baseline model to compare the effect of bin to
model.alpha             <- update(model.baseline, .~. + alpha)#
model.N2c_lat           <- update(model.alpha, .~. + N2c_latency)#
model.N2c_amp           <- update(model.N2c_lat, .~. + N2c_amplitude)#
model.N2i_lat           <- update(model.N2c_amp, .~. + N2i_latency)#
model.N2i_amp           <- update(model.N2i_lat, .~. + N2i_amplitude)#
model.CPP_onset         <- update(model.N2i_amp, .~. + CPP_onset)#
model.CPP_slope         <- update(model.CPP_onset, .~. + CPP_csd_slope2)#
model.CPP_ampl          <- update(model.CPP_slope, .~. + CPPr_csd_amplitude)#
model.CPP_ITPC          <- update(model.CPP_ampl, .~. + CPP_ITPC)#
model.preRespBeta_slope <- update(model.CPP_ITPC, .~. + preRespBeta_slope)#
model.preRespBeta       <- update(model.preRespBeta_slope, .~. + preRespBeta_baseAT)#

# check correlation between variables
corrmat <- cov2cor(vcov(model.preRespBeta))
corrmat <- corrmat[2:nrow(corrmat),2:ncol(corrmat)]
idx <- (abs(corrmat)>0.25 & abs(corrmat)<1)

t(t(apply(idx, 1, function(u) paste( names(which(u)), collapse=", " ))))
corrmat[idx]

anova(model.baseline, model.alpha, model.N2c_lat, model.N2c_amp, model.N2i_lat, model.N2i_amp, model.CPP_onset, model.CPP_slope, model.CPP_ampl, model.CPP_ITPC, model.preRespBeta_slope, model.preRespBeta)

# add the variables that explained a significant part of the RT in a full model to see which ones add independent info
# Only those signals that explained unique variation in RT were then selected for forced input into a final simplified RT model,
# to obtain accurate parameter estimates not influenced by other signals shown not improve model fit

# # load participant level data
if (bin2use=='pupil_lp_baseline_regress_iti_side') {
  # Pupil baseline
  model.full_RT    <- lmerTest::lmer(RT ~ Bin + N2c_amplitude + CPP_onset + CPP_csd_slope2 + CPP_ITPC + (Bin|Subject), data = reduced_data, na.action = na.omit, REML=FALSE) # baseline model to compare the effect of bin to
}
if (bin2use=='GLM_pupil_Ramp_stim_regress_bl_iti_side') {
  # Pupil response
  model.full_RT    <- lmerTest::lmer(RT ~ Bin + alpha + CPP_onset + CPP_ITPC + preRespBeta_base + (Bin|Subject), data = reduced_data, na.action = na.omit, REML=FALSE) # baseline model to compare the effect of bin to
}
if (bin2use=='GLM_pupil_Ramp_stim_regress_bl_blPhase_iti_side') {
  # Pupil response
  model.full_RT    <- lmerTest::lmer(RT ~ Bin + alpha + CPP_onset + CPP_csd_slope2 + CPP_ITPC + (Bin|Subject), data = reduced_data, na.action = na.omit, REML=FALSE) # baseline model to compare the effect of bin to
}
library(broom)
summary(model.full_RT)
kable(tidy(model.full_RT),digits = 3)

# Stepwise Regression
library(MASS)
step <- lmerTest::step(model.full_RT, direction="both")
step # display results

if (bin2use=='pupil_lp_baseline_regress_iti_side') {
  # forward/backward stepwise model excluded CPP onset as a predictor adding any unique information, so we run the full model again without CPP onset
  model.full_baseline    <- lmerTest::lmer(RT ~ Bin + (Bin|Subject), data = reduced_data, na.action = na.omit, REML=FALSE) # baseline model to compare the effect of bin to
  model.full_pred    <- update(model.full_baseline, .~. + N2c_amplitude + CPP_ITPC) # baseline model to compare the effect of bin to
  anova(model.full_baseline, model.full_pred)
  # model.full_pred <- as(model.full_pred,"merModLmerTest") # use the lmerTest package to obtain a p-value for the coefficients
}
if (bin2use=='GLM_pupil_Ramp_stim_regress_bl_blPhase_iti_side') {
  # forward/backward stepwise model excluded CPP onset as a predictor adding any unique information, so we run the full model again without CPP onset
  model.full_baseline    <- lmerTest::lmer(RT ~ Bin + (Bin|Subject), data = reduced_data, na.action = na.omit, REML=FALSE) # baseline model to compare the effect of bin to
  model.full_pred    <- update(model.full_baseline, .~. + alpha + CPP_ITPC) # baseline model to compare the effect of bin to
  anova(model.full_baseline, model.full_pred)
  # model.full_pred <- as(model.full_pred,"merModLmerTest") # use the lmerTest package to obtain a p-value for the coefficients
}
library(broom)
summary(model.full_pred)
kable(tidy(model.full_pred),digits = 3)
library(MuMIn)
r.squaredGLMM(model.full_pred)
# see https://jonlefcheck.net/2013/03/13/r2-for-linear-mixed-effects-models/ for an explanation of marginal and conditional R2

# N2c amplitude explains unique variance in RT when sorted by baseline pupil diameter, but does not display a significant coeffiecient, so we perform robust regression analysis

##------Bootstrapping------

confint(model.full_pred, level = 0.95,
        method = "boot",
        nsim = 5000,
        boot.type = c("perc","basic","norm"),
        FUN = NULL, quiet = FALSE,
        oldNames = TRUE
        )




############################################################################################
# do the same for RT variability
model.baseline    <- lme4::lmer(RT_CV ~ Bin + (Bin|Subject), data = reduced_data, na.action = na.omit, REML=FALSE) # baseline model to compare the effect of bin to
model.alpha             <- update(model.baseline, .~. + alpha)#
model.N2c_lat           <- update(model.alpha, .~. + N2c_latency)#
model.N2c_amp           <- update(model.N2c_lat, .~. + N2c_amplitude)#
model.N2i_lat           <- update(model.N2c_amp, .~. + N2i_latency)#
model.N2i_amp           <- update(model.N2i_lat, .~. + N2i_amplitude)#
model.CPP_onset         <- update(model.N2i_amp, .~. + CPP_onset)#
model.CPP_slope         <- update(model.CPP_onset, .~. + CPP_csd_slope2)#
model.CPP_ampl          <- update(model.CPP_slope, .~. + CPPr_csd_amplitude)#
model.CPP_ITPC          <- update(model.CPP_ampl, .~. + CPP_ITPC)#
model.preRespBeta_slope <- update(model.CPP_ITPC, .~. + preRespBeta_slope)#
model.preRespBeta       <- update(model.preRespBeta_slope, .~. + preRespBeta_baseAT)#
summary(model.preRespBeta)

anova(model.baseline, model.alpha, model.N2c_lat, model.N2c_amp, model.N2i_lat, model.N2i_amp, model.CPP_onset, model.CPP_slope, model.CPP_ampl, model.CPP_ITPC, model.preRespBeta_slope,model.preRespBeta)

model.full_RT_CV    <- lmerTest::lmer(RT_CV ~ Bin + CPP_ITPC + (Bin|Subject), data = reduced_data, na.action = na.omit, REML=FALSE) # baseline model to compare the effect of bin to
summary(model.full_RT_CV)

# Stepwise Regression
library(MASS)
# fit <- lm(RT_Asym~ Location + Sex + Age + PreAlphaAsym + N2c_Asym + N2c_latency_Asym + CPPonset_Asym + CPPslope_Asym + Beta_Asym + Beta_slope_Asym, data=participant_level)
step <- lmerTest::step(model.full_RT_CV, direction="both")
step # display results

model.full_baseline <- lmerTest::lmer(RT_CV ~ Bin + (Bin|Subject), data = reduced_data, na.action = na.omit, REML=FALSE) # baseline model to compare the effect of bin to
model.full_RT_CV    <- update(model.full_baseline, .~. + CPP_ITPC) # baseline model to compare the effect of bin to
anova(model.full_baseline, model.full_RT_CV)
summary(model.full_RT_CV)
kable(tidy(model.full_RT_CV),digits = 3)
r.squaredGLMM(model.full_RT_CV)

confint(model.full_RT_CV, level = 0.95,
        method = "boot",
        nsim = 5000,
        boot.type = c("perc","basic","norm"),
        FUN = NULL, quiet = FALSE,
        oldNames = TRUE
)


############################################################################################
# Check whether we made any wrong assumptions about the temporal order of EEG variables by adding them all into one model and check coefficients
############################################################################################

model.full_EEG    <- lmerTest::lmer(RT ~ Bin +
                                      alpha +
                                      N2c_latency +
                                      N2c_amplitude +
                                      N2i_latency +
                                      N2i_amplitude +
                                      CPP_onset +
                                      CPP_csd_slope2 +
                                      CPPr_csd_amplitude +
                                      CPP_ITPC +
                                      preRespBeta_slope +
                                      preRespBeta_baseAT +
                                      (Bin|Subject), data = reduced_data, na.action = na.omit, REML=FALSE) # baseline model to compare the effect of bin to
Output_mat <- as.data.frame(coef(summary(model.full_EEG)))

colnames_output <- colnames(Output_mat)
colnames_output[2] <- 'se'
colnames_output[4] <- 't'
colnames_output[5] <- 'p'
colnames(Output_mat) <- colnames_output

rownames_output = rownames(Output_mat)
Output_mat <- cbind(rownames_output, Output_mat)



Output_mat$Estimate <- as.character(Output_mat$Estimate)
Output_mat$se <- as.character(Output_mat$se)
Output_mat$df <- as.character(Output_mat$df)
Output_mat$t <- as.character(Output_mat$t)
Output_mat$p <- as.character(Output_mat$p)
write.csv(Output_mat, str_c(filedir, filename, '_R_statistics_RT','.csv'),row.names = FALSE, na="")

#

model.full_EEG    <- lmerTest::lmer(RT_CV ~ Bin +
                                      alpha +
                                      N2c_latency +
                                      N2c_amplitude +
                                      N2i_latency +
                                      N2i_amplitude +
                                      CPP_onset +
                                      CPP_csd_slope2 +
                                      CPPr_csd_amplitude +
                                      CPP_ITPC +
                                      preRespBeta_slope +
                                      preRespBeta_baseAT +
                                      (Bin|Subject), data = reduced_data, na.action = na.omit, REML=FALSE) # baseline model to compare the effect of bin to
Output_mat <- as.data.frame(coef(summary(model.full_EEG)))
colnames_output <- colnames(Output_mat)
colnames_output[2] <- 'se'
colnames_output[4] <- 't'
colnames_output[5] <- 'p'
colnames(Output_mat) <- colnames_output
Output_mat$Estimate <- as.character(Output_mat$Estimate)
Output_mat$se <- as.character(Output_mat$se)
Output_mat$df <- as.character(Output_mat$df)
Output_mat$t <- as.character(Output_mat$t)
Output_mat$p <- as.character(Output_mat$p)
rownames_output = rownames(Output_mat)
Output_mat <- cbind(rownames_output, Output_mat)
write.csv(Output_mat, str_c(filedir, filename, '_R_statistics_RTcv','.csv'),row.names = FALSE, na="")

# # # #
# # #
# ------------------------------------------------------------------------
# Now we will run the multilevel model for the single trial data
# ------------------------------------------------------------------------

# load data ---------------------------------------------------------------
# load single trial level data
filename = str_c('allSub_singleTrial_pupil_0.01_6Hz')

# filename = str_c('allSub_singleTrial_CSD(0)_selChCPP(0_1)_selChAlpha(2_4)_', pupilBl, 'bl_', pupilPre_t, 'pre_t' )
data_st = read_csv(str_c(filedir, filename,'.csv'))

# only select correct trials
data_st <- data_st %>%
  filter(allvalidtr_neg100_RT_200==1) %>%
  filter(Outcome==1)

# make factors out of some variables
data_st$ID   <- factor(data_st$Subject)
data_st$Subject   <- factor(data_st$Subject)
data_st$StimLoc   <- factor(data_st$StimLoc)
data_st$ITI   <- factor(data_st$ITI)

# first we define orthogonal polynomials in order to test for different trends in the data
data_st <- within(data_st, polyPupilResp <- poly(pupilResp,2))
data_st <- within(data_st, polyPupilBL <- poly(pupilBaseline,2))

# our model has a random intercept for each subject (repeated measrures analysis), as well as for stimulus location and iti.
model.Intercept     <- lmerTest::lmer(RT ~ 1 +
                                        (1|Subject) +
                                        (1|StimLoc) +
                                        (1|ITI) +
                                        Trial +
                                        blockTrial,
                                      data = data_st, na.action = na.omit, REML=FALSE) # baseline model to compare the effect of bin to.
model.PupilBL       <- update(model.Intercept, .~. + polyPupilBL[, 1])
model.PupilBLQ      <- update(model.PupilBL, .~. + polyPupilBL[, 2])
model.PupilResp     <- update(model.PupilBLQ, .~. + polyPupilResp[, 1])
model.PupilRespQ    <- update(model.PupilResp, .~. + polyPupilResp[, 2])

statstable <- anova(model.Intercept, model.PupilBL, model.PupilBLQ, model.PupilResp,model.PupilRespQ) #compare likelihood of models

Output_mat <- as.data.frame(coef(summary(model.PupilRespQ)))[4:7, ]

Output_mat <- cbind(
  statstable$Chisq[2:5], 
  statstable$`Pr(>Chisq)`[2:5], 
  Output_mat
)

colnames_output <- colnames(Output_mat)
colnames_output[1] <- 'X'
colnames_output[2] <- 'Xp'
colnames_output[3] <- 'B'
colnames_output[4] <- 'se'
colnames_output[6] <- 't'
colnames_output[7] <- 'p'
colnames(Output_mat) <- colnames_output

rownames_output = rownames(Output_mat)
rownames_output[1] <- 'BPD'
rownames_output[2] <- 'BPD2'
rownames_output[3] <- 'PR'
rownames_output[4] <- 'PR2'
Output_mat <- cbind(rownames_output, Output_mat)

Output_mat$X <- as.character(Output_mat$X)
Output_mat$Xp <- as.character(Output_mat$Xp)
Output_mat$B <- as.character(Output_mat$B)
Output_mat$se <- as.character(Output_mat$se)
Output_mat$df <- as.character(Output_mat$df)
Output_mat$t <- as.character(Output_mat$t)
Output_mat$p <- as.character(Output_mat$p)

write.csv(Output_mat, str_c(filedir, filename, '_R_statistics','.csv'),row.names = FALSE, na="")



