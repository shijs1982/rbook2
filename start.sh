#生成一个基准的转换模板
pandoc --print-default-data-file reference.docx > custom-reference.docx
#通过上面的命令行生成的基准模板（custom-reference.docx）中有很多样式不存在，比如上面提到的“Source Code”样式，需要读者自行手工添加才行。我推荐通过下面更为直接的方式获取基准模板
pandoc -f markdown -t docx hello.txt -o custom-reference2.docx
##修改样式
pandoc Single-num.tex --bibliography=my.bib --reference-doc=custom-reference2.docx -o mydoc.docx -w docx --pdf-engine pdflatex
##ssh
#ssh-keygen -t rsa -C "shijs1982@hotmail.com"
#将rsa-public加入github网站
#ssh -T git@github.com

#设置全局配置
git config --global user.email "shijs1982@hotmail.com"
git config --global user.name "shijs1982"
git config --global credential.helper store 
#进入目录
git remote add origin git@github.com:shijs1982/rbook2.git
git branch --set-upstream-to=origin/master