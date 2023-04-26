from fastapi import APIRouter
from controllers.ModelController import ModelController
import numpy as np
import pandas as pd
import json
from models.ParamModel import ParamModel,ParamUpdateModel
from models.DBModel import DBModel

router = APIRouter()

@router.get("/model")
def get_models():
    model=DBModel()
    df=model.getData()
    rs=df.to_json(orient="records")
    return rs

@router.get("/model/{id}")
def get_model_by_id(id):
    model=DBModel()
    df=model.getDataById(id)
    rs=df.to_json(orient="records")
    return rs

@router.post("/model")
def save_model(item:ParamModel):
    db=DBModel()
    df=pd.read_json(item.json(),orient="index")
    db.writeData(df.T)
    
@router.post("/model/update")
def update_model(item:ParamUpdateModel):
    db=DBModel()
    db.updateData(item.id,item.data)

@router.get("/model/delete/{id}")
def delete_models(id):
    model=DBModel()
    df=model.deleteDataById(id)