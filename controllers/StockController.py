import sys
from PySide6.QtCore import Qt, Slot,QObject
from PySide6 import QtCore
from PySide6.QtQml import QmlElement
from models.DBQFQ import DBQFQ
from controllers.PandasModel import PandasModel
from controllers.TestModel import TestModel
from PySide6.QtQml import QQmlApplicationEngine

QML_IMPORT_NAME = "RS.Controllers.StockController"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement
class StockController(QObject):

    def __init__(self, engine):
        QObject.__init__(self)
        self.engine = engine

    @Slot(int, result=str)
    def getData(self, num):
        model=DBQFQ()
        df=model.readLastData(ts_code='000001.SZ',num=num)
        rs=df.to_json(orient="records")
        return rs