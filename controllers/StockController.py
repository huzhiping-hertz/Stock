import sys
from PySide6.QtCore import Qt, Slot,QObject
from PySide6 import QtCore
from PySide6.QtQml import QmlElement

from controllers.PandasModel import PandasModel
from PySide6.QtQml import QQmlApplicationEngine
from models.DBQFQ import DBQFQ
from models.Stock import Stock;
import json

QML_IMPORT_NAME = "RS.Controllers.StockController"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement
class StockController(QObject):

    def __init__(self):
        QObject.__init__(self)

    @Slot(result=str)
    def getStocks(self):
        model=DBQFQ()
        df=model.getStocks()
        rs=df.to_json(orient="values")
        return rs
    
    
    @Slot(str,str,str, result=str)
    def getData(self, ts_code,startDate,stopDate):
        model=DBQFQ()
        df=model.readData(ts_code,startDate,stopDate)
        rs=df.to_json(orient="records")
        return rs
    
    @Slot(str,str,str, result=str)
    def syncData(self,ts_code,startDate,stopDate):
        stock=Stock()
        qfqData=stock.getQFQInfo(ts_code, startDate, stopDate)
        db=DBQFQ()
        db.writeData(qfqData)