rm(list = ls())
options(stringsAsFactors = FALSE)


input_file = "./data/sequences.fasta"

# 逐行读取数据，并存入向量my_fasta，向量每个元素对应文件input_file中的一行，
#这样以后可以通过操作向量my_fasta，来操作对应文件的行。
my_fasta <- readLines(input_file);
# 判断my_fasta中每个元素第一个字母是否是“>”（表示一个fasta记录的注释
#行），判断结果用1和-1表示，并存入向量y。
y <- regexpr("^>", my_fasta, perl = T);

# 向量y中为1的元素替换为0，即序列行对应-1，注释行对应0。
# 这行语句只是一个习惯问题，不是必须的。
y[y == 1] <- 0;

# 用index记录下y中全部0的在向量中的位置，对应注释行的行号。
index <- which(y == 0);

# 生成数据框distance，包括第1列start（除最后一个fasta记录外的所有注释 
#行的位置）和第2列end（除第一个fasta记录外的所有注释行的位置）。
distance <- data.frame(start = index[1:(length(index) - 1)], end = index[2:length(index)]);

# 在数据框distance最后增加一行（两个元素），第1个是最后一个fasta记录的
#注释行位置，第2个是为所有行的行数+1）。
distance <- rbind(distance, c(distance[length(distance[, 1]), 2], length(y) + 1));

# 在数据框distance后面加1列，其值是第2列和第1列之差，注释行之间的距离，
#实际上就是每条序列记录对应的行数。
distance <- data.frame(distance, dist = distance[, 2] - distance[, 1]);

# 建立从1开始的连续正整数向量，长度等于注释行的数量。
seq_no <- 1:length(y[y == 0]);

# 重复正整数向量seq_no中的每一个元素，重复次数为两个临近注释行之间的距离 
#（即distance[, 3]）。
index <- rep(seq_no, as.vector(distance[, 3]));

# 建立一个新的数据框变量，名称还是my_fasta，包括3列内容，第1列是index，
#第2列是y，第3列是旧的my_fasta。
my_fasta <- data.frame(index, y, my_fasta);

# 数据框my_fasta中，第2列为0的元素，对应的第1列赋值为0。
my_fasta[my_fasta[, 2] == 0, 1] <- 0;

# tapply函数调用paste函数的字符串连接功能，把my_fasta[, 3]中的同一类
#元素合并，my_fasta[, 3]的类别由对应my_fasta[, 1]的数据来决定，如“0”表示
#序列所有的注释行，“1”表示第一条记录的序列内容，以此类推。
seqs <- tapply(as.vector(my_fasta[, 3]), factor(my_fasta[, 1]), paste, collapse = "", simplify = F);

# 将变量seq由数组类型转化为字符串向量，不包括第1个元素（所有注释行），剩下
#的内容为所有记录的序列。
seqs <- as.character(seqs[2:length(seqs)]);

# 从my_fasta[, 3]中提取所有的注释行，存入向量Desc。
Desc <- as.vector(my_fasta[c(grep("^>", as.character(my_fasta[, 3]), perl = TRUE)), 3]);

# 建立一个新的数据框变量，名称还是my_fasta，每行对应一个序列记录，包括3列信息（序列的注释，长度和序列内容）。
my_fasta <- data.frame(Desc, Length = nchar(seqs), seqs);

# 从my_fasta第一列的注释行中提取序列的ID(Accession Number)。
Acc <- gsub(".*gb\\|(.*)\\|.*", "\\1", as.character(my_fasta[, 1]), perl = T);

# 将字符串向量Acc添加到数据框左边，成为一列。
my_fasta <- data.frame(Acc, my_fasta);

# 将my_fasta返回，这是习惯性的，R把最后出现的数据作为返回值。
my_fasta;
