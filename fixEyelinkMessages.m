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
%
%Script written by Daniel Newman on 15/12/2014 to: 
% 1. load a participant' sEyelink .asc files collected by the Simon 
%    Kelly's dots paradigm 
% 2. edit the event messages so that they can be used in 
%    the pop_importeyetracker()to sync the EEG and eyelink data
% 3. save the participants edited eyelink data in a .mat file so
%    pop_importeyetracker() can use it 
%       
% NOTE: Requires that the Eyelink .asc files are saved Samples-And-Events combined
%       in the one file. 
% Also, see http://www2.hu-berlin.de/eyelab/index.php for the rest of the
% EYE-EEG functions, they are pretty nice!

%Load raw data from EyeLink, and save it in a .mat file
ET = parseeyelink(files(subIdx,iblock).ET_files,files(subIdx,iblock).ET_matfiles,'TRIAL'); %ET_files{f} and ET_matfiles{} are just the full directory/filenames for that participants' .asc file and to save the corresponding .mat ET file  
ET.messages= regexprep(ET.messages,'TRIAL(\d+)','TRIAL');%find ['TRIAL'-followed by one or more didgits '[0-9]'] and replace it with just 'TRIAL'
ET.messages=strrep(ET.messages, 'FIX_ON', ' ');%replaces all "FIX_ON" with a space
ET.messages=strrep(ET.messages, 'fixation_break', '28');%replaces "fixation_break" with "28"
ET.messages=strrep(ET.messages, '_', ' ');%replaces "_"  with a space

%Now replace the events in ET.event with the correct message from ET.messages" 
triggerKeyword='TRIAL';
test  = regexp(ET.messages,['MSG\s(\d+)\s+',triggerKeyword,'\s?(\d+)'],'tokens')';
test2 = [test{:}]';
test3 = cellfun(@str2double,test2,'UniformOutput',false);
ET.event = cell2mat(test3);

%find blinks/saccades

eventType1 = 'EBLINK';
eventType2 = 'ESACC';

side=[' L'];

test  = regexp(ET.messages,[eventType1, side,'\s?(\d+)','\s?(\d+)'],'tokens')';
test2 = [test{:}]';
test3 = cellfun(@str2double,test2,'UniformOutput',false);
tmp1 = cell2mat(test3);

test  = regexp(ET.messages,[eventType2, side,'\s\s?(\d+)','\s?(\d+)'],'tokens')';
test2 = [test{:}]';
test3 = cellfun(@str2double,test2,'UniformOutput',false);
tmp2 = cell2mat(test3);

tmp = [tmp1 ; tmp2];

if isempty(tmp)
    side=[' R'];
    
    test  = regexp(ET.messages,[eventType1, side,'\s?(\d+)','\s?(\d+)'],'tokens')';
    test2 = [test{:}]';
    test3 = cellfun(@str2double,test2,'UniformOutput',false);
    tmp1 = cell2mat(test3);
    
    test  = regexp(ET.messages,[eventType2, side,'\s\s?(\d+)','\s?(\d+)'],'tokens')';
    test2 = [test{:}]';
    test3 = cellfun(@str2double,test2,'UniformOutput',false);
    tmp2 = cell2mat(test3);
    
    tmp = [tmp1 ; tmp2];
end


if ~isempty(tmp)
    ET.eyelinkevent = [tmp(:,1) ones(size(tmp,1),1) ; tmp(:,2) ones(size(tmp,1),1)*2 ];
else
    ET.eyelinkevent=[];
end
ET.eyelinkevent = sortrows([ET.event ; ET.eyelinkevent]); %1 = start blink, 2 = end blink

%%
% GL: Make sure the time sample of each event exists in ET.data.
for i = 1:size(ET.event,1)
    % for each event get residuals of difference between ET.data and ET.event
    temp = abs(ET.data(:,1)-ET.event(i,1));
    [val,ix] = min(temp);
    % if there isn't the exact event, make it equal to the previous sample
    if val(1)>0
        ET.event(i,1) = ET.data(ix(1),1);
    end
end
%%

if isempty(ET.event)
    warning('\n\n%s(): The keyword string you have provided (''%s'') was not found in any ET.messages of the ET file (%s). Please check your ET.messages and make sure they contain the specified keyword - TRIAL.')
end
clear triggerKeyword test test2 test3

% FIND WHAT THE FIRST and FINAL SHARED EVENT TRIGGER AND SAVE IT TO USE 
% AS THE FIRST AND FINAL SYNC MARKER for pop_importeyetracker() to work on later
ET.first_event=ET.event(1,2); 
ET.last_event=ET.event(length(ET.event),2);

save(files(subIdx,iblock).ET_matfiles,'-struct','ET')
clear ET % delete the ET struct from memory as we no longer need it, the 
         % 'save' line above takes the individual variables out of the ET-struct 
         % and saves them individually into .mat file for pop_importeyetracker() to work on later




