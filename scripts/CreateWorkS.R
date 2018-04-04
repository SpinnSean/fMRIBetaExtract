CreateWorkS <- function(task='') {
    indir <- '/data/IMAGEN/Functional/extracted_betas'
    setwd(indir)
    temp <- list.files(pattern= paste0(task,".*.txt$"))
    list2env(lapply(setNames(temp, make.names(gsub("*.txt$", "", temp))),read.csv, sep='\t'), envir = .GlobalEnv)
    #rm(list=setdiff(ls(), ls(pattern="Midt*")), envir=.GlobalEnv)
    #save(list=ls(), file= paste0("/data/IMAGEN/Functional/R_Workspaces/", task, '_workspace.RData'), envir=.GlobalEnv)
    task <- ifelse(task == '', 'ALL', task)
    save.image(file= paste0("/data/IMAGEN/Functional/R_Workspaces/", task, '_workspace.RData'))
}
