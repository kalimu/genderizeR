library("devtools")

res <- revdep_check(libpath = "e:/R_bufor/")
revdep_check_save_summary(res)
revdep_check_save_logs(res)
