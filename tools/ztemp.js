fs = require("fs")
dq_path = "../data/common/vocabulary/dq-measurement-simple.json"
dq_json = JSON.parse(fs.readFileSync(dq_path))


//Comparer Function  
function get_sort_order(prop) {  
  return function(a, b) {  
    if (a[prop] > b[prop]) {  
      return 1;  
    } else if (a[prop] < b[prop]) {  
      return -1;  
    }  
    return 0;  
  }  
}

dq_json.terms.sort(get_sort_order("label"))
console.log(dq_json)

dq = JSON.stringify(dq_json,null,2)
fs.writeFileSync(dq_path,dq,'utf-8')
