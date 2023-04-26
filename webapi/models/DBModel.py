import pandas as pd
import tushare as ts
from sqlalchemy import create_engine ,text
from models.DataBase import DataBase
from sqlalchemy.exc import SQLAlchemyError

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
        
    def updateData(self,id,points):
        sql="update ModelData set data='{0}' where id={1}".format(points,id)
        print(sql)
        conn=self.engine_ts.connect()
        conn.execute(text(sql))
        conn.commit()

    def deleteDataById(self,id):
        sql = "delete from  ModelData where id="+id+""
        print(sql)
        with self.engine_ts.connect() as conn:
            try:
                result = conn.execute(text(sql))
                conn.commit()
            except SQLAlchemyError as e:
                #print(e)
                error = str(e.__dict__['orig'])
                print(error)
            else:
                print("No of Records deleted : ",result.rowcount)