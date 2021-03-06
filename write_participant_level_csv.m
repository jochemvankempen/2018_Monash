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
%% participant level csv
% sort and average data, write out to csv file for R analysis

clear pl* CPP* RT* N2* alpha* beta* pupil* filename_csv

plotCPP = 0; % if 1, then onset of CPP will be plotted for each subject and bin. This is relevant for debugging, sometimes CPP onset latency is not found correctly
scaleVariables = 0; % if 1, then variables will be scaled between 0-1, this is used for final hierarchical regression analysis
overwrite = 0;

% load some settings
setAnalysisSettings_bigDots
switch dataset
    case 'bigDots'
        getSubSpecs_bigDots
        getfilenames_bigDots
    case 'CD'
        getSubSpecs_CD
        getfilenames_CD
        
end

if ~exist([paths.pop 'binned' filesep], 'dir')
    mkdir([paths.pop 'binned' filesep])
end

% the variables to be sorted
types2check = {...
    'RT','RT_CV',...
    'N2c_amplitude','N2c_latency','N2i_amplitude','N2i_latency',...
    'CPP_onset','CPPr_slope','CPPr_csd_slope','CPPr_amplitude','CPPr_csd_amplitude',...
    'alpha','alpha_preTarget_topo',...
    'beta_base_response', 'beta_baseAT_response', 'beta_response_amplitude', 'beta_base_response_amplitude', 'beta_baseAT_response_amplitude', 'beta_pre_response_slope', 'beta_pretarget_amplitude', 'beta_baseAT_pretarget_amplitude', 'beta_base_pre_response_topo',...
    'pupil_lp_baseline', 'pupil_bp_baseline' , 'pupil_lp', 'pupil_lp_1Hz', 'pupil_bp', 'pupilr_lp',...
    'pupil_GLM_Ramp_yhat', 'pupil_conc_GLM_Ramp_yhat',...
    'CPP','CPPr','CPPr_csd','CPP_topo'...
    'N2c','N2i','N2c_topo',...
    'N2c_ITPC_bar','N2i_ITPC_bar','N2c_256_ITPC_bar','N2i_256_ITPC_bar','CPP_ITPC_bar','CPPr_ITPC_bar','CPP_csd_ITPC_bar','CPPr_csd_ITPC_bar',...
    'N2c_ITPC_band','N2i_ITPC_band','N2c_256_ITPC_band','N2i_256_ITPC_band','CPP_ITPC_band','CPPr_ITPC_band','CPP_csd_ITPC_band','CPPr_csd_ITPC_band',...
    'N2c_ITPC','N2i_ITPC','N2c_256_ITPC','N2i_256_ITPC','CPP_ITPC','CPPr_ITPC','CPP_csd_ITPC','CPPr_csd_ITPC',...
    };

