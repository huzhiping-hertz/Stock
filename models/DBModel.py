import pandas as pd
import tushare as ts
from sqlalchemy import create_engine ,text
from models.DataBase import DataBase

class DBModel (DataBase):

    def __init__(self):
        DataBase.__init__(self)
    
    def getData(self):
        sql = "select name,data from ModelData"
        print(sql)
        df = pd.read_sql_query(text(sql), self.engine_ts.connect())
        return df
    
    def getDataByName(self,name):
        sql = "select name,data from ModelData where name='"+name+"'"
        df = pd.read_sql_query(text(sql), self.engine_ts.connect())
        return df
    
    def getNames(self):
        sql = "select name from ModelData"
        print(sql)
        df = pd.read_sql_query(text(sql), self.engine_ts.connect())
        return df
    
    
    def writeData(self,df):
        res = df.to_sql('ModelData', self.engine_ts, index=False,if_exists='append', chunksize=5000)

