function SaveBetas(condata)
% Save beta weights. Each contrast is saved seperately as 
% 	Rows: subjects
%	Columns: ROIs
%
%	condata: structure array containing task data [NxCxR]
%	   N:#subj, C:#contrasts, R:#ROIs
%	outpath = where the contrast beta weights will be saved 


outpath = '/data/IMAGEN/Functional/extracted_betas';

[~,C] = size(condata);
[~,R] = size(condata(1).roi);
[~,N] = size(condata(1).roi(1).part);
task = condata(1).task;

for c=1:C
fname = [outpath '/' task '_' condata(c).name(1:end-4) '.txt'];
fid = fopen(fname, 'wt+');
% Write header
fprintf(fid, 'Subject\t', '')
fprintf(fid, '%s\t', condata(c).roi(:).name)
fprintf(fid, '\n','')

%subname=[];
%subdata=[];

for n=1:N
%subname = [subname;'sub' condata(c).roi(r).part(n).name];
fprintf(fid, '%s\t', condata(c).roi(1).part(n).name)
%data=cell(R,2);

for r=1:R
fprintf(fid, '%s\t', condata(c).roi(r).part(n).beta)
%data(r,1) = {condata(c).roi(r).name};
%data(r,2) = {condata(c).roi(r).part(n).beta};
end
fprintf(fid, '\n','')
%subdata = [subdata; struct('rois', data(:,1), 'betas', data(:,2))];
end
%s = struct('Subject', subname, 'data', subdata);
%s = struct('Subject', subname, 'Data', subdata);
fclose(fid);
end

end

