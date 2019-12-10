rm(list = ls())
options(stringsAsFactors = FALSE)
#options(BioC_mirror = "https://mirrors.tuna.tsinghua.edu.cn/bioconductor")
#utils::setRepositories(ind = 1:2)
#BiocManager::install("Biostrings")
library("Biostrings")

input_file <- "./data/sequences.fasta"

bio_seq_import <- function(input_file) {
  # 读入fasta文件，存入对象my_fasta
  my_fasta <- readDNAStringSet(input_file);

  #从my_fasta第一列的注释行中提取序列的ID(Accession Number)。
  Acc <- gsub("(\\w*)\\s\\[\\w*\\]", "\\1", names(my_fasta), perl = T);

  #修改my_fasta对象的names属性
  names(my_fasta) <- Acc;

  my_fasta;
}

? read.AAStringSet