import axios from 'axios'

export function getStockCodes()
{
  return axios.get('http://127.0.0.1:8000/stock/codes');
}


export function syncStockData(code,start,stop)
{
  return axios.get('http://127.0.0.1:8000/sync/'+code+"/"+start+"/"+stop);
}


export function getStockData(code,start,stop,model)
{
  return axios.get('http://127.0.0.1:8000/stock/qfq/'+code+"/"+start+"/"+stop+"/"+model);
}

export function getStockCorr(code,model)
{
  return axios.get('http://127.0.0.1:8000/stock/corr/'+code+"/"+model);
}