import pandas as pd
import tushare as ts
from sqlalchemy import create_engine 

class DataBase ():

    def __init__(self):
        self.engine_ts = create_engine('mysql+pymysql://root:90op90op@127.0.0.1:3306/Stock',echo=True)