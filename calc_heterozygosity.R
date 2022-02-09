## Input: vcf, simplified, that includes invariant and variant sites. 
## Impute heterozygous sites, per individual per vcf, extract number of heterozygous sites. 
## Extract length of each vcf, to calculate heterozygosity per individual for that vcf. 
## Heterozygosity = total number of heterozygous sites/total number of sites. 

# vcf order 

# Setophaga_graciae_CM_S10255_BEL	Setophaga_graciae_CM_S9116_BEL	
# Setophaga_graciae_DMNS_52524_COL Setophaga_graciae_KU_33633_RACN	
# Setophaga_graciae_KU_33634_RACN	Setophaga_graciae_KU_8199_SANA	
# Setophaga_graciae_KU_8218_SANA	Setophaga_graciae_UWBM_105736_ARI	
# Setophaga_graciae_UWBM_106758_NM Setophaga_graciae_UWBM_106760_NM
# Setophaga_graciae_UWBM_108714_NEV	Setophaga_graciae_UWBM_111891_NM	
# Setophaga_graciae_UWBM_111896_NM	Setophaga_graciae_UWBM_112575_GUE	
# Setophaga_graciae_UWBM_112576_GUE	Setophaga_graciae_UWBM_112587_GUE	
# Setophaga_graciae_UWBM_112592_GUE	Setophaga_graciae_UWBM_113059_CHI	
# Setophaga_graciae_UWBM_113126_CHI	Setophaga_graciae_UWBM_113970_DUR	
# Setophaga_graciae_UWBM_114011_DUR Setophaga_graciae_UWBM_114012_DUR 
# Setophaga_graciae_UWBM_114019_DUR Setophaga_graciae_UWBM_114038_DUR	
# Setophaga_graciae_UWBM_114039_DUR Setophaga_graciae_UWBM_114046_DUR 
# Setophaga_graciae_UWBM_114047_DUR	Setophaga_graciae_UWBM_114087_CHIH 
# Setophaga_graciae_UWBM_114088_CHIH Setophaga_graciae_UWBM_114090_CHIH 
# Setophaga_graciae_UWBM_114091_CHIH Setophaga_graciae_UWBM_114126_CHIH 
# Setophaga_graciae_UWBM_114127_CHIH Setophaga_graciae_UWBM_114128_CHIH 
# Setophaga_graciae_UWBM_114282_NEV Setophaga_graciae_UWBM_114424_NEV 
# Setophaga_graciae_UWBM_115308_GUE Setophaga_graciae_UWBM_69981_PCA 
# Setophaga_graciae_UWBM_77653_ARI Setophaga_graciae_UWBM_77735_ARI 
# Setophaga_graciae_UWBM_84639_ARI Setophaga_graciae_UWBM_93801_CPN 
# Setophaga_graciae_UWBM_93805_CPN Setophaga_graciae_UWBM_93806_CPN 
# Setophaga_graciae_UWBM_93807_CPN Setophaga_graciae_UWBM_93808_CPN 
# Setophaga_graciae_UWBM_95850_ARI

# list all of the vcf files 
vcfs <- list.files(pattern="*.simple.vcf")

