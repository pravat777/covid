#jq tool is used in this script to parse the JSON

#Stored state wise object in a array 
declare -A myarray
while IFS="=" read -r key value
do
    myarray[$key]="$value"
done < <(curl -H "Accept:application/json" https://api.covid19india.org/v4/min/data.min.json | jq -r "to_entries|map(\"\(.key)=\(.value.total)\")|.[]")

#Iterating and accesing the required value
echo "State Active case"
echo "-----------------"
for key in "${!myarray[@]}"
do
 confirmed=$(jq '.confirmed' <<< ${myarray[$key]})
 if [  $confirmed = "null" ]; then
     confirmed=0
 fi

 recovered=$(jq '.recovered' <<< ${myarray[$key]})
 if [  $recovered = "null" ]; then
     recovered=0
 fi

 deceased=$(jq '.deceased' <<< ${myarray[$key]})
 if [  $deceased = "null" ]; then
     deceased=0
 fi

 other=$(jq '.other' <<< ${myarray[$key]})
 if [ $other = "null" ];then
     other=0;
 fi

echo "$key : $(( confirmed - (recovered + deceased + other) ))"
done

