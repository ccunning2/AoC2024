import re

with open("input.txt", "r") as file:
    corrupted_memory = file.read()

    corrupted_memory = re.sub(r"don't\(\).*?(?=do\(\)|$)", "", corrupted_memory, flags=re.DOTALL)
    occurences = re.findall("mul\(\d+,\d+\)", corrupted_memory)
    digits = [re.findall("\d+", occurence) for occurence in occurences]
    for pair in digits:
        print(f"[{pair[0]}, {pair[1]}]")

    print(sum([int(pair[0]) * int(pair[1]) for pair in digits]))