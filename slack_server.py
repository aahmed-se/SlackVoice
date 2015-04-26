from flask import Flask
from flask import request
import time
from apns import APNs, Frame, Payload
import urlparse

apns = APNs(use_sandbox=True, cert_file='cert.pem', key_file='key.unencrypted.pem')

# Send a notification
token_hex = 'A56B7DF4964B7840C1F4D1DAAA057BD300D14D3CD350032D59D01E15A9637101' # Sashi iphone
# token_hex = '2633846F0E53D997E57A8E70CD40072555C609423B0AE5AED4A9DBB7B0241B7A' # Ali's ipad

app = Flask(__name__)

@app.route('/',methods=['GET'])
def hello_world():
	response = " .. Error .."
	if request.query_string is None:
		print "No URL Data"
	else:
		param = dict(urlparse.parse_qsl(request.query_string))
		response = param['user_name'] + ' -> call -> ' + param['text'][1:]
		payload = Payload(alert=response, sound="default", badge=1)
		apns.gateway_server.send_notification(token_hex, payload)

	return response

if __name__ == '__main__': 
    app.run(debug=True,port=8000)