import sys

from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuick import QQuickView
from PySide6.QtQml import qmlRegisterType

from controllers.StockController import StockController
from controllers.PandasModel import PandasModel
from controllers.TestModel import TestModel
from controllers.StockController import StockController

from models.DBQFQ import DBQFQ

app = QApplication(sys.argv)
engine = QQmlApplicationEngine()

model=DBQFQ()
df=model.readLastData(ts_code='000001.SZ',num=5)
model = PandasModel(df)
engine.rootContext().setContextProperty("qfqmodel", model)

stockCtl=StockController(engine)
engine.rootContext().setContextProperty("stockCtl", stockCtl)

#qmlRegisterType(PandasModel, 'PandasModel', 1, 0, 'PandasModel')

engine.quit.connect(app.quit)
engine.load('views/master.qml')

sys.exit(app.exec())