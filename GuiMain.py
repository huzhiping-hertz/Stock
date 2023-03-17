import sys

from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuick import QQuickView
from PySide6.QtQml import qmlRegisterType

from controllers.StockController import StockController
from controllers.PandasModel import PandasModel
from controllers.ModelController import ModelController
from controllers.CaculatorController import CaculatorController

from models.DBQFQ import DBQFQ

app = QApplication(sys.argv)
engine = QQmlApplicationEngine()


engine.quit.connect(app.quit)
engine.load('views/master.qml')

sys.exit(app.exec())