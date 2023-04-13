import tushare as ts

class StockBase ():
    def __init__(self):
        ts.set_token('dd727566dbab0597a4d210ad9b15f9efb568bd3b4fbc15377e558384')
        self.pro=pro = ts.pro_api()