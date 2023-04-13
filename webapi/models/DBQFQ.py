import pandas as pd
import tushare as ts
from sqlalchemy import create_engine ,text
from models.DataBase import DataBase

class DBQFQ (DataBase):

    def __init__(self):
        DataBase.__init__(self)

    def getStocks(self):
        sql = "select distinct ts_code from QFQData"
        df = pd.read_sql_query(text(sql), self.engine_ts.connect())
        return df
    
    def readData(self):
        sql = "SELECT * FROM QFQData LIMIT 20"
        df = pd.read_sql_query(text(sql), self.engine_ts.connect())
        return df
    
    def readLastData(self,ts_code,num):
        sql = "select pre_close,high from (SELECT * FROM QFQData where ts_code='"+ts_code+"' order by trade_date desc limit "+str(num)+") tmp order by trade_date"
        df = pd.read_sql_query(text(sql), self.engine_ts.connect())
        return df

    def readPriceData(self,ts_code,start_date,num):
        sql = "SELECT pre_close FROM QFQData where ts_code='"+ts_code+"' and trade_date>"+start_date+" order by trade_date  limit "+str(num)
        df = pd.read_sql_query(text(sql), self.engine_ts.connect())
        return df
    
    def readData(self,ts_code,startDate,stopDate):
        sql = "select pre_close from  QFQData where ts_code='"+ts_code+"' and trade_date>= "+startDate+" and trade_date<="+stopDate+" order by trade_date"
        print(sql)
        df = pd.read_sql_query(text(sql), self.engine_ts.connect())
        return df
    
    
    def writeData(self,df):
        res = df.to_sql('QFQData', self.engine_ts, index=False,if_exists='append', chunksize=5000)

