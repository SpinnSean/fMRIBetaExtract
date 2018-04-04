function condata=ExtractBetasV2(taspath, conpath, roipath, usercons, task)
% Extracts beta differences from contrast images
% taspath = path of directory containing all participant data for that task
% conpath = path of directory used as template (note every participant must 
%           contain the same contrast names for this to work i.e. the contrast
%           file names are the same for every participant (each has his own copy).
% roipath = path to directory containing the resampled roi files
% usercons = name of contrast files which are actually used (i.e. con_0001, con_0002)
%            must be in a cell: {'con_0001', 'con_0002'}
% task = name of task
% ( Uncomment progressbar lines for progress GUI ) 
% SEE EXAMPLE OF INPUT IN extractbetabatch.mat object 


% Sean Spinney

addpath('/usr/local/MATLAB/R2013a_Student/toolbox')

% Paths to participants data
mainpath = taspath;
conpath = conpath;
roipath = roipath;

% Create object containing all summaries, for every participant
rois = dir([roipath '/r_*.nii']);
rois = rois(~ismember({rois.name},{'.','..'}));
contrasts = dir([conpath '/con*.nii']);
contrasts = contrasts(~ismember({contrasts.name},{'.','..'}));
parts = dir(mainpath);
parts = parts(~ismember({parts.name},{'.','..'}));
[Npart,~] = size(parts); % number of participants
%[Ncon,~] = size(contrasts); % number of contrasts
Ncon=length(usercons); 
[Nroi,~] = size(rois); % number of ROIs

% Extract only contrasts specified by user
conkeep=cell(1,Ncon);
for c1=1:length(contrasts)
for c2=1:length(usercons)
if strfind(contrasts(c1).name, usercons{c2})
conkeep(c2) = {contrasts(c1).name};
end
end
end

%progressbar(0,0,0);
for c=1:Ncon
%progressbar([],0);
for r=1:Nroi
%progressbar([],[],0);
for n=1:Npart

try	     
% Load contrast and mask
sprintf('Working on %s, %s, %s', parts(n).name, conkeep{c}, rois(r).name)

% Grab relevant path snippet
C = strsplit(conpath, '/');
contrast.path = [mainpath '/'  parts(n).name '/' C{end} '/' conkeep{c}];
mask.path = ['/data/IMAGEN/Functional/masks/imagen_resampled/' rois(r).name];

contrast.data = spm_read_vols(spm_vol(contrast.path));
mask.data = spm_read_vols(spm_vol(mask.path));

% Sanity check: sizes of mask and contrast should be equal. Probably would fail even without check.
contrast.dim = size(contrast.data);
mask.dim = size(mask.data);

if contrast.dim ~= mask.dim
    sprintf('There was a problem creating the mask %s', mask.path)
end

% Get linear indices for mask (all non-zero elements):
mask.ind = find(mask.data);

% Revised Version
avgconbeta = mean(contrast.data(mask.ind)); % Takes average over ROI

condata(c).task = task;
condata(c).name = conkeep{c}(1:end-4);
condata(c).roi(r).name = rois(r).name(3:end-4);
condata(c).roi(r).part(n).name = parts(n).name;
condata(c).roi(r).part(n).beta = avgconbeta;

% Write any errors to a log file
catch ME
sprintf('Failed -> Part: %s Contrast: %s Roi: %s \n Message: %s', parts(n).name, conkeep{c}, rois(r).name, ME.message)
fid=fopen('/data/IMAGEN/Functional/error_logs/error.log', 'a+');
fprintf(fid, '%s\t %s\t %s\t %s\n', conkeep{c}, rois(r).name, parts(n).name, ME.message);
fclose(fid);
end

%progressbar([],[],n/Npart); % Update 3rd progress bar
end
%progressbar([],r/Nroi); % Update 2nd bar
end
%progressbar(c/Ncon); % Update 1st bar
end
objname = [task '_' 'extract_betas.mat'];
save(objname, 'condata')
end
