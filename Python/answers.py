import sys
import json
import requests
import re
from datetime import datetime

"""
The data source has a intentional problem in the name column. 
Where some names have a comma as part of it self. 
If the programmer is not careful when converting the formats thinks can go wrong.
"""

ESCAPE = '"'
SEPARATOR = ','
EOL = "\n"


def read_json_to_rows(filepath):
    """
    Source code here is about items 1 and 2 from read-me.pdf file

    :parameter filepath str
    :return list
    """
    content = ""

    with open(filepath, "r") as i:
        content += i.read()

    return json.loads(content)


def usd_to_brl():
    """
    Source code here is about items 3 and 4 from read-me.pdf file

    :return float
    """
    response = requests.get('https://economia.awesomeapi.com.br/last/USD-BRL')
    data = response.json()
    return round(float(data['USDBRL']['bid']), 2)


def update_rows_price(rows, brl):
    """
    Source code here is about item 5 from read-me.pdf file

    :parameter rows list
    :parameter brl float
    :return list
    """
    for row in rows:
        price = row['price'] * brl
        row['price'] = round(price, 2)

    return rows


def create_rows_new_columns(rows):
    """
    Source code here is about item 6 from read-me.pdf file

    :parameter rows list
    :return list
    """
    now = datetime.today()

    for row in rows:
        row['created_at'] = now.strftime("%Y-%m-%d %H:%M:%S")
        row['update_at'] = now.strftime("%Y-%m-%d %H:%M:%S")
        row['delete_at'] = ""

    return rows


def rows_to_csv(rows, filepath):
    """
    Source code here is about items 7, 8, 11 from read-me.pdf file

    :parameter rows list
    :parameter filepath str
    :return pass
    """
    content = ""

    # Header
    keys = list(rows[0].keys())
    keys = [ESCAPE + val + ESCAPE for val in keys]
    content += ','.join(keys) + EOL

    # Body
    for row in rows:
        row = [ESCAPE + str(val)  + ESCAPE for val in row.values()]
        content += ','.join(row) + EOL

    file = open(filepath, "w")
    file.write(content)
    file.close()
    pass


def csv_to_rows(filepath):
    """
    Source code here is about items 9 from read-me.pdf file

    :parameter filepath str
    :return list
    """
    regex = re.compile('\"\,\"')
    file = open(filepath, "r")
    lines = file.readlines()
    rows = []

    # Header
    line = lines[0]
    keys = regex.split(line.strip())
    keys = [key.strip('"') for key in keys]

    for line in lines[1:]:
        values = regex.split(line.strip())
        values = [value.strip('"') for value in values]
        rows.append(dict(zip(keys, values)))

    return rows


def filter_rows_for_delete(rows):
    """
    Source code here is about items 1 and 2 from read-me.pdf file

    :parameter filepath str
    :return list
    """
    now = datetime.today()

    for row in rows:
        if float(row['price'])  >= 275:
            row['delete_at'] = now.strftime("%Y-%m-%d %H:%M:%S")

    return rows


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
