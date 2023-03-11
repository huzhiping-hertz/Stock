import argparse
import time
import shlex
import sys
import pandas as pd
from Stock import Stock;
from models import DBDaily
from models import DBBasic
from models import DBQFQ
from models import DBPriceModel
from DrawLine import DrawLine

def storeQFQData(ts_code,start_date,end_date):
     stock=Stock()
     qfqData=stock.getQFQInfo(tscode=ts_code, sdate=start_date, edate=end_date)
     db=DBQFQ()
     db.writeData(qfqData)
     print(qfqData)

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
    #storeDailyData()
    #storeQFQData(ts_code='000001.SZ', start_date='20201011', end_date='20230222')
    #drawSingleStock(ts_code='000001.SZ',num=200)
    caculateCor(ts_code='000001.SZ',modelId=1)
    return 0

if __name__ == '__main__':
    sys.exit(main()) 