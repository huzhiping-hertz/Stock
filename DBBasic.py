import pandas as pd
import tushare as ts
from sqlalchemy import create_engine ,text
from DataBase import DataBase

class DBBasic(DataBase):

    def __init__(self):
        DataBase.__init__(self)

    def writeBasic(self,df):
        res = df.to_sql('StockBasic', self.engine_ts, index=False, if_exists='append', chunksize=5000)
        print(res)

    def readData(self):
        sql = "SELECT * FROM StockBasic limit 20"
        df = pd.read_sql_query(text(sql), self.engine_ts.connect())
        return df