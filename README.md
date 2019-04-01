# fMRIBetaExtract
## Extracting the linear combination of Betas (contrasts) from SPM contrast files.
                                                                    

Takes SPM nifti contrast files and extracts the beta weights using ROI masks. 
The masks were previously resampled using coregistration (reslicing) in SPM. 

### What you will find in this directory. 
-------------------------------------

error_logs: Errors from the ExtractBetaV2 run (only missing file errors, for now).

extracted_betas: The text files containing the betas, as well as matlab structures.

Faces_task_contrasts: The Faces task data.

masks: The masks used (originals, and resampled).

Mid_task_contrasts: The Mid task data.

R_Workspaces: The Rdata objects (saved workspaces). 

scripts: The Matlab and R scripts used. 

spm_1_participant: Example of one participant, used as a template for resampling 
		   (Note: The con_0001_angry was the reference slice).

Stop_task_contrasts: The Stop task data. 

