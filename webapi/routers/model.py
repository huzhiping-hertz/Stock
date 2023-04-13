from fastapi import APIRouter
from controllers.ModelController import ModelController

router = APIRouter()

@router.get("/model")
def get_models():
    ctl =ModelController()
    return ctl.getData()

@router.get("/model/{name}")
def get_model_by_name(name):
    ctl =ModelController()
    rs=ctl.getDataByName(name)
    return rs