for ibinType = 1:length(allBin2use)
    clear plevel*
    
    bin2use = allBin2use{ibinType};
    for itype = 1:length(types2check)
        clear type plot2make pVal normaliseData bar2plot topo2plot erp2plot asym2plot CPP_side_slope2 CPP_side_slope1 CPP_side_onsets plot2make
        clear tmp

        % check if exist, otherwise create
        savefilename = [paths.pop 'binned' filesep types2check{itype} '_side(' num2str(sideInfo) ')_bin(' num2str(nbin2use) ')_' bin2use '_' bintype '.mat'];

        type = types2check{itype};
        
        if exist(savefilename,'file') && ~overwrite
            fprintf('loading %s\n', savefilename)
            tmp = load(savefilename);
            eval([types2check{itype} '{ibinType} = tmp.binnedData;'])
        else
            binData_bigDots
            eval([types2check{itype} '{ibinType} = binnedData;'])
            save(savefilename, 'binnedData')
        end
    end
    
    if ~exist('plevelSub','var')
        type = 'none';
        % get variables plevelSub etc.
        binData_bigDots
    end
    %% scale variables for regression analysis, or not (set in scaleVariables)
    
    plevel_Subject  = reshape(plevelSub    , size(plevelSub,1)*size(plevelSub,2)*size(plevelSub,3), 1);
    plevel_Side     = reshape(plevelSide   , length(plevel_Subject), 1);
    plevel_Bin      = reshape(plevelBin    , length(plevel_Subject), 1);
    plevel_nTrial   = reshape(plevelnTrial , length(plevel_Subject), 1);
    
    for itype = 1:length(types2check)
        if eval(['ndims(' types2check{itype} '{ibinType} ) == 2;']) && eval(['size(' types2check{itype} '{ibinType} ,2) == nbin2use;'])
            if scaleVariables
                % yi=(xi-min xi) /(max xi-min xi). Across subjects
                scaletype = 'minmax';
                eval(['plevel_' types2check{itype} ' = scaleVar(reshape(' types2check{itype} ' {ibinType}  , length(plevel_Subject), 1), scaletype);']);
            else
                eval(['plevel_' types2check{itype} ' = reshape(' types2check{itype} ' {ibinType}  , length(plevel_Subject), 1);']);
            end
        end
    end
    
    %% write out to csv
    varNames = {...
        'Subject', 'Side', 'Bin', 'nTrial', ...
        'RT', 'RT_CV', ...
        'CPP_onset', 'CPP_slope2', 'CPP_csd_slope2', 'CPPr_amplitude', 'CPPr_csd_amplitude', ...
        'N2c_amplitude', 'N2c_latency', 'N2i_amplitude', 'N2i_latency', ...
        'alpha', ...
        'preRespBeta', 'preRespBeta_base', 'preRespBeta_baseAT', 'preRespBeta_slope', 'preTargBeta', 'preTargBetaAT', ...
        'pupil_bl_lp', 'pupil_bl_bp', ...
        'N2c_ITPC', 'N2i_ITPC', 'N2c_256_ITPC', 'N2i_256_ITPC', ...
        'CPP_ITPC', 'CPP_csd_ITPC', 'CPPr_ITPC', 'CPPr_csd_ITPC', ...
        };
    
    MAT = table(...
        plevel_Subject, plevel_Side, plevel_Bin, plevel_nTrial, ...
        plevel_RT, plevel_RT_CV, ...
        plevel_CPP_onset, plevel_CPPr_slope, plevel_CPPr_csd_slope, plevel_CPPr_amplitude, plevel_CPPr_csd_amplitude,  ...
        plevel_N2c_amplitude, plevel_N2c_latency, plevel_N2i_amplitude, plevel_N2i_latency, ...
        plevel_alpha, ...
        plevel_beta_response_amplitude, plevel_beta_base_response_amplitude, plevel_beta_baseAT_response_amplitude, plevel_beta_pre_response_slope,  plevel_beta_pretarget_amplitude, plevel_beta_baseAT_pretarget_amplitude, ...
        plevel_pupil_lp_baseline, plevel_pupil_bp_baseline, ...
        plevel_N2c_ITPC_bar, plevel_N2i_ITPC_bar, plevel_N2c_256_ITPC_bar, plevel_N2i_256_ITPC_bar, ...
        plevel_CPP_ITPC_bar, plevel_CPP_csd_ITPC_bar, plevel_CPPr_ITPC_bar, plevel_CPPr_csd_ITPC_bar, ...
        'VariableNames',varNames);
    
    [~,idx] = grep({bin2use},'GLM_pupil');
    if idx == 0
        filename_csv{ibinType} = [paths.pop 'participant_level_scaleVar(' num2str(scaleVariables) ')_side(' num2str(sideInfo) ')_bin(' num2str(nbin2use) ')_' bin2use '_' bintype fileExt_preprocess fileExt_CDT ];
    else
        filename_csv{ibinType} = [paths.pop 'participant_level_scaleVar(' num2str(scaleVariables) ')_side(' num2str(sideInfo) ')_bin(' num2str(nbin2use) ')_' bin2use '_' bintype fileExt_preprocess fileExt_CDT fileExt_GLM ];
    end
    
    writetable(MAT,[filename_csv{ibinType} '.csv'])
end















