#!/bin/bash
# 名字列表，一会用来生成随机名字
names=("gnicks" "anny" "zoey" "coco" "cici" "john" "tommy" "jerry" "marry" "sammy" "kitty")
genders=(1 0 0 0 0 1 1 1 0 1 0)
# 邮箱后缀
suffix="@qq.com"
# 一会生成的sql文件路径
path="/data/insert.sql"

# 用来随机数的
function random(){
    min=$1
    max=$(($2-$min+1))
    num=$(($RANDOM+1000000000)) #增加一个10位的数再求余
    echo $(($num%$max+$min))
}

# 随机一个名字，拼一下i
function getName(){
    local current=$1
    local fix=$(($current % 11))
    local currentname=${names[$fix]}
    local rand=$(random 0 current)
    echo "$currentname$rand"
}

function getGender(){

    local current=$1
    local fix=$(($current %11))
    local currentGender=${genders[$fix]}
    echo "$currentGender"
}

function main(){
    local prefix="insert into gnicks.users values ">>$path
    for((i=1;i<1000001;i++));
    do
        # insert into users values (id, name , age, gender,email,heigth)
        local prefix=" ($i,"
        local age=$(random 0 100)
        local name=$(getName ${i})
        local gender=$(getGender $i)
        local email="$name$suffix"
        local heigth=$(random 150 200)
        local sqlCmd=$prefix"\"${name}\",$age,$gender,\"${email}\",$heigth),"
        echo "$sqlCmd" >> $path
    done
		echo ";" >>$path
}

main

create table users (
	id int,
  name varchar(255),
	age int,
  gender smallint,
  email varchar(255),
  heigth int
);