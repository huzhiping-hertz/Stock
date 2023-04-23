from pydantic import BaseModel
from typing import Union

class ParamModel(BaseModel):
    name: str
    data: str