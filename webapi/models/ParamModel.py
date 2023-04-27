from pydantic import BaseModel
from typing import Union

class ParamModel(BaseModel):
    name: str
    data: str

class ParamUpdateModel(BaseModel):
    id: int
    data: str

class ParamCorrelation(BaseModel):
    code: str
    models: str