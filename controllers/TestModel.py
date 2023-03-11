import sys
from PySide6.QtCore import Qt, Slot,QObject
from PySide6 import QtCore
from PySide6.QtQml import QmlElement
from models.DBQFQ import DBQFQ
from controllers.PandasModel import PandasModel

QML_IMPORT_NAME = "RS.Controllers.TestModel"
QML_IMPORT_MAJOR_VERSION = 1
   
@QmlElement
class TestModel(QObject):

    @Slot(str, result=int)
    def test(self,str):
        return 100