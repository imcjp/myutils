import os
import filecmp
import argparse
import colorama
from difflib import unified_diff

# ANSI escape sequences for terminal colors
RED = colorama.Fore.RED
GREEN = colorama.Fore.GREEN
YELLOW = colorama.Fore.YELLOW
RESET = colorama.Fore.RESET
BLUE = colorama.Fore.BLUE

def find_files(directory):
    """递归地找出所有文件的路径"""
    for root, dirs, files in os.walk(directory):
        for filename in files:
            yield os.path.join(root, filename)


def is_text_file(file_path, blocksize=512):
    """检查文件是否为文本文件"""
    def can_decode(text_block):
        try:
            text_block.decode('utf-8')
            return True
        except UnicodeDecodeError:
            return False

    with open(file_path, 'rb') as file:
        block_size = 512
        min_size = 500
        while block_size >= min_size:
            file.seek(0)
            block = file.read(block_size)
            if can_decode(block):
                return True
            block_size -=1

    return False

def color_diff(diff_lines):
    """为diff的输出添加颜色和行号"""
    src_line_no = 0
    tgt_line_no = 0

    for i, line in enumerate(diff_lines):
        if i==0:
            yield f"{RED}源文件:  \t{line}{RESET}"
            continue
        if i==1:
            yield f"{GREEN}目标文件:\t{line}{RESET}"
            continue
        if line.startswith('-'):
            src_line_no += 1
            yield f"{RED}{src_line_no:4} {line}{RESET}"
        elif line.startswith('+'):
            tgt_line_no += 1
            yield f"{GREEN}{tgt_line_no:4} {line}{RESET}"
        elif line.startswith('@@'):
            # Extract line numbers
            numbers = line.split()[1:3]
            src_line_no = int(numbers[0].split(',')[0][1:]) - 1  # Remove the '-' prefix and convert to int
            tgt_line_no = int(numbers[1].split(',')[0][1:]) - 1  # Remove the '+' prefix and convert to int
            yield line
        else:
            # For lines that are in both files (context lines), increment both line numbers
            src_line_no += 1
            tgt_line_no += 1
            if src_line_no == tgt_line_no:
                yield f"{src_line_no:4} {line}"
            else:
                yield f"{src_line_no:4}>{tgt_line_no} {line}"

def compare_files(file_a, file_b, pause=False):
    """比较两个文件的内容，并打印出不同之处"""
    if is_text_file(file_a) and is_text_file(file_b):
        with open(file_a, 'r') as f_a, open(file_b, 'r') as f_b:
            lines_a = f_a.readlines()
            lines_b = f_b.readlines()

            # 使用unified_diff得到文件内容差异
            diff = list(unified_diff(lines_a, lines_b, fromfile=file_a, tofile=file_b))

            if diff:
                # 为diff输出添加颜色
                for line in color_diff(diff):
                    print(line, end='')

                if pause:
                    print()
                    input("按回车键继续下一个文件的比较...")
    else:
        print(f"文件 {file_a} 或 {file_b} 不是文本文件，跳过比较。")

