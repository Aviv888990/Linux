ip="216.58.214."
for((i=1;i<=256;i++));do
timeout 0.25 ping -c 1 "$ip$i" &>/dev/null
if [ $? -eq 0 ]; then
echo "$ip$i is online"
else
echo "$ip$i is offline"
fi
done
