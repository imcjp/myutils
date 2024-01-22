import os
import sys
import argparse
import colorama

# 可以在.bashrc中添加如下函数，直接使用 switch <arg> 即可跳转路径
# switch() {
#     cd $(mydev switch "$1")
# }
# ANSI escape sequences for terminal colors
RED = colorama.Fore.RED
GREEN = colorama.Fore.GREEN
YELLOW = colorama.Fore.YELLOW
RESET = colorama.Fore.RESET
BLUE = colorama.Fore.BLUE

dirs = ['ws', 'projStk']


def transform_path(folder_a, folder_b, folder_c):
    # 获取两个文件夹的绝对路径
    folder_a = os.path.abspath(folder_a)
    folder_b = os.path.abspath(folder_b)
    # 确保folder_b是folder_a的子目录
    if not folder_b.startswith(folder_a):
        print(f"{RED}Warning: 文件夹 '{folder_b}' 要求是文件夹A的子目录，现在进行直接跳转{RESET}", file=sys.stderr)
        return None
    # 获得文件夹B在文件夹A上的相对目录
    relative_path_b = os.path.relpath(folder_b, folder_a)
    # 将相对路径的前两级目录分割出来
    parts = relative_path_b.split(os.sep)
    if len(parts) < 2:
        print(f"{RED}Warning: 文件夹 '{folder_b}' 的相对路径至少需要包含两级目录，现在进行直接跳转{RESET}", file=sys.stderr)
        return None

    # 将前两级目录替换为文件夹名称C
    new_parts = [folder_c] + parts[2:]
    transformed_path = os.path.join(*new_parts)

    # 输出新路径相对于文件夹A的绝对路径
    absolute_transformed_path = os.path.join(folder_a, transformed_path)
    return absolute_transformed_path

def find_first_level_subdirectories(folder_a):
    res = []
    nameMap={}
    for rel_dir in dirs:
        dir = os.path.join(folder_a, rel_dir)
        # 确保目录存在
        if os.path.exists(dir) and os.path.isdir(dir):
            # 获取一级子目录列表
            for name in os.listdir(dir):
                thePath = os.path.join(dir, name)
                if os.path.isdir(thePath):
                    res.append(rel_dir + "/" + name)
                    if name in nameMap:
                        nameMap[name] = None
                    else:
                        nameMap[name]=rel_dir + "/" + name
    return res,nameMap

if __name__ == "__main__":
    # 设置命令行参数解析器
    parser = argparse.ArgumentParser(
        description='这个脚本用于将给定的文件夹B的路径转换为一个新的路径，'
                    '新路径以文件夹C的名称开始，然后是文件夹B路径中除去前两个目录的剩余部分。'
                    '如果转换后的路径不存在，会一级一级向上回溯，直到找到存在的路径。',
        formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument('folder_a', type=str, help='基础文件夹A的路径')
    parser.add_argument('folder_b', type=str, help='目标文件夹B的路径')
    parser.add_argument('folder_c', type=str, help='用于替换文件夹B前两级目录的文件夹C的名称。若为?，则输出可用的路径。')
    # 解析命令行参数
    args = parser.parse_args()
    avaDirs, nameMap = find_first_level_subdirectories(args.folder_a)
    folder_c0 = args.folder_c
    if folder_c0 == '?':
        print(f'包含{len(avaDirs)}个路径（路径的匹配规则是全称优先，其次为文件夹名称匹配，最后是模式匹配）：', file=sys.stderr)
        avaDirs.sort()
        for pid, output in enumerate(avaDirs):
            print(f'  {pid+1}) {output}', file=sys.stderr)
        print(args.folder_b)
        exit(0)

    folder_c=None
    matchDirs=[dir for dir in avaDirs if folder_c0 == dir]
    if len(matchDirs)==1:
        folder_c = matchDirs[0]
    if folder_c is None:
        if folder_c0 in nameMap and nameMap[folder_c0] is not None:
            folder_c=nameMap[folder_c0]
            print(f"{BLUE}根据目录名匹配到待替换路径 '{folder_c}'，正在跳转...{RESET}", file=sys.stderr)

    if folder_c is None:
        matchDirs=[dir for dir in avaDirs if folder_c0 in dir]
        if len(matchDirs)==1:
            folder_c = matchDirs[0]
            print(f"{BLUE}模式匹配到待替换路径 '{folder_c}'，正在跳转...{RESET}", file=sys.stderr)
        elif len(matchDirs)==0:
            print(f"{RED}Warning: 待替换路径 '{folder_c}' 未匹配到任何合法路径{RESET}", file=sys.stderr)
            print(args.folder_b)
            exit(0)
        else:
            print(f"{RED}Warning: 待替换路径 '{folder_c}' 匹配到多个路径{matchDirs}，无法完成跳转{RESET}", file=sys.stderr)
            print(args.folder_b)
            exit(0)

    # 执行路径转换
    result_path = transform_path(args.folder_a, args.folder_b, folder_c)
    if result_path is None:
        result_path = os.path.join(args.folder_a, folder_c)

    # 回溯直到找到存在的路径
    while not os.path.exists(result_path) and result_path != args.folder_a:
        result_path = os.path.dirname(result_path)
    print(result_path)
