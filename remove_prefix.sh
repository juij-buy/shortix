#!/bin/bash

SHORTIX_DIR=$HOME/Shortix

echo "##########################"
echo "# Shortix 兼容层删除器 #"
echo "##########################"

echo "将快捷方式拖放到要删除的兼容层目录上，然后按回车键。"
echo "(请勿拖放/粘贴/键入文本)"
IFS="" read -r input
eval "文件 = ( $input )"

echo "这是所选的兼容层文件:"
for file in "${files[@]}"
do
  echo -n $file
  echo -n " : "
  readlink -f "$file"
done
while true; do
echo -e "真的要删除吗？ [y/n] \n 请注意：这将完全删除所有兼容层数据，包括游戏存档！"
read -p "" yn
  case $yn in
      yes|y|Y )
          echo "正在删除...";
          for file in "${files[@]}"
          do
            rm -r "$(readlink -f "$file")"
            rm -r "$file"
          done
          read -p "完成，现在可以关闭此窗口。";
          exit;;
      no|n|N ) echo "好吧，什么也没删！现在可以关闭此窗口。";
          exit 1;;
      * ) echo "输入无效，选择 y 或 n" >&2;

  esac
done

