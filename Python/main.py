import sys


def read_json_to_rows(filepath):
    """
    Source code here is about items 1 and 2 from read-me.pdf file

    :parameter filepath str
    :return list
    """
    # put your source code here
    return []


def usd_to_brl():
    """
    Source code here is about items 3 and 4 from read-me.pdf file

    :return float
    """
    # put your source code here
    return 5.5


def update_rows_price(rows, brl):
    """
    Source code here is about item 5 from read-me.pdf file

    :parameter rows list
    :parameter brl float
    :return list
    """
    # put your source code here
    return []


def create_rows_new_columns(rows):
    """
    Source code here is about item 6 from read-me.pdf file

    :parameter rows list
    :return list
    """
    # put your source code here
    return []


def rows_to_csv(rows, filepath):
    """
    Source code here is about items 7, 8, 11 from read-me.pdf file

    :parameter rows list
    :parameter filepath str
    :return pass
    """
    # put your source code here
    pass


def csv_to_rows(filepath):
    """
    Source code here is about items 9 from read-me.pdf file

    :parameter filepath str
    :return list
    """
    # put your source code here
    return []


def filter_rows_for_delete(rows):
    """
    Source code here is about items 1 and 2 from read-me.pdf file

    :parameter filepath str
    :return list
    """
    # put your source code here
    return []


try:

    rows = read_json_to_rows("./products.json")
    brl = usd_to_brl()

    if not rows:
        raise "Cannot read products.json"

    rows = update_rows_price(rows, brl)
    rows = create_rows_new_columns(rows)

    filepath = "./products.csv"
    rows_to_csv(rows, filepath)

    rows = csv_to_rows(filepath)

    rows = filter_rows_for_delete(rows)

    rows_to_csv(rows, filepath)

    print("success: file",  filepath, "was created\n")

    exit(0)
except Exception as e:
    print("error:", str(e))
    _, _, traceback = sys.exc_info()
    print("trace:", traceback)
    exit(1)
