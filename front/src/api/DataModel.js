import axios from 'axios'

export function getModels()
{
  return axios.get('http://127.0.0.1:8000/model');
}

export function getModelById(id)
{
  return axios.get('http://127.0.0.1:8000/model/'+id);
}

export function delModelById(id)
{
  return axios.get('http://127.0.0.1:8000/model/delete/'+id);
}

export function saveModel(mname,mdata)
{
  const json = JSON.stringify({ name: mname,data:mdata });
  return axios.post('http://127.0.0.1:8000/model/', json, {
    headers: {
      // Overwrite Axios's automatically set Content-Type
      'Content-Type': 'application/json'
    }
  });
  
}
export function updateModel(mid,mdata)
{
  const json = JSON.stringify({ id: mid,data:mdata });
  return axios.post('http://127.0.0.1:8000/model/update', json, {
    headers: {
      // Overwrite Axios's automatically set Content-Type
      'Content-Type': 'application/json'
    }
  });
  
}