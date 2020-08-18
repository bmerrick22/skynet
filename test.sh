#!/bin/sh

# Script requires student # and ports of two servers, first one single second one forking
# Hard coded to run 4 times for each different request and then computes average
# Hard coded to run 5 requests for each different test
# Hard coded to run 5 proccesses on both single and server mode

usage(){
   cat<<EOF
Usage: test.sh
   ERROR 

   *Need two servers running, one single, one forking*

   Need four arguments:
        First argument: student machine number for single server
        Second argument: Port single server is running on
        Third argument: student machine number of forking server
        Fourth argument: Port forking server is on
        
EOF
    exit $1
}

if [ $# -lt 4 ] 
    then 
        usage 0 
fi 

directory="/html"
files="/song.txt"
CGI="/scripts/cowsay.sh"

count=0
iterations=0

echo "Beginning Tests..."
echo 
echo "------------FIRST TESTS: LATENCY-----------------"
echo
echo "            SINGLE SERVER MODE                   "
echo
echo "Directory Listing:"
echo

for i in {1..4}
do
    ./bin/thor.py -p 5 -r 5 http://student0$1.cse.nd.edu:$2$directory > temp.txt
    temp=$(cat temp.txt | grep -E 'TOTAL AVERAGE ELAPSED TIME: ' | tr -d '[:alpha:] :')
    iterations=$[iterations+1] 
    count=$(echo "$temp + $count" | bc) 

done
count=$( bc -l <<< 'scale=3; '$count/$iterations'')  
 
echo Average latency time after $iterations trials: $count
echo 

count=0
iterations=0

echo "Static Files:"
echo

for i in {1..4}
do
    ./bin/thor.py -p 5 -r 5 http://student0$1.cse.nd.edu:$2$files > temp.txt
    temp=$(cat temp.txt | grep -E 'TOTAL AVERAGE ELAPSED TIME: ' | tr -d '[:alpha:] :')
    iterations=$[iterations+1] 
    count=$(echo "$temp + $count" | bc) 

done
count=$( bc -l <<< 'scale=3; '$count/$iterations'')  
 
echo Average latency time after $iterations trials: $count
echo 

count=0
iterations=0

echo "CGI:"
echo

for i in {1..4}
do
    ./bin/thor.py -p 5 -r 5 http://student0$1.cse.nd.edu:$2$CGI > temp.txt
    temp=$(cat temp.txt | grep -E 'TOTAL AVERAGE ELAPSED TIME: ' | tr -d '[:alpha:] :')
    iterations=$[iterations+1] 
    count=$(echo "$temp + $count" | bc) 

done
count=$( bc -l <<< 'scale=3; '$count/$iterations'')  
 
echo Average latency time after $iterations trials: $count
echo 

count=0
iterations=0

echo "           FORKING SERVER MODE               " 
echo 
echo Directory Listing:
echo
 
for i in {1..4}
do
    ./bin/thor.py -p 5 -r 5 http://student0$3.cse.nd.edu:$4$directory > temp.txt
    temp=$(cat temp.txt | grep -E 'TOTAL AVERAGE ELAPSED TIME: ' | tr -d '[:alpha:] :')
    iterations=$[iterations+1] 
    count=$(echo "$temp + $count" | bc) 

done
count=$( bc -l <<< 'scale=3; '$count/$iterations'')  
 
echo Average latency time after $iterations trials: $count
echo 

count=0
iterations=0

echo "Static Files:"
echo

for i in {1..4}
do
    ./bin/thor.py -p 5 -r 5 http://student0$3.cse.nd.edu:$4$files > temp.txt
    temp=$(cat temp.txt | grep -E 'TOTAL AVERAGE ELAPSED TIME: ' | tr -d '[:alpha:] :')
    iterations=$[iterations+1] 
    count=$(echo "$temp + $count" | bc) 

done
count=$( bc -l <<< 'scale=3; '$count/$iterations'')  
 
echo Average latency time after $iterations trials: $count
echo 

count=0
iterations=0

echo "CGI: "
echo

for i in {1..4}
do
    ./bin/thor.py -p 5 -r 5 http://student0$3.cse.nd.edu:$4$CGI > temp.txt
    temp=$(cat temp.txt | grep -E 'TOTAL AVERAGE ELAPSED TIME: ' | tr -d '[:alpha:] :')
    iterations=$[iterations+1] 
    count=$(echo "$temp + $count" | bc) 

done
count=$( bc -l <<< 'scale=3; '$count/$iterations'')  
 
echo Average latency time after $iterations trials: $count
echo
echo
echo "------------SECOND TEST: THROUGHPUT--------------"
echo 
echo "            SINGLE SERVER MODE                   "

# FILE SIZE GLOBALS
kb="/files/1KB.txt"
mb="/files/1MB.txt"
gb="/files/1GB.txt"

count=0
iterations=0

echo "1 KB:"
echo
for i in {1..4}
do
    ./bin/thor.py -p 5 -r 5 http://student0$1.cse.nd.edu:$2$kb > temp.txt
    temp=$(cat temp.txt | grep -E 'TOTAL AVERAGE ELAPSED TIME: ' | tr -d '[:alpha:] :')
    iterations=$[iterations+1] 
    count=$(echo "$temp + $count" | bc) 

done
count=$( bc -l <<< 'scale=3; '$count/$iterations'') 
size=$( ls -l ./www$kb | cut -d " " -f 5) 
avgput=$( bc -l <<< 'scale=3; '$size/$count'') 
avgputbyte=$( bc -l <<< 'scale=3; '$avgput/100000'') 
echo Average throughput after $iterations trials: $avgputbyte megabytes/second
echo

count=0
iterations=0

echo "1 MB:"
 
for i in {1..4}
do
    ./bin/thor.py -p 5 -r 5  http://student0$1.cse.nd.edu:$2$mb > temp.txt
    temp=$(cat temp.txt | grep -E 'TOTAL AVERAGE ELAPSED TIME: ' | tr -d '[:alpha:] :')
    iterations=$[iterations+1] 
    count=$(echo "$temp + $count" | bc) 

done
count=$( bc -l <<< 'scale=3; '$count/$iterations'') 
size=$( ls -l ./www$mb | cut -d " " -f 5) 
avgput=$( bc -l <<< 'scale=3; '$size/$count'') 
avgputbyte=$( bc -l <<< 'scale=3; '$avgput/100000'') 
echo Average throughput after $iterations trials: $avgputbyte megabytes/second
echo

count=0
iterations=0

echo "1 GB:"
 
for i in {1..4}
do
    ./bin/thor.py -p 5 -r 5  http://student0$1.cse.nd.edu:$2$gb > temp.txt
    temp=$(cat temp.txt | grep -E 'TOTAL AVERAGE ELAPSED TIME: ' | tr -d '[:alpha:] :')
    iterations=$[iterations+1] 
    count=$(echo "$temp + $count" | bc) 

done
count=$( bc -l <<< 'scale=3; '$count/$iterations'') 
size=$( ls -l ./www$gb | cut -d " " -f 5) 
avgput=$( bc -l <<< 'scale=3; '$size/$count'') 
avgputbyte=$( bc -l <<< 'scale=3; '$avgput/100000'') 
echo Average throughput after $iterations trials: $avgputbyte megabytes/second
echo
echo
echo "               FORKING  MODE                   "
echo 

count=0
iterations=0 
        
echo "1 KB:"
echo
for i in {1..4}
do
    ./bin/thor.py -p 5 -r 5 http://student0$3.cse.nd.edu:$4$kb > temp.txt
    temp=$(cat temp.txt | grep -E 'TOTAL AVERAGE ELAPSED TIME: ' | tr -d '[:alpha:] :')
    iterations=$[iterations+1] 
    count=$(echo "$temp + $count" | bc) 

done
count=$( bc -l <<< 'scale=3; '$count/$iterations'') 
size=$( ls -l ./www$kb | cut -d " " -f 5) 
avgput=$( bc -l <<< 'scale=3; '$size/$count'') 
avgputbyte=$( bc -l <<< 'scale=3; '$avgput/100000'') 
echo Average throughput after $iterations trials: $avgputbyte megabytes/second
echo

count=0
iterations=0

echo "1 MB:"
 
for i in {1..4}
do
    ./bin/thor.py -p 5 -r 5 http://student0$3.cse.nd.edu:$4$mb > temp.txt
    temp=$(cat temp.txt | grep -E 'TOTAL AVERAGE ELAPSED TIME: ' | tr -d '[:alpha:] :')
    iterations=$[iterations+1] 
    count=$(echo "$temp + $count" | bc) 

done
count=$( bc -l <<< 'scale=3; '$count/$iterations'') 
size=$( ls -l ./www$mb | cut -d " " -f 5) 
avgput=$( bc -l <<< 'scale=3; '$size/$count'') 
avgputbyte=$( bc -l <<< 'scale=3; '$avgput/100000'') 
echo Average throughput after $iterations trials: $avgputbyte megabytes/second
echo 

count=0
iterations=0

echo "1 GB:"
 
for i in {1..4}
do
    ./bin/thor.py -p 5 -r 5 http://student0$3.cse.nd.edu:$4$gb > temp.txt
    temp=$(cat temp.txt | grep -E 'TOTAL AVERAGE ELAPSED TIME: ' | tr -d '[:alpha:] :')
    iterations=$[iterations+1] 
    count=$(echo "$temp + $count" | bc) 

done
count=$( bc -l <<< 'scale=3; '$count/$iterations'') 
size=$( ls -l ./www$gb | cut -d " " -f 5) 
avgput=$( bc -l <<< 'scale=3; '$size/$count'') 
avgputbyte=$( bc -l <<< 'scale=3; '$avgput/100000'') 
echo Average throughput after $iterations trials: $avgputbyte megabytes/second

echo yeet

