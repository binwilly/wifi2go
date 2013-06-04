from google.appengine.api import users
import cgi
import webapp2
import json

class AccessPoints(webapp2.RequestHandler):
    def get(self):
    	d = {
    		'name': 'Test Wi-Fi',
    		'password': '1234',
    		'location_id': 999,
    	}

        self.response.write(json.dumps([d, d, d]))

    def post(self):
    	pass

application = webapp2.WSGIApplication([
    ('/', AccessPoints),
], debug=True)
