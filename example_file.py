with open('example_file.txt') as f:
    upper_lines = [l.strip().upper() for l in f.readlines()]
    print upper_lines
