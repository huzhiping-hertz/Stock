import pandas as pd
import tushare as ts
from sqlalchemy import create_engine ,text
from DataBase import DataBase

class DBDaily (DataBase):

    def __init__(self):
        DataBase.__init__(self)

    def readData(self):
        sql = "SELECT * FROM DailyData LIMIT 20"
        df = pd.read_sql_query(text(sql), self.engine_ts.connect())
        return df
    
    def readSingle(self,ts_code,start_date,end_date):
        sql = "select * from (SELECT * FROM DailyData where ts_code='"+ts_code+"' order by trade_date desc limit 100) tmp order by trade_date"
        df = pd.read_sql_query(text(sql), self.engine_ts.connect())
        return df

    def writeData(self,df):
        res = df.to_sql('DailyData', self.engine_ts, index=False,if_exists='append', chunksize=5000)
        print(res)

