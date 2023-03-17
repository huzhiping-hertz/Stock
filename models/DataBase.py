import pandas as pd
import tushare as ts
from sqlalchemy import create_engine 
from sqlalchemy import text
from random import random
import string 

class DataBase ():

    def __init__(self):
        #self.engine_ts = create_engine('mysql+pymysql://root:90op90op@127.0.0.1:3306/Stock',echo=True)
        self.engine_ts = create_engine('sqlite:///stock.db')