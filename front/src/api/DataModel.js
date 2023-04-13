import axios from 'axios'

export function getModels()
{
  return axios.get('http://127.0.0.1:8000/model');
}

export function getModelByName(name)
{
  return axios.get('http://127.0.0.1:8000/model/'+name);
}

