#!/bin/bash
set -xe

declare -a -g monkey_0_starting_items=(79 98)
declare -a -g monkey_1_starting_items=(54 65 75 74)
declare -a -g monkey_2_starting_items=(79 60 97)
declare -a -g monkey_3_starting_items=(74)

monkey_0_operation () {
  local new=$(($1 * 19))
  echo $new
}
monkey_1_operation () {
  local new=$(($1 + 6))
  echo $new
}
monkey_2_operation () {
  local new=$(($1 * $1))
  echo $new
}
monkey_3_operation () {
  local new=$(($1 + 3))
  echo $new
}

monkey_0_test () {
  if (( $1 % 23 == 0 ))
  then
    monkey_2_starting_items+=($1)
  else
    monkey_3_starting_items+=($1)
  fi
}

monkey_1_test () {
  if (( $1 % 19 == 0 ))
  then
    monkey_2_starting_items+=($1)
  else
    monkey_0_starting_items+=($1)
  fi
}

monkey_2_test () {
  if (( $1 % 13 == 0 ))
  then
    monkey_1_starting_items+=($1)
  else
    monkey_3_starting_items+=($1)
  fi
}

monkey_3_test () {
  if (( $1 % 17 == 0 ))
  then
    monkey_0_starting_items+=($1)
  else
    monkey_1_starting_items+=($1)
  fi
}

monkey_0_count=0
monkey_1_count=0
monkey_2_count=0
monkey_3_count=0

round () {
  monkey_number=$1
  starting_items=monkey_${monkey_number}_starting_items[@]
  starting_items=("${!starting_items}")
  for i in "${!starting_items[@]}"
  do
    ((monkey_${monkey_number}_count+=1))
    item=starting_items[$i]
    result=$(monkey_${monkey_number}_operation $item)
    result1=$(($result/3))
    monkey_${monkey_number}_test $result1
    unset starting_items[0]
    new_arr=("${starting_items[@]}")
    declare -a -g monkey_${monkey_number}_starting_items=\("${new_arrs[*]}"\)
  done
}

for i in {1..20};
do
  round 0
  round 1
  round 2
  round 3
done

echo "monkey 0 items" "${monkey_0_starting_items[*]}"
echo "monkey 1 items" "${monkey_1_starting_items[*]}"
echo "monkey 2 items" "${monkey_2_starting_items[*]}"
echo "monkey 3 items" "${monkey_3_starting_items[*]}"

counts=($monkey_0_count $monkey_1_count $monkey_2_count $monkey_3_count)
sorted=($( printf "%s\n" "${counts[@]}" | sort -nr ))
max_0="${sorted[0]}"
max_1="${sorted[1]}"
result=$(($max_0*$max_1))
echo $result
