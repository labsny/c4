set ns [new Simulator]
set tf [open l4.tr w]
$ns trace-all $tf
set nf [open l4.nam w]
$ns namtrace-all $nf

$ns color 1 blue

set n0 [$ns node]
set n1 [$ns node]
$n0 label "Server"
$n1 label "Client"

$ns duplex-link $n0 $n1 10Mb 22ms DropTail
$ns duplex-link-op $n0 $n1 orient right

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set tcp1 [new Agent/TCPSink]
$ns attach-agent $n1 $tcp1
 
$tcp0 set packetsize_ 1500
$ns connect $tcp0 $tcp1

set ftp [new Application/FTP]
$ftp attach-agent $tcp0

$tcp0 set fid_ 1

$ns at 0.2 "$ftp start"
$ns at 5.0 "$ftp stop"

proc finish {} {
global ns nf tf
$ns flush-trace
close $nf
close $tf
exec nam l4.nam &
exec awk -f 4b.awk l4.tr > convert.tr &
exec xgraph convert.tr -geometry 800*400 -t "bytes received" -x "time in sec" -y "bytes in bps" &
exec awk -f 4a.awk l4.tr &
exit0
}

$ns at 4 "finish"
$ns run
