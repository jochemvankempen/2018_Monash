% These scripts reproduce the analysis in the paper: van Kempen et al.,
% (2018) 'Behavioural and neural signatures of perceptual evidence
% accumulation are modulated by pupil-linked arousal'. 
% 
% Many of these scripts are based on the original scripts for the paper
% Newman et al. (2017), Journal of Neuroscience.
% https://github.com/gerontium/big_dots 
%
% Permission is hereby granted, free of charge, to any person obtaining
% a copy of this software and associated documentation files (the
% "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to
% permit persons to whom the Software is furnished to do so, subject to
% the following conditions:
% 
% The above copyright notice and this permission notice shall be
% included in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
% NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
% LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
% OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
% WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
% 
% Jochem van Kempen, 2018
% Jochemvankempen@gmail.com
% https://github.com/jochemvankempen/2018_Monash
%
% -------------------------------------------------------------------------

% sort and bin data

if ~exist('normaliseData','var')
    normaliseData=0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Select data to bin/sort %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
preTarget_validtrials = 0; % If 1, trials with artifacts between -500 and -100 ms before target onset will be excluded, e.g. for alpha analysis. Default 0, changed below if necessary
clear data2use tt t2test twin_bar
switch type
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% RT etc
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'RT'
        data2use    = allRT;
    case 'RT_CV'
        data2use    = allRT;
    case 'RT_zscore'
        data2use    = allRT_zscore;
    case 'RT_window'
        data2use    = allRTz_window;
        data2use(~allValidRT_window) = NaN;
        tt2use      = -5:5;
        t2test      = -5:1:5;
        twin_bar    = [-1 -1];
    case 'RTcv_window'
        data2use    = allRT_window;
        data2use(~allValidRT_window) = NaN;
                
        tt2use      = -5:5;
        t2test      = -5:1:5;
        twin_bar    = [-1 -1];
    case 'RTmin5'
        data2use    = allRTz_window;
        data2use(~allValidRT_window) = NaN;
        tt2use      = -5:5;
        data2use = squeeze(data2use(tt2use==-5,:))';
    case 'RTmin4'
        data2use    = allRTz_window;
        data2use(~allValidRT_window) = NaN;
        tt2use      = -5:5;
        data2use = squeeze(data2use(tt2use==-4,:))';
    case 'RTmin3'
        data2use    = allRTz_window;
        data2use(~allValidRT_window) = NaN;
        tt2use      = -5:5;
        data2use = squeeze(data2use(tt2use==-3,:))';
    case 'RTmin2'
        data2use    = allRTz_window;
        data2use(~allValidRT_window) = NaN;
        tt2use      = -5:5;
        data2use = squeeze(data2use(tt2use==-2,:))';
    case 'RTmin1'
        data2use    = allRTz_window;
        data2use(~allValidRT_window) = NaN;
        tt2use      = -5:5;
        data2use = squeeze(data2use(tt2use==-1,:))';
    case 'RT0'
        data2use    = allRTz_window;
        data2use(~allValidRT_window) = NaN;
        tt2use      = -5:5;
        data2use = squeeze(data2use(tt2use==0,:))';
    case 'RTplus1'
        data2use    = allRTz_window;
        data2use(~allValidRT_window) = NaN;
        tt2use      = -5:5;
        data2use = squeeze(data2use(tt2use==1,:))';
    case 'RTplus2'
        data2use    = allRTz_window;
        data2use(~allValidRT_window) = NaN;
        tt2use      = -5:5;
        data2use = squeeze(data2use(tt2use==2,:))';
    case 'RTplus3'
        data2use    = allRTz_window;
        data2use(~allValidRT_window) = NaN;
        tt2use      = -5:5;
        data2use = squeeze(data2use(tt2use==3,:))';
    case 'RTplus4'
        data2use    = allRTz_window;
        data2use(~allValidRT_window) = NaN;
        tt2use      = -5:5;
        data2use = squeeze(data2use(tt2use==4,:))';
    case 'RTplus5'
        data2use    = allRTz_window;
        data2use(~allValidRT_window) = NaN;
        tt2use      = -5:5;
        data2use = squeeze(data2use(tt2use==5,:))';
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% pupil
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case {'pupil_bp_baseline'}
        data2use    = allPupil_bp_baseline;    
    case {'pupil_lp_baseline'}
        data2use    = allPupil_lp_baseline;

    case 'pupil_lp'
        data2use    = allPupil_lp;
        tt2use      = t;
        t2test     = -500:50:1500;
        twin_bar    = [500 800];

    case 'pupil_bp'
        data2use    = allPupil_bp;
        tt2use      = t;
        t2test     = -500:50:1500;
        twin_bar    = [500 800];

    case {'pupilr_lp'}
        data2use    = allPupilr_lp;
        tt2use      = tr;
        t2test     = -1000:50:400;
        twin_bar    = [-200 0];
    case {'pupilr_bp'}
        data2use    = allPupilr_bp;
        tt2use      = tr;
        t2test     = -1000:50:400;
        twin_bar    = [-200 0];
        
    case 'pupil_lp_RT_neg200_200'
        data2use    = allPupil_lp_RT_neg200_200;
    case 'pupil_bp_RT_neg200_200'
        data2use    = allPupil_bp_RT_neg200_200;
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% CPP
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case {'CPP','CPP_onset'}
        data2use    = allCPP;
        tt2use      = t;
        t2test     = -100:10:900;
        twin_bar    = [300 400];
    case 'CPP_topo'
        data2use    = allCPP_topo;
    case 'CPPr'
        data2use    = allCPPr;
        tt2use      = tr;
        t2test      = -400:10:100;
        twin_bar    = [-100 100];
    case 'CPP_csd'
        data2use    = allCPP_csd;
        tt2use      = t;
        t2test     = -100:10:1400;
        twin_bar    = [300 400];
    case {'CPPr_csd','CPPr_csd_slope'}
        % CPP build-up rate was defined as the slope of a straight line fitted to the response-locked waveform (O�Connell et al., 2012; Kelly and O�Connell, 2013; Loughnane et al., 2016) with the time window defined individually for each participant as the 100ms prior to the maximum CPP amplitude pre-response.
        data2use    = allCPPr_csd;
        tt2use      = tr;
        t2test      = -400:10:100;
        twin_bar    = [-100 0];
%         twin_bar    = [-100 0];
    case {'CPPr_amplitude'}
        data2use    = allCPPr_csd;
        tt2use      = tr;
        twin_bar    = [-180 -80];
        twin_bar    = [-100 0];
%         twin_bar    = [-20 0];
    case {'CPP_ITPC','CPP_ITPC_bar','CPP_ITPC_band'}
        data2use    = allCPP_phase;
        tt2use      = (SPG_times*1000) + t(1);
        ff2use      = SPG_freq;
        switch datatype
            case {'ITPC','ITPC_bar'}
                t2test      = [300 550];
            case 'ITPC_band'
                t2test      = [-200 1000];
        end
        f2test      = [0 4];
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% N2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'N2c'
        data2use    = allN2c;
        tt2use      = t;
        t2test      = -100:10:500;
        twin_bar    = [200 300];
    case 'N2i'
        data2use    = allN2i;
        tt2use      = t;
        t2test      = -100:10:500;
        twin_bar    = [300 400];   
    case 'N2c_amplitude'
        % N2-amplitude was measured as the mean amplitude inside a 100ms window centred on the stimulus-locked grand average peak (N2c: 266ms; N2i: 340ms, Loughnane et al., 2016)
        data2use    = allN2c;
        tt2use      = t;
        t2test      = 266 + [-50 50];
    case 'N2c_latency'
        % N2-latency was then identified as the time-point with the most negative amplitude value in the stimulus-locked waveform between 150-400ms for the N2c and 200-450ms for N2i
        data2use    = allN2c;
        tt2use      = t;
        t2test      = [150 400];

    case {'N2c_ITPC','N2c_ITPC_bar','N2c_ITPC_band'}
        data2use    = allN2c_phase;
        tt2use      = (SPG_times*1000) + t(1);
        ff2use      = SPG_freq;
        switch datatype
            case 'ITPC_bar'
                t2test      = [200 400];
            case 'ITPC_band'
                t2test      = [-200 1000];
        end
        f2test      = [0 4];

    case {'N2c_256_ITPC','N2c_256_ITPC_bar','N2c_256_ITPC_band'}
        data2use    = allN2c_256_phase;
        tt2use      = (SPG_times256*1000) + t(1);
        ff2use      = SPG_freq256;
        switch datatype
            case 'ITPC_bar'
                t2test      = [150 200];
            case 'ITPC_band'
                t2test      = [-200 1000];
        end
        f2test      = [3 4];        
    case 'N2i_amplitude'
        data2use    = allN2i;
        tt2use      = t;
        t2test      = 340 + [-50 50];
    case 'N2i_latency'
        data2use    = allN2i;
        tt2use      = t;
        t2test      = [200 450];
    case {'N2i_ITPC','N2i_ITPC_bar','N2i_ITPC_band'}
        data2use    = allN2i_phase;
        tt2use      = (SPG_times*1000) + t(1);
        ff2use      = SPG_freq;
        switch datatype
            case 'ITPC_bar'
                t2test      = [200 450];
            case 'ITPC_band'
                t2test      = [-200 1000];
        end
        f2test      = [0 4];
    case 'N2c_topo'
        data2use    = allN2c_topo;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% alpha
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'alpha_asym'
        preTarget_validtrials = 1;
        data2use    = allAlphaAsym_preTarget;
        
    case 'alpha'
        preTarget_validtrials = 1;
        data2use    = allAlpha_preTarget;
    case 'alpha_preTarget_topo'
        preTarget_validtrials = 1;
        data2use    = allAlpha_preTarget_topo;
        
    case 'alpha_asym_topo'
        preTarget_validtrials = 1;
        data2use    = allAlphaAsym_preTarget_topo;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% beta
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    case 'beta'
        data2use    = allBeta_postTarget;
        tt2use      = stft_times;
        t2test      = -500:50:700;
        twin_bar    = [400  600];
    case 'beta_response'
        data2use    = allBeta_preResponse;
        tt2use      = stft_timesr;
        t2test      = -500:10:100;
        twin_bar    = [-100 0];
    case 'beta_response_mean'
        data2use    = allBeta_preResponse_mean;
    case 'beta_pre_response_topo'
        data2use    = allBeta_preResponse_topo;
    case 'beta_pre_response_slope'
        data2use    = allBeta_preResponse;
        tt2use      = stft_timesr;
        t2test      = [-300 0];
        twin_bar    = [-100 0];
end

try
    disp(['sorting ' type ' data accoriding to ' bin2use ' in ' num2str(nbin2use) ' bins, for ' num2str(sideInfo) ' stimulus sides'])
catch
    disp(['sorting ' type ' data accoriding to ' bin2use ' in ' num2str(nbin2use) ' bins'])
end

switch dataset
    case 'CD'
        iti2change = [4 7 10];
        for  iti = 1:3
            allItitr(allItitr == iti2change(iti)) = iti;
        end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Loop over subjects and bin data %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear tIdx trIdx binningVariable binningData binning2use binnedData asym2plot img2plot
%%
for isub = 1:nSub
    itmpsub         = single_participants(isub);
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Define the binning trial index %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % note, this is overwritten below when sorting by e.g. alpha
    if (preTarget_validtrials == 1)
        validtr2use = allvalidtr_neg500_RT_200;
    else
        validtr2use = allvalidtr_neg100_RT_200;
    end
    
    trIdx = allSubject==isub & validtr2use;
    
    switch bin2use
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Baseline pupil 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                   
        case 'pupil_bp_baseline_regress_iti_side'
            
            designM = [ones(size(allPupil_bp_baseline(trIdx))) allItitr(trIdx) allSideStimtr(trIdx)]; %
            [b, ~, resid] = regress(allPupil_bp_baseline(trIdx), designM);
            binningVariable = resid;
            
            if 0 
                % Different way of regression, where we specifically
                % identify categorical variables, leads to exactly the same
                % result as using the function regress.m 
                LM = fitlm([allItitr(trIdx) allSideStimtr(trIdx)], allPupil_bp_baseline(trIdx), 'y ~ x1+x2', 'CategoricalVars', [1 2]);
                [resid LM.Residuals.Raw]
                
            end

        case 'pupil_lp_baseline_regress_iti_side'
            
            designM = [ones(size(allPupil_lp_baseline(trIdx))) allItitr(trIdx) allSideStimtr(trIdx)]; %
            [b, ~, resid] = regress(allPupil_lp_baseline(trIdx), designM);
            binningVariable = resid;
                       
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% pupil, linear projection
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
        case 'pupil_bp_linproj_resp_locked_neg500_200_regress_bl_iti_side'

            designM = [ones(size(allPupil_bp_linproj_resp_locked_neg500_200(trIdx))) allPupil_bp_baseline(trIdx) allItitr(trIdx) allSideStimtr(trIdx)]; 
            [b, ~, resid] = regress(allPupil_bp_linproj_resp_locked_neg500_200(trIdx), designM);
            binningVariable = resid;

        case 'pupil_lp_linproj_resp_locked_neg500_200_regress_bl_iti_side'

            designM = [ones(size(allPupil_lp_linproj_resp_locked_neg500_200(trIdx))) allPupil_lp_baseline(trIdx) allItitr(trIdx) allSideStimtr(trIdx)]; 
            [b, ~, resid] = regress(allPupil_lp_linproj_resp_locked_neg500_200(trIdx), designM);
            binningVariable = resid;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% pupil, average around RT
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
        case 'pupil_lp_RT_neg200_200_regress_bl_iti_side'

            designM = [ones(size(allPupil_lp_RT_neg200_200(trIdx))) allPupil_lp_baseline(trIdx) allItitr(trIdx) allSideStimtr(trIdx)];
            [b, ~, resid] = regress(allPupil_lp_RT_neg200_200(trIdx), designM);
            binningVariable = resid;
        case 'pupil_bp_RT_neg200_200_regress_bl_iti_side'

            designM = [ones(size(allPupil_bp_RT_neg200_200(trIdx))) allPupil_bp_baseline(trIdx) allItitr(trIdx) allSideStimtr(trIdx)];
            [b, ~, resid] = regress(allPupil_bp_RT_neg200_200(trIdx), designM);
            binningVariable = resid;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Other
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
        case 'timeOnTask'
            binningVariable = allTrial(trIdx,1);
        
        case 'RT'
            binningVariable = allRT(trIdx,1);

        case 'pretarget_alpha'
            validtr2use = allvalidtr_neg500_RT_200;
            trIdx = allSubject==isub & validtr2use;

            binningVariable = allAlpha_preTarget(trIdx,1);

        case 'pretarget_alpha_asym'
            validtr2use = allvalidtr_neg500_RT_200;
            trIdx = allSubject==isub & validtr2use;

            binningVariable = allAlphaAsym_preTarget(trIdx,1);

        case 'N2i_amplitude_regress_iti_side'
            
            % n2i time window
            tmp_t2test = 340 + [-50 50];
            tIdx       = find(t>=tmp_t2test(1) & t<=tmp_t2test(2));
            [minN2i]   = mean(allN2i(tIdx,:))';           
            
            designM = [ones(size(minN2i(trIdx))) allItitr(trIdx) allSideStimtr(trIdx)];
            [b, ~, resid] = regress(minN2i(trIdx), designM);            
            binningVariable = resid;

        case 'none'
            binningVariable = (allSubject==isub & validtr2use );
        otherwise
            clear binningVariable
            warning('No binning variable defined')
            
    end
    
    %%% bin the data
    binningData = nan(length(allSubject),1);
    binningData(trIdx) = binningVariable;
    
    binning2use = nan(length(allSubject),1);
    [binEdges, binning2use(trIdx), ~] = binVal(binningData(trIdx,1), nbin2use, bintype);
    binning2use(isnan(binning2use)) = 0;
    
    if normaliseData
        gscale = max(max(data2use(:,trIdx)));
        data2use(:,trIdx) = data2use(:,trIdx)/gscale*100;
    end
    
    clear trIdx
    %%
    %%%%%%%%%%%%%%%%%%%
    %%% Bin the data %%
    %%%%%%%%%%%%%%%%%%%
    switch datatype  
        %%
        case 'erp'
            
            if isub == 1
                binnedData = NaN(nSub, nbin2use, sideInfo, size(data2use,1));
            end
            switch type
                case 'RTcv_window'                   
                    for ibin = 1:nbin2use
                        for isideStim = 1:sideInfo
                            if sideInfo > 1
                                trIdx = (allSideStimtr==isideStim);
                                binnedData(isub, ibin, isideStim, :) = squeeze(nanstd(data2use(:,(binning2use==ibin)& trIdx),[],2)) ./ squeeze(nanmean(data2use(:,(binning2use==ibin)& trIdx),2));
                            else
                                binnedData(isub, ibin, isideStim, :) = squeeze(nanstd(data2use(:,(binning2use==ibin)),[],2)) ./ squeeze(nanmean(data2use(:,(binning2use==ibin)),2));
                            end
                        end
                    end
                    
                otherwise
                    for ibin = 1:nbin2use
                        for isideStim = 1:sideInfo
                            if sideInfo > 1
                                trIdx = (allSideStimtr==isideStim);
                                binnedData(isub, ibin, isideStim, :) = squeeze(mean(data2use(:,(binning2use==ibin)& trIdx),2));
                            else
                                binnedData(isub, ibin, isideStim, :) = squeeze(nanmean(data2use(:,(binning2use==ibin)),2));
                            end
                        end
                    end
            end
            
        case 'bar'
            %%
            if isub == 1
                binnedData = NaN(nSub, nbin2use, sideInfo);
            end
            switch type
                case {'RT_CV'}
                    for ibin = 1:nbin2use
                        for isideStim = 1:sideInfo
                            if sideInfo > 1
                                trIdx = (allSideStimtr==isideStim);
                                binnedData(isub, ibin, isideStim) = squeeze(std(data2use((binning2use==ibin) & trIdx))) / squeeze(mean(data2use((binning2use==ibin) & trIdx)));
                            else
                                binnedData(isub, ibin, isideStim) = squeeze(std(data2use(binning2use==ibin))) / squeeze(mean(data2use(binning2use==ibin)));
                            end
                        end
                    end
                    
                case {'beta_pre_response_slope'}
                    clear tmp
                    for ibin = 1:nbin2use
                        for isideStim = 1:sideInfo
                            if sideInfo > 1
                                trIdx = (allSideStimtr==isideStim);
                                tmp(isub, ibin, isideStim, :) = squeeze(mean(data2use(:,(binning2use==ibin) & trIdx),2));
                            else
                                tmp(isub, ibin, isideStim, :) = squeeze(mean(data2use(:,(binning2use==ibin)),2));
                            end
                            
                            [~,slope_timeframe_index(1)] = min(abs(tt2use - t2test(1)));%
                            [~,slope_timeframe_index(2)] = min(abs(tt2use - t2test(2)));%
                            
                            coef = polyfit(tt2use(slope_timeframe_index(1):slope_timeframe_index(2)),squeeze((tmp(isub, ibin, isideStim, slope_timeframe_index(1):slope_timeframe_index(2))))',1);% coef gives 2 coefficients fitting r = slope * x + intercept
                            binnedData(isub, ibin, isideStim)=coef(1);

                        end
                    end
                    
                case {'N2c_latency','N2i_latency'}
                    for ibin = 1:nbin2use
                        for isideStim = 1:sideInfo
                            tIdx    = find(tt2use>t2test(1) & tt2use<t2test(2));
                            if sideInfo > 1
                                trIdx = (allSideStimtr==isideStim);
                                tmpdat  = squeeze(mean(data2use(tIdx,(binning2use==ibin) & trIdx),2));
                            else
                                tmpdat  = squeeze(mean(data2use(tIdx,(binning2use==ibin)),2));
                            end
                            [minN2, minTime]   = min(tmpdat);
                            binnedData(isub, ibin, isideStim) = tt2use(tIdx(minTime));

                        end
                    end
                                        
                case {'N2c_amplitude','N2i_amplitude'}
                    for ibin = 1:nbin2use
                        for isideStim = 1:sideInfo
                            
                            tIdx    = find(tt2use>t2test(1) & tt2use<t2test(2));
                            if sideInfo > 1
                                trIdx = (allSideStimtr==isideStim);
                                binnedData(isub, ibin, isideStim)  = squeeze(mean(mean(data2use(tIdx,(binning2use==ibin)& trIdx),1),2));
                            else
                                binnedData(isub, ibin, isideStim)  = squeeze(mean(mean(data2use(tIdx,(binning2use==ibin)),1),2));
                            end
                        end
                    end
                    
                case {'RT_window','N2c','N2i','CPP','CPPr_csd','CPPr_amplitude' ,'beta', 'beta_base', 'pupil_lp','pupilr_lp','pupil_bp','pupilr_bp'}
                    % get average data in time window from time series data
                    tIdx = (tt2use>=twin_bar(1) & tt2use<=twin_bar(2));
                    
                    for ibin = 1:nbin2use
                        for isideStim = 1:sideInfo
                            if sideInfo > 1
                                trIdx = (allSideStimtr==isideStim);
                                binnedData(isub, ibin, isideStim) = squeeze(mean(mean(data2use(tIdx,(binning2use==ibin) & trIdx),1),2));
                            else
                                binnedData(isub, ibin, isideStim) = squeeze(nanmean(nanmean(data2use(tIdx,binning2use==ibin),1),2));
                            end
                        end
                    end
                    
                otherwise
                    for ibin = 1:nbin2use
                        for isideStim = 1:sideInfo
                            if sideInfo > 1
                                trIdx = (allSideStimtr==isideStim);
                                binnedData(isub, ibin, isideStim) = squeeze(mean(data2use((binning2use==ibin) & trIdx),1));
                            else
                                binnedData(isub, ibin, isideStim) = squeeze(nanmean(data2use(binning2use==ibin),1));
                            end
                        end
                    end
                    
            end
            
            %% TOPO
        case 'topo'
            if isub == 1
                binnedData = NaN(nSub, nbin2use, size(data2use,1));
            end
            switch type
                case {'N2c_topo'}
                    if isub == 1
                        binnedData = NaN(nSub, nbin2use, 2, size(data2use,1));
                    end
                    for ibin = 1:nbin2use
                        trIdx1 = (allSideStimtr==1);
                        trIdx2 = (allSideStimtr==2);
                        binnedData(isub, ibin, 1, :) = squeeze(mean(data2use(:,(binning2use==ibin) & trIdx1),2));
                        binnedData(isub, ibin, 2, :) = squeeze(mean(data2use(:,(binning2use==ibin) & trIdx2),2));
                    end
                otherwise
                    for ibin = 1:nbin2use
                        binnedData(isub, ibin, :) = squeeze(mean(data2use(:,binning2use==ibin),2));
                    end
            end
            
            %% CPP
        case 'CPP'
            switch type
                case 'CPP_onset'
                    if isub == 1
                        binnedData = NaN(nSub, nbin2use, sideInfo);
                    end
                    tmpbinnedData = cell(nbin2use, sideInfo);
                    
                    for ibin = 1:nbin2use
                        for isideStim = 1:sideInfo
                            if sideInfo > 1
                                trIdx = (allSideStimtr==isideStim);
                                tmpbinnedData{ibin, isideStim} = squeeze(data2use(:,(binning2use==ibin)& trIdx));
                            else
                                tmpbinnedData{ibin, isideStim} = squeeze(data2use(:,(binning2use==ibin)));
                            end
                            
                            % get specific CPP settings
                            % Because of binning procedure, we don't find
                            % an onset latency for each subject/bin
                            switch dataset
                                case 'bigDots'
                                    CPPonset_settings_bigDots
                                case 'CD'
                                    % CPP_settings_CD
                                    win_mean_change = 0;
                                    consecutive_windows=15;%15 works well for everybody else
                            end
                            
                            if plotCPP
                                disp([num2str(isub) ' ' subject_folder{itmpsub}])
                            end
                            
                            [binnedData(isub,ibin,isideStim), starttime] = getOnsetCPP(tmpbinnedData{ibin,isideStim}, subject_folder{itmpsub}, t, CPP_search_t, max_search_window, win_mean_change, consecutive_windows, plotCPP,'CPP');
                            
                        end
                    end
                case {'CPPr_slope', 'CPPr_csd_slope'}
                    
                    if isub == 1
                        binnedData = NaN(nSub, nbin2use, sideInfo);
                    end
                    tmpbinnedData = NaN(nbin2use, sideInfo, size(data2use,1));
                    
                    for ibin = 1:nbin2use
                        for isideStim = 1:sideInfo
                            if sideInfo > 1
                                trIdx = (allSideStimtr==isideStim);
                                tmpbinnedData(ibin, isideStim, :) = squeeze(mean(data2use(:,(binning2use==ibin)& trIdx),2));
                            else
                                tmpbinnedData(ibin, isideStim, :) = squeeze(mean(data2use(:,(binning2use==ibin)),2));
                            end
                        end
%                         [CPP_side_slope1(isub,ibin,:)]       = getSlopeCPP(squeeze(tmpbinnedData(isub,ibin,:,:)), sideInfo, subject_folder{itmpsub}, tr,side_tags, plotCPP,1);
                        [binnedData(isub,ibin,:)]       = getSlopeCPP(squeeze(tmpbinnedData(ibin,:,:)), sideInfo, subject_folder{itmpsub}, tr,side_tags, plotCPP,2);
                        
                    end
            end
            
        case 'ITPC'
            if isub == 1
                binnedData = NaN(nSub, nbin2use, sideInfo, size(data2use,1), size(data2use,2));
            end
            
            for ibin = 1:nbin2use
                for isideStim = 1:sideInfo
                    if sideInfo > 1
                        trIdx = (allSubject==isub & allSideStimtr==isideStim);
                        binnedData(isub,ibin,isideStim,:,:) = squeeze(abs(mean(exp(1i*(data2use(:, :, (binning2use==ibin) & trIdx ))),3)));
                        
                        if ~isempty(find(isnan(binnedData)))
                            keyboard
                        end
                    else
                        
                        binnedData(isub,ibin,isideStim,:,:) = squeeze(abs(mean(exp(1i*(data2use(:, :, (binning2use==ibin) ))),3)));
                        
                        if ~isempty(find(isnan(binnedData(isub,ibin,isideStim,:,:))))
                            keyboard
                        end
                    end
                end
            end
        case 'ITPC_band'
            if isub == 1
                binnedData = NaN(nSub, nbin2use, sideInfo, size(data2use,1));
            end
            
            clear tmp
            for ibin = 1:nbin2use
                for isideStim = 1:sideInfo
                    if sideInfo > 1
                        trIdx = (allSideStimtr==isideStim);
%  
                        tmp = squeeze(abs(mean(exp(1i*(data2use(:, :, (binning2use==ibin) & trIdx ))),3)));

                        [~,f2plot(1)] = min(abs(f2test(1) - SPG_freq));
                        [~,f2plot(2)] = min(abs(f2test(2) - SPG_freq));

                        binnedData(isub,ibin,isideStim,:) = mean(tmp(:,f2plot(1):f2plot(2)),2);
                        
                        if ~isempty(find(isnan(binnedData(isub,ibin,isideStim,:))))
                            keyboard
                        end

                    else
                        
                        tmp = squeeze(abs(mean(exp(1i*(data2use(:, :, (binning2use==ibin) ))),3)));

                        [~,f2plot(1)] = min(abs(f2test(1) - SPG_freq));
                        [~,f2plot(2)] = min(abs(f2test(2) - SPG_freq));

                        binnedData(isub,ibin,isideStim,:) = mean(tmp(:,f2plot(1):f2plot(2)),2);
                        
                        if ~isempty(find(isnan(binnedData(isub,ibin,isideStim,:))))
                            keyboard
                        end
                    end
                end
            end

        case 'ITPC_bar'
            if isub == 1
                binnedData = NaN(nSub, nbin2use, sideInfo);
            end
            
            clear tmp
            for ibin = 1:nbin2use
                for isideStim = 1:sideInfo
                    if sideInfo > 1
                        trIdx = (allSideStimtr==isideStim);
 
                        
                        tmp = squeeze(abs(mean(exp(1i*(data2use(:, :, (binning2use==ibin) & trIdx ))),3)));

                        [~,f2plot(1)] = min(abs(f2test(1) - SPG_freq));
                        [~,f2plot(2)] = min(abs(f2test(2) - SPG_freq));
                        
                        [~,t2plot(1)] = min(abs(t2test(1) - tt2use));
                        [~,t2plot(2)] = min(abs(t2test(2) - tt2use));

                        binnedData(isub,ibin,isideStim) = mean(mean(tmp(t2plot(1):t2plot(2),f2plot(1):f2plot(2)),1),2);
                        
                        if ~isempty(find(isnan(binnedData(isub,ibin,isideStim))))
                            keyboard
                        end

                    else
                        
                        tmp = squeeze(abs(mean(exp(1i*(data2use(:, :, (binning2use==ibin) ))),3)));

                        [~,f2plot(1)] = min(abs(f2test(1) - SPG_freq));
                        [~,f2plot(2)] = min(abs(f2test(2) - SPG_freq));
                        
                        [~,t2plot(1)] = min(abs(t2test(1) - tt2use));
                        [~,t2plot(2)] = min(abs(t2test(2) - tt2use));

                        binnedData(isub,ibin,isideStim) = mean(mean(tmp(t2plot(1):t2plot(2),f2plot(1):f2plot(2)),1),2);
                        
                        if ~isempty(find(isnan(binnedData(isub,ibin,isideStim))))
                            keyboard
                        end
                    end
                end
            end
        otherwise
            error('data type not defined')
    end
    
    % Get matrix with subject number, trial number, stimulus side and bin
    % number to write to csv file
    for ibin = 1:nbin2use
        for isideStim = 1:sideInfo
            if sideInfo > 1
                trIdx = (allSideStimtr==isideStim);
                plevelSub(isub, ibin, isideStim) = isub;
                plevelnTrial(isub, ibin, isideStim) = length(find((binning2use==ibin) & trIdx));
                plevelSide(isub, ibin, isideStim) = isideStim;
                plevelBin(isub, ibin, isideStim) = ibin;
            else
                plevelSub(isub, ibin, isideStim) = isub;
                plevelnTrial(isub, ibin, isideStim) = length(find((binning2use==ibin)));
                plevelSide(isub, ibin, isideStim) = isideStim;
                plevelBin(isub, ibin, isideStim) = ibin;
            end
        end
    end
    
end