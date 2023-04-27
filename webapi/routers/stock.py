from fastapi import APIRouter
from controllers.StockController import StockController
import numpy as np
import pandas as pd
from scipy.stats import pearsonr,spearmanr,kendalltau
from models.ParamModel import ParamCorrelation
from models.DBBasic import DBBasic;
from models.DBQFQ import DBQFQ
from models.Stock import Stock;
from models.DBModel import DBModel

router = APIRouter()

##获取股票基本信息
@router.get("/stock/codes")
def get_stock_codes():
    db=DBBasic()
    df=db.readData()
    rs=df.to_json(orient="records")
    return rs

##获取股票信息
@router.get("/stock/qfq/{code}/{start}/{stop}/{mid}")
def get_model_by_name(code,start,stop,mid):
    model=DBQFQ()
    df=model.readData(code,start,stop)
    
    modelObj=DBModel()
    modelDF=modelObj.getDataById(mid)

    global corr_vals 
    corr_vals= modelDF.iat[0,1].split(",")
    corr_vals=list(map(float,corr_vals))
    corr_vals=np.array(list(map(float,corr_vals)))
    pearsonr_corr= df.loc[:,"close"].rolling(window=len(corr_vals)).apply(get_pearsonr)
    spearmanr_corr= df.loc[:,"close"].rolling(window=len(corr_vals)).apply(get_spearmanr)
    kendalltau_corr= df.loc[:,"close"].rolling(window=len(corr_vals)).apply(get_kendalltau)
    df=pd.merge(df,pearsonr_corr,left_index=True,right_index=True)
    df=pd.merge(df,spearmanr_corr,left_index=True,right_index=True)
    df=pd.merge(df,kendalltau_corr,left_index=True,right_index=True)
    
    df=df.fillna(0)
    print(df)
    rs=df.to_json(orient="values")
    return rs

##数据同步
@router.get("/sync/{code}/{start}/{stop}")
def syn_stock_data(code, start, stop):
    stock=Stock()
    qfqData=stock.getQFQInfo(code, start, stop)
    db=DBQFQ()
    db.writeData(qfqData)
    
def get_pearsonr(vals,corr_vals):
    return round(pearsonr(vals, corr_vals)[0],2)
def get_spearmanr(vals):
    return round(spearmanr(vals, corr_vals)[0],2)
def get_kendalltau(vals):
    return round(kendalltau(vals, corr_vals)[0],2)

##计算相关性
@router.get("/stock/corr/{code}/{mname}")
def get_stock_corr(code,mname):

    modelObj=DBModel()
    modelDF=modelObj.getDataById(mname)
    global corr_vals 
    corr_vals= modelDF.iat[0,1].split(",")
    corr_vals=list(map(float,corr_vals))
    corr_vals=np.array(list(map(float,corr_vals)))
    
    model=DBQFQ()
    df=model.readLastData(code,len(corr_vals))
    
    corr= df.loc[:,"close"].rolling(window=len(corr_vals)).apply(get_pearsonr)
    df=pd.merge(df,corr,left_index=True,right_index=True)

    df=df.fillna(0)
    print(df)
    rs=df.iloc[-1].to_json()
    return rs

##计算相关性
@router.post("/stock/corr")
def get_stock_models_correlation(item:ParamCorrelation):

    modelObj=DBModel()
    modelDF=modelObj.getDataByIds(item.models)
    print(modelDF)
    
    model=DBQFQ()
    df=model.readLastData(item.code,50)
    
    #global corr_vals
    for ind in modelDF.index:
         
        corr_vals= modelDF["data"][ind].split(",")
        corr_vals=list(map(float,corr_vals))
        corr_vals=np.array(list(map(float,corr_vals)))
        #print(corr_vals)
        # model=DBQFQ()
        # df=model.readLastData(item.code,len(corr_vals))
        
        corr= df.iloc[:,1:2].rolling(window=len(corr_vals)).apply(get_pearsonr,args=(corr_vals,))
        df=pd.merge(df,corr,left_index=True,right_index=True,suffixes=('', '_'+str(modelDF["id"][ind])))
        
        # df=df.fillna(0)
        # print(df)
        # rs=df.iloc[-1].to_json()
        # print(rs)
    df["sum"]=df.iloc[:,2:].sum(axis=1)
    print(df)
    rs=df.iloc[-1].to_json()
    return rs