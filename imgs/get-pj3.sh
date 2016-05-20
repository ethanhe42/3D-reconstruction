wget -r -np -nH -R index.html* http://cs.ucsb.edu/~cs281b/testimages/prog5/ 
find . -type f -name '*.tar' -exec cp {} ./  \;
