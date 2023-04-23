import axios from 'axios'

export function getModels()
{
  return axios.get('http://127.0.0.1:8000/model');
}

export function getModelById(id)
{
  return axios.get('http://127.0.0.1:8000/model/'+id);
}

export function saveModel(mname,mdata)
{
  const json = JSON.stringify({ name: mname,data:mdata });
  const res = axios.post('http://127.0.0.1:8000/model/', json, {
    headers: {
      // Overwrite Axios's automatically set Content-Type
      'Content-Type': 'application/json'
    }
  });
  
}
