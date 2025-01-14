import sys


def get_size(bytes_size, suffix="B"):
    """
    Scale bytes to its proper format
    e.g:
        1253656 => '1.20MB'
        1253656678 => '1.17GB'
    """
    units = ["", "K", "M", "G", "T", "P"]
    factor = 1024
    if (bytes_size) > (10**18):
        raise ValueError("bytes is too big to handle use proper tool not this.")
    for unit in units:
        if bytes_size < factor:
            return f"{bytes_size:.2f}{unit}{suffix}"
        bytes_size /= factor


def main():
    if len(sys.argv) <= 1:
        print(f"example usage is {__file__} x \n  x as bytes")
        return
    byt_num = int(sys.argv[1])
    print(get_size(byt_num))


if __name__ == "__main__":
    main()
