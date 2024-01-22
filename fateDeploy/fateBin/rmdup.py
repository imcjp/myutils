import os
import argparse
import filecmp


def get_all_files_recursive(root_dir):
    """递归获取目录下的所有文件的完整路径"""
    all_files = {}
    for root, dirs, files in os.walk(root_dir):
        for file in files:
            full_path = os.path.join(root, file)
            # 使用文件路径相对于根目录的部分作为字典的键
            relative_path = os.path.relpath(full_path, root_dir)
            all_files[relative_path] = full_path
    return all_files


def remove_empty_folders(path):
    """递归删除空文件夹"""
    if not os.path.isdir(path):
        return

    # 删除空子文件夹
    files = os.listdir(path)
    if len(files):
        for f in files:
            full_path = os.path.join(path, f)
            if os.path.isdir(full_path):
                remove_empty_folders(full_path)

    # 如果文件夹为空，则删除之
    files = os.listdir(path)
    if len(files) == 0:
        os.rmdir(path)
        print(f"Removed empty folder: {path}")


def remove_duplicates(folder_a, folder_b, name_compare=False, remove_empty_folder=False):
    # 获取两个文件夹中的所有文件
    files_in_a = get_all_files_recursive(folder_a)
    files_in_b = get_all_files_recursive(folder_b)

    # 找出文件名相同的文件
    common_files = set(files_in_a.keys()).intersection(files_in_b.keys())

    # 遍历文件夹 B 中的文件
    for relative_path in common_files:
        path_a = files_in_a[relative_path]
        path_b = files_in_b[relative_path]

        # 如果 name_compare 为 False，则比较文件内容
        if not name_compare:
            if os.path.isfile(path_a) and os.path.isfile(path_b) and filecmp.cmp(path_a, path_b, shallow=False):
                os.remove(path_a)
                print(f"Removed '{path_a}' as it is duplicate of '{path_b}' based on content.")
        # 否则，只比较文件名
        else:
            if os.path.isfile(path_a):
                os.remove(path_a)
                print(f"Removed '{path_a}' as it has the same name as a file in '{path_b}'.")

    # 执行完删除任务后，递归删除空文件夹
    if remove_empty_folder:
        remove_empty_folders(folder_a)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="""
        This script removes files in 'folder_a' that are duplicates of files in 'folder_b'.
        A file is considered a duplicate if it has the same relative path and file name.
        If the '--name-compare' flag is provided, it compares the name of the files
        only before deletion. After removing duplicate files, it also recursively
        removes all empty folders within 'folder_a'.
        """,
                                     formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument(
        "folder_a",
        help="The path to the folder (folder_a) from which you want to remove duplicates. \n"
             "Note: Contents of this folder may be altered during the process."
    )
    parser.add_argument(
        "folder_b",
        help="The path to the folder (folder_b) that contains the reference files to compare with."
    )
    parser.add_argument("-n", "--name-compare",
                        help="Enable file name comparison to determine duplicates.\n"
                             "Otherwise, compare file content to determine duplicates.\n"
                             "By default, file contents are compared.",
                        action="store_true")
    parser.add_argument("-r", "--remove-empty-folder",
                        help="Enable removing empty folders in folder A after remove duplicate files. \n"
                             "By default, do not remove empty folders.", action="store_true")

    args = parser.parse_args()

    remove_duplicates(args.folder_a, args.folder_b, args.name_compare, args.remove_empty_folder)
