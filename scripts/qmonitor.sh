#!/bin/bash
RED='\u001b[31;1m'
GREEN='\u001b[32;1m'
NC='\u001b[0m'

for qtype in "cpu" "gpu"; do
  out_all=""
  while read line; do
    qname=$(echo $line | awk '{print $1}' | cut -d . -f -2)
    counts=$(echo $line | awk '{print $3}')
    user_slots=$(printf "%02d\n" $(qstat | grep $qname | awk '{s+=$9} END {print s}'))
    used_slots=$(printf "%02d\n" $(echo $counts | cut -d / -f 2 ))
    total_slots=$(printf "%02d\n" $(echo $counts | cut -d / -f 3 ))
    qid="[${qtype^^}${qname: -1}]"
    if ! [ $user_slots = 00 ]; then user_slots="${GREEN}${user_slots}${NC}"; fi
    out="$qid${user_slots}/${used_slots}/${total_slots}"
    if [ $used_slots -eq $total_slots ]; then out="${RED}${out}${NC}"; fi

    out_all="$out_all $out"
  done < <(qstat -f -q aml-${qtype}.q | grep BIP)
  echo -e "$out_all"
done