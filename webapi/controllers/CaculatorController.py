import sys
from PySide6.QtCore import Qt, Slot,QObject
from PySide6 import QtCore
from PySide6.QtQml import QmlElement

from controllers.PandasModel import PandasModel
from PySide6.QtQml import QQmlApplicationEngine
from models.DBQFQ import DBQFQ
from models.Stock import Stock
from models.DBModel import DBModel
from scipy.stats import pearsonr 
import numpy as np
import pandas as pd

QML_IMPORT_NAME = "RS.Controllers.CaculatorController"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement
class CaculatorController(QObject):

    def __init__(self):
        QObject.__init__(self)

    
    @Slot(str,str,str,str,str, result=str)
    def correlation_pearson(self,ts_code,startDate,stopDate,fieldName,modelName):
        stockObj=DBQFQ()
        stockDF=stockObj.readData(ts_code,startDate,stopDate)
        modelObj=DBModel()
        modelDF=modelObj.getDataByName(modelName)
        
        global corr_vals 
        corr_vals= modelDF.iat[0,1].split(",")
        corr_vals=list(map(float,corr_vals))
        corr_vals=np.array(list(map(float,corr_vals)))
        corr= stockDF.rolling(window=len(corr_vals)).apply(self.get_correlation)
        print(corr)
        rs=corr.to_json(orient="records")
        return rs
    
    def get_correlation(self,vals):
        return pearsonr(vals, corr_vals)[0]
        

    @Slot(str,str,result=str)
    def getCorrilationData(self,ts_code,modelName):
        db=DBModel()
        df=db.getDataByName(modelName)
        mdata=df.iloc[0,1].split(",")
        modelDatas=list(map(float,mdata))
        modelDF=pd.DataFrame({"model":modelDatas})
        #print(modelDF)
        db=DBQFQ()
        df=db.readLastData(ts_code,len(modelDatas))
        #print(df)
        df=pd.merge(modelDF,df,left_index=True,right_index=True)
        rs=df.corr(method='pearson')
        #print(rs.iloc[[0],[1:2]])
        print(rs.iloc[0:1, 1:])
        return rs.iloc[0:1, 1:]
    
    @Slot(str,result=str)
    def getAllCorrilationData(self,modelName):
        db=DBModel()
        df=db.getDataByName(modelName)
        mdata=df.iloc[0,1].split(",")
        modelDatas=list(map(float,mdata))
        modelDF=pd.DataFrame({"model":modelDatas})
        #print(modelDF)
        
        db=DBQFQ()
        stocks=db.getStocks().values
        frames =[]
        names=[]
        for item in stocks:
            df=db.readLastData(item[0],len(modelDatas))
            df=pd.merge(modelDF,df,left_index=True,right_index=True)
            rs=df.corr(method='pearson')
            rs= rs.iloc[0:1, 1:]
            frames.append(rs)
            names.append(item[0])
            print(rs)
        rs=pd.concat(frames,ignore_index=True)
        rs=rs.round(2)
        codeDF=pd.DataFrame({"code":names})
        rs=rs.merge(codeDF,left_index=True,right_index=True)
        print(rs)
        rs=rs.to_json(orient="records")
        print(rs)
        return rs
        