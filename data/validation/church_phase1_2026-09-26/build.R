for(f in list.files('R',pattern='[.]R$',full.names=TRUE)) source(f)
targets::tar_make(script='_targets_churches.R',store='_targets_churches',names=church_output_files)
