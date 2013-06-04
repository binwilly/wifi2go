from google.appengine.ext import ndb

import cgi
import webapp2
import json


class Wifi(ndb.Model):

    ssid = ndb.StringProperty(indexed=True)
    password = ndb.StringProperty()
    date_added = ndb.DateTimeProperty(auto_now_add=True)


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
