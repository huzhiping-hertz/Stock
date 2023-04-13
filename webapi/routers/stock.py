from fastapi import APIRouter
from controllers.StockController import StockController

from models.DBBasic import DBBasic;
from models.DBQFQ import DBQFQ
from models.Stock import Stock;

router = APIRouter()

##获取股票基本信息
@router.get("/stock/codes")
def get_stock_codes():
    db=DBBasic()
    df=db.readData()
    rs=df.to_json(orient="records")
    return rs

@router.get("/stock/qfq/{code}/{start}/{stop}")
def get_model_by_name(code,start,stop):
    ctl =StockController()
    rs=ctl.getData(code,start,stop)
    return rs

##数据同步
@router.get("/sync/{code}/{start}/{stop}")
def syn_stock_data(code, start, stop):
    stock=Stock()
    qfqData=stock.getQFQInfo(code, start, stop)
    db=DBQFQ()
    db.writeData(qfqData)