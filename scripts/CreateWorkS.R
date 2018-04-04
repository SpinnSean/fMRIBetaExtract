CreateWorkS <- function(task='') {
    # If no input is given, default will take All tasks and 
    # produce a combined workspace. 
    
    indir <- '/data/IMAGEN/Functional/extracted_betas' # Where the extracted txt files are
    setwd(indir)
    temp <- list.files(pattern= paste0(task,".*.txt$"))
    list2env(lapply(setNames(temp, make.names(gsub("*.txt$", "", temp))),read.csv, sep='\t'), envir = .GlobalEnv)
    task <- ifelse(task == '', 'ALL', task)
    save.image(file= paste0("/data/IMAGEN/Functional/R_Workspaces/", task, '_workspace.RData'))
}
