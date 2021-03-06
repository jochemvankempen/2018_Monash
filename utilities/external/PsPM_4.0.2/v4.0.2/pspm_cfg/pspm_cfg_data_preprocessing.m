function [cfg] = pspm_cfg_data_preprocessing
% function [cfg] = pspm_cfg_data_preprocessing
%
% Matlabbatch menu for data preprocessing
%__________________________________________________________________________
% PsPM 3.1
% (C) 2016 Tobias Moser (University of Zurich)

% $Id: pspm_cfg_data_preprocessing.m 377 2016-10-31 15:57:10Z tmoser $
% $Rev: 377 $

%% Data preprocessing
cfg        = cfg_repeat;
cfg.name   = 'Data preprocessing';
cfg.tag    = 'data_preprocessing';
cfg.values = {pspm_cfg_pp_heart_period, pspm_cfg_resp_pp, pspm_cfg_pp_pupil, pspm_cfg_pp_emg};
cfg.forcestruct = true;
cfg.help   = {'Help: Data preprocessing'};