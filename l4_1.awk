BEGIN{
total_r=0;
total_s=0;
}

{
if ($1=="+" && $3=="0" && $5=="tcp")
	total_s+=$6
if ($1=="r" && $4=="1" && $5=="tcp")
	total_r+=$6
}
END{
print($2,(total_s*8/1000000),(total_r*8/1000000))
}
//$1=event-queue,dequeue,received,dropped
//$3=source $4=dest $5=pkttype $6pktsize
