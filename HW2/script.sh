#!/usr/bin/env bash
parm1=/root/Desktop/folder1
parm2=/root/Desktop/folder2
parm3="q"
if [ -d "$parm1" ] && [ -d "$parm2" ]; then
echo "variables are linked to a directory"
else
echo "variables are not linked to a directory"
exit 20
fi
if [ -L "$parm1" ]; then
echo "Path $parm1 is a symlink"
exit 30
elif [ -L "$parm2" ]; then
echo "path $parm2 is a symlink"
exit 30
else
echo "Neither of the variables points to a symlink"
fi
shopt -s globstar dotglob
for file1 in "$parm1"/**/*; do
if [ -d "$file1" ]; then
continue
fi
checksum1=$(md5sum "$file1" | awk '{print $1}')
filename1=$(basename "$file1")
for file2 in "$parm2"/**/*; do
if [ -d "$file2" ]; then
continue
fi
checksum2=$(md5sum "$file2" | awk '{print $1}')
filename2=$(basename "$file2")
if [ "$checksum1" == "$checksum2" ]; then
if [ "$parm3" == "q" ]; then
echo "Removing duplicate: $file2"
rm "$file2"
else 
echo "$filename2 in $parm2 is a duplicate of $filename1 in $parm1"
fi
fi
done
done
echo "Completed" 