def find_and_compare(folder_a, folder_b, pause=False):
    if os.path.isdir(folder_a) and os.path.isdir(folder_b):
        """在文件夹B中找出文件夹A中已经存在的文件，并比较它们"""
        files_in_a = {os.path.relpath(f, folder_a): f for f in find_files(folder_a)}

        fid=1
        for file_b in find_files(folder_b):
            filename = os.path.relpath(file_b, folder_b)
            if filename in files_in_a:
                file_a = files_in_a[filename]
                if not filecmp.cmp(file_a, file_b, shallow=False):
                    print(f"({fid}) 文件 {file_a} 和 {file_b} 存在差异：")
                    compare_files(file_a, file_b, pause)
                    print("\n")
                else:
                    print(f"({fid}) {BLUE}文件 {file_a} 和 {file_b} 相同。{RESET}")
            else:
                print(f"({fid}) {YELLOW}文件 {file_b} 在文件夹 {folder_a} 中不存在，跳过比较。{RESET}")
            fid+=1
    elif os.path.isfile(folder_a) and os.path.isfile(folder_b):
        file_a=folder_a
        file_b=folder_b
        if not filecmp.cmp(file_a, file_b, shallow=False):
            print(f"文件 {file_a} 和 {file_b} 存在差异：")
            compare_files(file_a, file_b, False)
            print("\n")
        else:
            print(f"{BLUE}文件 {file_a} 和 {file_b} 相同。{RESET}")
    else:
        xx=True
        if not os.path.exists(folder_a):
            print(f"{RED}路径 {folder_a} 不存在，无法比较。{RESET}")
            xx=False
        if not os.path.exists(folder_b):
            print(f"{RED}路径 {folder_b} 不存在，无法比较。{RESET}")
            xx=False
        if xx:
            print(f"{RED}路径 {folder_a} 和 {folder_b} 必须同为文件或者文件夹，无法比较！{RESET}")


def find_corresponding_path(folder_a, folder_b, subfolder):
    # 确保文件夹A和文件夹B存在
    if not os.path.isdir(folder_a) or not os.path.isdir(folder_b):
        print(f"{RED}若设置sub_folder: {subfolder}，则路径 {folder_a} 和路径B必须都为文件夹{RESET}")
        return None

    # 确保子文件夹确实是其中一个文件夹的子文件夹
    if not (subfolder.startswith(folder_a) or subfolder.startswith(folder_b)):
        print(f"{RED}若设置sub_folder: {subfolder}，sub_folder必须是文件夹 {folder_a} 或文件夹 {folder_b} 的子文件{RESET}")
        return None

    # 计算子文件夹相对于文件夹A或文件夹B的相对路径
    if subfolder.startswith(folder_a):
        relative_path = os.path.relpath(subfolder, folder_a)
        corresponding_path = os.path.join(folder_b, relative_path)
        folder_a=subfolder
        folder_b=corresponding_path
    else:
        relative_path = os.path.relpath(subfolder, folder_b)
        corresponding_path = os.path.join(folder_a, relative_path)
        folder_b=subfolder
        folder_a=corresponding_path

    return (folder_a,folder_b)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="该脚本比较两个文件夹中文件的差异。它识别两个目录中具有相同名称的文件，并比较其内容，从而打印出FOLDER_A中的文件到FOLDER_B中文件的变化。其中，FOLDER_A和FOLDER_B也可以是文件。")
    parser.add_argument('folder_a', type=str, help="第一个文件夹（文件）的路径。")
    parser.add_argument('folder_b', type=str, help="第二个文件夹（文件）的路径。")
    parser.add_argument('sub_folder', type=str, nargs='?', help="可选。若前两个参数为文件夹，则该参数应该是上述文件夹之一的子路径。若设置该参数，则比较的路径自动变为该路径和另一个文件夹相对应的子路径。")
    parser.add_argument('-p', '--pause', action='store_true', help="若设置比较每个文件后暂停。若为文件，无效。")
    parser.add_argument('-r', '--reverse', action='store_true', help="反转文件夹的顺序。")

    args = parser.parse_args()

    folder_a = args.folder_a
    folder_b = args.folder_b

    if args.reverse:
        folder_a, folder_b = folder_b, folder_a

    folder_a = os.path.abspath(folder_a)
    folder_b = os.path.abspath(folder_b)

    subfolder = args.sub_folder if args.sub_folder else None

    if subfolder is not None:
        subfolder = os.path.abspath(subfolder)
        res=find_corresponding_path(folder_a,folder_b,subfolder)
        if res is not None:
            (folder_a, folder_b)=res
            print(f'{GREEN}文件夹（文件）A更新为: {folder_a}{RESET}')
            print(f'{GREEN}文件夹（文件）B更新为: {folder_b}{RESET}')
        else:
            folder_a=None

    if folder_a is not None and folder_b is not None:
        find_and_compare(folder_a, folder_b, pause=args.pause)

