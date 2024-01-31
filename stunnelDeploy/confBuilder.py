import yaml
import argparse
from argparse import Namespace
from itertools import chain
import sys


def flat(two_dimensional_list):
    return list(chain(*two_dimensional_list))
# 函数用于解析等号后面的表达式
def parse_expression(expression, data):
    return eval(expression, {'data': data, 'flat': flat}, {})

# 检查所有列表长度是否相等
def check_list_lengths(conf):
    list_lengths = [len(v) for k, v in conf.items() if isinstance(v, list)]
    if list_lengths and not all(length == list_lengths[0] for length in list_lengths):
        raise ValueError("Not all list lengths in the configuration are equal.")

# 生成配置文件内容
def generate_configs(rules):

    for key, rule in rules.items():
        data = Namespace(**rule.get('data', {}))
        conf = rule['conf']
        for conf_key, conf_value in conf.items():
            # 如果配置值以等号开头，解析表达式
            if isinstance(conf_value, str) and conf_value.startswith('='):
                expression=conf_value[1:]
                print(f'解析配置{key}.{conf_key}，解析表达式为：{expression}', file=sys.stderr)
                conf[conf_key] = parse_expression(expression, data)
        check_list_lengths(conf)

        # 获取列表长度，如果没有列表，默认长度为1
        num_configs = max((len(v) for k, v in conf.items() if isinstance(v, list)), default=1)


        # 生成多个配置
        for i in range(num_configs):
            config_name = f"{key}_{i}"
            print(f"[{config_name}]")
            for conf_key, conf_value in conf.items():
                # 如果配置值以等号开头，解析表达式
                if isinstance(conf_value, list):
                    print(f"{conf_key} = {conf_value[i]}")
                else:
                    print(f"{conf_key} = {conf_value}")
            print()  # 在配置之间添加空行

def build(yaml_file_name):
    # 从文件读取YAML内容
    try:
        with open(yaml_file_name, 'r', encoding='utf-8') as file:
            yaml_content = file.read()
    except IOError as e:
        print(f"Error opening file: {e}", file=sys.stderr)
        exit(1)

    # 解析YAML内容
    try:
        rules = yaml.safe_load(yaml_content)['rules']
    except yaml.YAMLError as e:
        print(f"Error parsing YAML file: {e}", file=sys.stderr)
        exit(1)

    # 调用函数生成配置
    try:
        generate_configs(rules)
    except ValueError as e:
        print(f"Error in configuration: {e}", file=sys.stderr)
        exit(1)

if __name__ == '__main__':
    # 设置命令行参数解析
    parser = argparse.ArgumentParser(description='Generate configurations from a YAML file.')
    parser.add_argument('yaml_file', type=str, help='The YAML file to process.')

    # 解析命令行参数
    args = parser.parse_args()

    # 从命令行参数读取YAML文件名称
    yaml_file_name = args.yaml_file

    # 从文件读取YAML内容
    build(yaml_file_name)