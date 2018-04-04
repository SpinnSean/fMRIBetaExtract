function df=ExtractBetas(taspath, conpath, roipath)
% Extracts beta differences from contrast images
% taspath = path of directory containing all participant data for that task
% conpath = path of directory used as template (note every participant must 
%           contain the same contrast names for this to work i.e. the contrast
%           file names are the same for every participant (each has his own copy).
% roipath = path to directory containing the resampled roi files

% Left to do (1/04/2018): 
% Last error: line 31, 'Too many inputs for colon operator.' [parts.N]

% Sean Spinney

% Paths to participants data
mainpath = taspath;
conpath = conpath;
roipath = roipath;
%mainpath = '/data/IMAGEN/Functional/Mid_task_contrasts/BL/processed/spm_first_level';
%conexpath = [mainpath '/000018090882/EPI_short_MID/con*']; % Using first in the list as template for number of cons
%roipath = '/data/IMAGEN/Functional/masks/r*.nii'


% Create object containing all summaries, for every participant
rois = dir([roipath '/r*.nii']);
rois = rois(~ismember({rois.name},{'.','..'}));
contrasts = dir([conpath '/con*.nii']);
contrasts = contrasts(~ismember({contrasts.name},{'.','..'}));
parts = dir(mainpath);
parts = parts(~ismember({parts.name},{'.','..'}));
[Npart,~] = size(parts); % number of participants
[Ncon,~] = size(contrasts); % number of contrasts 
[Nroi,~] = size(rois); % number of ROIs


%field1 = 'parts'; field2 = 'rois'; field3= 'cons';
%value1 = {parts.name}; value2 = {rois.name}; value3 = {contrasts.name};

%df = struct(field1,{value1})
%df.parts = struct(field2,{value2})
%df = struct(field1,{value1},field2,{value2},field3,{value3});
df = cell(Npart,Ncon,Nroi);


%for p=df.parts
%for r=df.rois
%for c=df.cons

for n=1:Npart
for c=1:Ncon
for r=1:Nroi


try	     
% Load contrast and mask
sprintf('Working on %s, %s, %s', parts(n).name, contrasts(c).name, rois(r).name)
%sprintf('Working on %s, %s, %s', p, r, c)

conpath = [mainpath '/'  parts(n).name '/EPI_faces/' contrasts(c).name];
maspath = ['/data/IMAGEN/Functional/masks/' rois(r).name];

%conpath = [mainpath '/'  p '/EPI_faces/' c];
%maspath = ['/data/IMAGEN/Functional/masks/' r];

contrast.path = conpath;
mask.path = maspath;
sprintf('Uploading %s data')
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

% Old Version
% Transform back into matrix of right dimensions
%[X,Y,Z]=ind2sub(contrast.dim,mask.ind);
%XYZ = transpose([X,Y,Z]);

% Return mean of all beta differences in mask 
%avgconbeta = mean(spm_get_data(conname,XYZ));
%

% Revised Version
avgconbeta = mean(contrast.data(mask.ind));


df{n,r,c} = avgconbeta;


catch ME
sprintf('Failed -> Part: %s Contrast: %s Roi: %s', parts(n).name, contrasts(c).name, rois(r).name)

end

end
end
end
