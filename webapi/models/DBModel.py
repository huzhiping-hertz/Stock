import pandas as pd
import tushare as ts
from sqlalchemy import create_engine ,text
from models.DataBase import DataBase

class DBModel (DataBase):

    def __init__(self):
        DataBase.__init__(self)
    
    def getData(self):
        sql = "select id,name,data from ModelData"
        print(sql)
        df = pd.read_sql_query(text(sql), self.engine_ts.connect())
        return df
    
    def getDataById(self,id):
        sql = "select name,data from ModelData where id="+id+""
        print(sql)
        df = pd.read_sql_query(text(sql), self.engine_ts.connect())
        return df
    
    def getNames(self):
        sql = "select name from ModelData"
        print(sql)
        df = pd.read_sql_query(text(sql), self.engine_ts.connect())
        return df
    
    
    def writeData(self,df):
        res = df.to_sql('ModelData', self.engine_ts, index=False,if_exists='append', chunksize=5000)

