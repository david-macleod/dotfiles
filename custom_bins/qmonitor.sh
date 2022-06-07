#!/bin/bash
BLACK='\u001b[34;1m'
RED='\u001b[31;1m'
GREEN='\u001b[32;1m'
NC='\u001b[0m'

for qtype in "cpu" "gpu"; do
  out_all=""
  total_user_slots=0
  total_used_slot=0
  total_slots=0
  while read line; do
    qname=$(echo $line | awk '{print $1}' | cut -d . -f -2)
    counts=$(echo $line | awk '{print $3}')
    user_slots=$(qstat | grep $qname | awk '{s+=$9} END {print s}')
    used_slots=$(echo $counts | cut -d / -f 2 )
    total_slots=$(echo $counts | cut -d / -f 3 )
    qid="[${qtype^^}${qname: -1}]"
    ((total_user_slots+=user_slots))

    user_slots=$(printf "%02d\n" $user_slots)
    used_slots=$(printf "%02d\n" $used_slots)
    total_slots=$(printf "%02d\n" $total_slots)

    non_user_slots="/${used_slots}/${total_slots}"
    if ! [ $user_slots = 00 ]; then user_slots="${GREEN}${user_slots}${NC}"; fi

    if [ $used_slots -eq $total_slots ];then
      qid="${RED}${qid}${NC}"
      user_slots="${RED}${user_slots}${NC}"
      non_user_slots="${RED}${non_user_slots}${NC}"
    fi
    out="${qid}${user_slots}${non_user_slots}"
    out_all="$out_all $out"


  done < <(qstat -f -q aml-${qtype}.q | grep BIP)
  #echo $total_user_slots
  echo -e "$out_all"
done