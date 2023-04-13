import sys
from PySide6.QtCore import Qt, Slot,QObject
from PySide6 import QtCore
from PySide6.QtQml import QmlElement

from controllers.PandasModel import PandasModel
from PySide6.QtQml import QQmlApplicationEngine
from models.DBModel import DBModel


QML_IMPORT_NAME = "RS.Controllers.ModelController"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement
class ModelController(QObject):

    def __init__(self):
        QObject.__init__(self)

    
    @Slot(result=str)
    def getData(self):
        model=DBModel()
        df=model.getData()
        rs=df.to_json(orient="records")
        return rs
    
    @Slot(str,result=str)
    def getDataByName(self,name):
        model=DBModel()
        df=model.getDataByName(name)
        rs=df.to_json(orient="records")
        return rs

    @Slot(result=str)
    def getNames(self):
        model=DBModel()
        df=model.getNames()
        rs=df.to_json(orient="values")
        return rs