# write het output file
write(c("VCF", "Setophaga_graciae_CM_S10255_BEL_total_sites", "Setophaga_graciae_CM_S9116_BEL_total_sites", 
        "Setophaga_graciae_DMNS_52524_COL_total_sites", "Setophaga_graciae_KU_33633_RACN_total_sites", 
        "Setophaga_graciae_KU_33634_RACN_total_sites", "Setophaga_graciae_KU_8199_SANA_total_sites", 
        "Setophaga_graciae_KU_8218_SANA_total_sites", "Setophaga_graciae_UWBM_105736_ARI_total_sites", 
        "Setophaga_graciae_UWBM_106758_NM_total_sites", "Setophaga_graciae_UWBM_106760_NM_total_sites", 
        "Setophaga_graciae_UWBM_108714_NEV_total_sites", "Setophaga_graciae_UWBM_111891_NM_total_sites", 
        "Setophaga_graciae_UWBM_111896_NM_total_sites", "Setophaga_graciae_UWBM_112575_GUE_total_sites", 
        "Setophaga_graciae_UWBM_112576_GUE_total_sites", "Setophaga_graciae_UWBM_112587_GUE_total_sites", 
        "Setophaga_graciae_UWBM_112592_GUE_total_sites", "Setophaga_graciae_UWBM_113059_CHI_total_sites", 
        "Setophaga_graciae_UWBM_113126_CHI_total_sites", "Setophaga_graciae_UWBM_113970_DUR	_total_sites", 
        "Setophaga_graciae_UWBM_114011_DUR_total_sites", "Setophaga_graciae_UWBM_114012_DUR_total_sites", 
        "Setophaga_graciae_UWBM_114019_DUR_total_sites", "Setophaga_graciae_UWBM_114038_DUR_total_sites", 
        "Setophaga_graciae_UWBM_114039_DUR_total_sites", "Setophaga_graciae_UWBM_114046_DUR_total_sites", 
        "Setophaga_graciae_UWBM_114047_DUR_total_sites", "Setophaga_graciae_UWBM_114087_CHIH_total_sites", 
        "Setophaga_graciae_UWBM_114088_CHIH_total_sites", "Setophaga_graciae_UWBM_114090_CHIH_total_sites", 
        "Setophaga_graciae_UWBM_114091_CHIH_total_sites", "Setophaga_graciae_UWBM_114126_CHIH_total_sites", 
        "Setophaga_graciae_UWBM_114127_CHIH_total_sites", "Setophaga_graciae_UWBM_114128_CHIH_total_sites", 
        "Setophaga_graciae_UWBM_114282_NEV_total_sites", "Setophaga_graciae_UWBM_114424_NEV_total_sites", 
        "Setophaga_graciae_UWBM_115308_GUE_total_sites", "Setophaga_graciae_UWBM_69981_PCA_total_sites", 
        "Setophaga_graciae_UWBM_77653_ARI_total_sites", "Setophaga_graciae_UWBM_77735_ARI_total_sites", 
        "Setophaga_graciae_UWBM_84639_ARI_total_sites", "Setophaga_graciae_UWBM_93801_CPN_total_sites", 
        "Setophaga_graciae_UWBM_93805_CPN_total_sites", "Setophaga_graciae_UWBM_93806_CPN_total_sites", 
        "Setophaga_graciae_UWBM_93807_CPN_total_sites", "Setophaga_graciae_UWBM_93808_CPN_total_sites", 
        "Setophaga_graciae_UWBM_95850_ARI_total_sites", 
        "Setophaga_graciae_CM_S10255_BEL_het_sites", "Setophaga_graciae_CM_S9116_BEL_het_sites", 
        "Setophaga_graciae_DMNS_52524_COL_het_sites", "Setophaga_graciae_KU_33633_RACN_het_sites", 
        "Setophaga_graciae_KU_33634_RACN_het_sites", "Setophaga_graciae_KU_8199_SANA_het_sites", 
        "Setophaga_graciae_KU_8218_SANA_het_sites", "Setophaga_graciae_UWBM_105736_ARI_het_sites", 
        "Setophaga_graciae_UWBM_106758_NM_het_sites", "Setophaga_graciae_UWBM_106760_NM_het_sites", 
        "Setophaga_graciae_UWBM_108714_NEV_het_sites", "Setophaga_graciae_UWBM_111891_NM_het_sites", 
        "Setophaga_graciae_UWBM_111896_NM_het_sites", "Setophaga_graciae_UWBM_112575_GUE_het_sites", 
        "Setophaga_graciae_UWBM_112576_GUE_het_sites", "Setophaga_graciae_UWBM_112587_GUE_het_sites", 
        "Setophaga_graciae_UWBM_112592_GUE_het_sites", "Setophaga_graciae_UWBM_113059_CHI_het_sites", 
        "Setophaga_graciae_UWBM_113126_CHI_het_sites", "Setophaga_graciae_UWBM_113970_DUR_het_sites", 
        "Setophaga_graciae_UWBM_114011_DUR_het_sites", "Setophaga_graciae_UWBM_114012_DUR_het_sites", 
        "Setophaga_graciae_UWBM_114019_DUR_het_sites", "Setophaga_graciae_UWBM_114038_DUR_het_sites", 
        "Setophaga_graciae_UWBM_114039_DUR_het_sites", "Setophaga_graciae_UWBM_114046_DUR_het_sites", 
        "Setophaga_graciae_UWBM_114047_DUR_het_sites", "Setophaga_graciae_UWBM_114087_CHIH_het_sites", 
        "Setophaga_graciae_UWBM_114088_CHIH_het_sites", "Setophaga_graciae_UWBM_114090_CHIH_het_sites", 
        "Setophaga_graciae_UWBM_114091_CHIH_het_sites", "Setophaga_graciae_UWBM_114126_CHIH_het_sites", 
        "Setophaga_graciae_UWBM_114127_CHIH_het_sites", "Setophaga_graciae_UWBM_114128_CHIH_het_sites", 
        "Setophaga_graciae_UWBM_114282_NEV_het_sites", "Setophaga_graciae_UWBM_114424_NEV_het_sites", 
        "Setophaga_graciae_UWBM_115308_GUE_het_sites", "Setophaga_graciae_UWBM_69981_PCA_het_sites", 
        "Setophaga_graciae_UWBM_77653_ARI_het_sites", "Setophaga_graciae_UWBM_77735_ARI_het_sites", 
        "Setophaga_graciae_UWBM_84639_ARI_het_sites", "Setophaga_graciae_UWBM_93801_CPN_het_sites", 
        "Setophaga_graciae_UWBM_93805_CPN_het_sites", "Setophaga_graciae_UWBM_93806_CPN_het_sites", 
        "Setophaga_graciae_UWBM_93807_CPN_het_sites", "Setophaga_graciae_UWBM_93808_CPN_het_sites", 
        "Setophaga_graciae_UWBM_95850_ARI_het_sites",), file=paste("./output.het.txt", sep=""), ncolumns=95, sep="\t")



for (a in 1:119) {
  # vectors for output
  indiv_het_sites <- c()
  indiv_total <- c()
  output_rep <- c()
  # read in vcf files 
  vcf_file <- read.table(vcfs[a], stringsAsFactors = F)
  # remove first three columns 
  vcf_indiv <- vcf_file[,4:50]
  # another for loop here
  for (b in 1:47) {
    # select individual 
    indiv <- vcf_indiv[,b]
    # remove missing genotypes
    indiv <- indiv[indiv != "./."]
    # count number of sites 
    indiv_total[b] <- length(indiv)
    # remove phasing information
    indiv <- gsub("\\|", "/", indiv)
    # count number of heterozygous sites
    indiv_het_sites[b] <- length(indiv[indiv == "0/1"])
  }
  # create vector of output, per vcf
  output_rep <- c(vcfs[a], indiv_total, indiv_het_sites)
  # add to output file, append
  write(output_rep, file="output.het.txt", append=T, ncolumns=95, sep="\t")
}




# calculate heterozygosity
indiv_het <- indiv_het_sites/indiv_total
