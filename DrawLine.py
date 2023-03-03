import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np


class DrawLine():

    def drawLine(self,df):
        plt.close("all")

        max_val=df.max()
        df['pre_close']=df['pre_close']/max_val['pre_close']
        df.plot(y=['pre_close','close'],legend=False,xlabel='Freq',ylabel='dB',kind='line',grid=True,figsize=(18,4),subplots=True)


        plt.show()
