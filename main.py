import argparse
import time
import shlex
import sys
import pandas as pd
from models.Stock import Stock;
from models.DBDaily import DBDaily
from models.DBBasic import DBBasic
from models.DBQFQ import DBQFQ
from models.DBModel import DBModel
from models.DBPriceModel import DBPriceModel
from DrawLine import DrawLine
from scipy.stats import pearsonr 
import numpy as np
import mmap

def storeQFQData(ts_code,start_date,end_date):
     stock=Stock()
     qfqData=stock.getQFQInfo(tscode=ts_code, sdate=start_date, edate=end_date)
     db=DBQFQ()
     db.writeData(qfqData)

def storeStockBasic():
     stock=Stock()
     basic_data=stock.getBasicData()
     dbBasic=DBBasic()
     dbBasic.writeBasic(basic_data)

def storeDailyData():
     stock=Stock()
     dates=stock.getTradeDate(sdate='20180101',edate='20181231')
     for date in dates['cal_date'].values:
          data = stock.getDailyInfo(trade_date=date)
          daily=DBDaily()
          daily.writeData(data)

def readBasicData():
     dbBasic=DBBasic()
     df=dbBasic.readData()
     print(df)

def drawSingleStock(ts_code,num):
     db=DBQFQ()
     df=db.readLastData(ts_code,num)
     draw=DrawLine()
     draw.drawLine(df)

def getModel(mid):
     db=DBPriceModel()
     df=db.readSingle(id=mid)
     mdata=df.iloc[0,2].split(",")
     rs=list(map(float,mdata))
     df=pd.DataFrame({"model":rs})
     return df

def caculateCor(ts_code,modelId):
     model=getModel(mid=modelId)
     db=DBQFQ()
     df=db.readLastData(ts_code=ts_code,num=21)
     #rs=pd.merge(model/model.max(),df/df.max(),left_index=True,right_index=True)
     rs=pd.merge(model,df,left_index=True,right_index=True)
     print(rs)
     print(rs.corr(method='pearson'))

# def getArgs():
#     parser = argparse.ArgumentParser(description='Get Stock Data...')
#     parser.add_argument('ts_code', type=str, nargs='+',help='input code')
#     parser.add_argument('start_date', type=str, nargs='+',help='input start date')
#     parser.add_argument('stop_date', type=str, nargs='+',help='input stop date')
#     args = parser.parse_args()
#     print(args)


def main() -> int:
    #stock=Stock()
    #df=stock.getBasicData()
    #print(df)
    #storeDailyData()
    #storeStockBasic()
    #storeQFQData(ts_code='000001.SZ', start_date='20201011', end_date='20230224')
    #storeQFQData(ts_code='000002.SZ', start_date='20201011', end_date='20230224')
    #drawSingleStock(ts_code='000001.SZ',num=200)
    #caculateCor(ts_code='000001.SZ',modelId=1)


     # stockObj=DBQFQ()
     # stockDF=stockObj.readData('000001.SZ',"20221001","20230310")
     
     # modelObj=DBModel()
     # modelDF=modelObj.getDataByName("V")
     
     # global corr_vals 
     # corr_vals= modelDF.iat[0,1].split(",")
     # corr_vals=list(map(float,corr_vals))
     
     # stockDF = pd.DataFrame(dict(x=corr_vals))
     
     # corr_vals=np.array(list(map(float,corr_vals)))
     
     # print(corr_vals)
     # corr= stockDF.rolling(window=len(corr_vals)).apply(get_correlation)
     # print(corr.values)
     #print(df)
     #rs=df.to_json(orient="records")
     #return rs
     db=DBModel()
     df=db.getDataByName("V")
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
     codeDF=pd.DataFrame({"code":names})
     rs=rs.merge(codeDF,left_index=True,right_index=True)
     print(rs)
     rs=rs.to_json(orient="records")
     print(rs)
     
def get_correlation(vals):
     return pearsonr(vals, corr_vals)[0]
     

if __name__ == '__main__':
    sys.exit(main()) 