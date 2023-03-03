import tushare as ts
from StockBase import StockBase 
import time

class Stock (StockBase):

    def __init__(self):
        StockBase.__init__(self)

    def getBasicData(self):
        data = self.pro.query('stock_basic', exchange='', list_status='L', fields='ts_code,symbol,name,area,industry,list_date')
        return data
    
    def getDailyInfo(self, ts_code='', trade_date='', start_date='', end_date=''):
        for _ in range(3):
            try:
                if trade_date:
                    df = self.pro.daily(ts_code=ts_code, trade_date=trade_date)
                else:
                    df = self.pro.daily(ts_code=ts_code, start_date=start_date, end_date=end_date)
            except:
                    time.sleep(1)
            else:
                return df
            
    def getTradeDate(self,sdate,edate):
        df = self.pro.trade_cal(is_open='1', start_date=sdate, end_date=edate, fields='cal_date')
        return df
    
    def getQFQInfo(self,tscode,sdate,edate):
        df = ts.pro_bar(ts_code=tscode, adj='qfq', start_date=sdate, end_date=edate)
        return df