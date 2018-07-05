
Useful one line commands
========================

convert transparent background of a png
---------------------------------------
```
convert -flatten a.png awhite.png
```

change "spaces" to "_" in all .pdf file names in directory
----------------------------------------------------------
```
for i in *.pdf;do mv $i $(ls $i | sed 's/ /_/g') ; done
```

remove unwanted newlines
------------------------
```
cat file| tr -d '\n' > file2
```


