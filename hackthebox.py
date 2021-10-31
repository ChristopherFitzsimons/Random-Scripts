import requests
import re
import hashlib

reqest = requests.session()
url = "URL"
r = reqest.get(url=url)
x = re.findall("(\w{20})", str(r.content))
string_input = x[0].encode('utf-8')
md5_hash = hashlib.md5(string_input).hexdigest()
data = dict(hash=md5_hash)
r = reqest.post(url=url, data=data)
print(r.text)
