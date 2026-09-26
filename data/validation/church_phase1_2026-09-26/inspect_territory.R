library(dplyr)
x<-targets::tar_read(church_named_analysis,store='_targets_churches')
print(x |> filter(analysis_eligible,ordinal==1L,name_core=='baptist church') |>
  select(name_raw,name_expanded,name_core,ordinal) |> head(30),n=30)
print(x |> filter(analysis_eligible,ordinal==1L) |> count(name_core,sort=TRUE) |> head(15),n=15)
