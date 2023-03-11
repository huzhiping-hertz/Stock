import sys

from PySide6.QtCore import Qt, QAbstractTableModel, QUrl

class BasicModel(QAbstractTableModel):
    def __init__(self, data):
        super(BasicModel, self).__init__()
        self._data = data

    def headerData(self, section, orientation, role):

        if role == Qt.DisplayRole:
            return f"Test {section}"

    def data(self, index, role):
        if role == Qt.DisplayRole:
            return self._data[index.row()][index.column()]

    def rowCount(self, index):
        return len(self._data)

    def columnCount(self, index):
        return len(self._data[0])
