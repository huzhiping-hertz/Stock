import pandas as pd
import tushare as ts
from sqlalchemy import create_engine ,text
from DataBase import DataBase

class DBPriceModel (DataBase):

    def __init__(self):
        DataBase.__init__(self)

    def readData(self):
        sql = "SELECT * FROM PriceModel"
        df = pd.read_sql_query(text(sql), self.engine_ts.connect())
        return df
    
    def readSingle(self,id):
        sql = "SELECT * FROM PriceModel where id="+str(id)
        df = pd.read_sql_query(text(sql), self.engine_ts.connect())
        return df

    def writeData(self,df):
        res = df.to_sql('PriceModel', self.engine_ts, index=True)
        print(res)

