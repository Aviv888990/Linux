sum=0
for((i=2;i<1000;i++));do
if [[ $((i%5)) -eq 0 || $((i%3)) -eq 0 ]];then
echo "$i+sum"
sum=$((sum+i))
fi
done
echo "sum of all numbers that can be divide by 3 or 5: $sum"
