function [sts, data]=pspm_get_gaze_y_r(import)
% SCR_GET_GAZE_Y_R is a common function for importing eyelink data
% (gaze_y_r data)
%
% FORMAT:
%   [sts, data]=pspm_get_gaze_y_r(import)
%   with import.data: column vector of waveform data
%        import.sr: sample rate
%  
%__________________________________________________________________________
% PsPM 3.1
% (C) 2015 Tobias Moser (University of Zurich)

% $Id: pspm_get_gaze_y_r.m 377 2016-10-31 15:57:10Z tmoser $
% $Rev: 377 $

global settings;
if isempty(settings), pspm_init; end;

% initialise status
sts = -1;

% assign respiratory data
data.data = import.data(:);

% add header
data.header.chantype = 'gaze_y_r';
data.header.units = import.units;
data.header.sr = import.sr;

% check status
sts = 1;
