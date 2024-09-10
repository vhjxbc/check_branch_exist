#!/bin/bash

# 检查是否提供了分支名称参数
if [ -z "$1" ]; then
  echo "Usage: $0 <branch_name>"
  exit 1
fi

# 获取命令行参数作为要查找的分支名称
branch_name="$1"

# 定义要排除的文件夹列表
exclude_dirs=(".DS_Store" "DB" "a_conf_" "a_run_")

# 定义 ANSI 转义序列
GREEN='\033[0;32m'
GRAY='\033[0;90m'
LIGHT_GRAY='\033[0;37m'
PINK='\033[0;35m'
NC='\033[0m' # No Color

# 定义表格头
printf "%-30s %-20s %-10s\n" "Directory" "Branch Found" "Status"
echo -e "${LIGHT_GRAY}--------------------------------------------------------------${NC}"

# 遍历目录下的所有文件夹
for dir in */; do
  # 检查是否是要排除的文件夹
  if [[ " ${exclude_dirs[@]} " =~ " ${dir%/} " ]]; then
    continue
  fi

  # 检查是否是目录并且是 Git 项目
  if [ -d "$dir/.git" ]; then
    # 进入目录并检查分支
    if (cd "$dir" && git branch -a | grep -iE "$branch_name" >/dev/null); then
      status="${GREEN}Found${NC}"
      printf "%-30s %-20s %b%-10s%b\n" "${dir%/}" "$branch_name" "$GREEN" "Found" "$NC"
      (cd "$dir" && git branch -a | grep -iE "$branch_name" | while read -r branch; do
        echo -e "  \xE2\x80\xA2 ${PINK}$branch${NC}"
      done)
    else
      status="${GRAY}Not Found${NC}"
      printf "%-30s %-20s %b%-10s%b\n" "${dir%/}" "$branch_name" "$GRAY" "Not Found" "$NC"
    fi
  fi
done
