from google.appengine.ext import ndb

import cgi
import webapp2
import json


class Wifi(ndb.Model):

    ssid = ndb.StringProperty(indexed=True)
    password = ndb.StringProperty()
    date_added = ndb.DateTimeProperty(auto_now_add=True)


class AccessPointsRequest(webapp2.RequestHandler):

    def get(self):
        d = {
            'name': 'Test Wi-Fi',
            'password': '1234',
            'location_id': 999,
        }

        self.response.write(json.dumps([d, d, d]))

    def post(self):
        data = json.loads(self.request.body)

        try:
            near_locations = self.findNearLocations(data['latitude'], data['longitude'])
        except KeyError, e:
            self.response.write('Error: latitude or longitude param missing')

        near_wifis = self.findWifiByLocations(near_locations)

        if len(near_wifis) == 0:
            self.response.write('Wifi not found')
        else:
            self.response.write(json.dumps(near_wifis))


    def findNearLocations(self, latitude, longitude):
        locations = [(999, 991)]

        return locations

    def findWifiByLocations(self, locations):

        wifi_results = [{
            'name': 'Test Wi-Fi',
            'password': 1234,
            'location_id': 999
        },
        {
            'name': 'Wi-Fi La Nona',
            'password': 334,
            'location_id': 991
        }]

        return wifi_results


class AccessPointAdd(webapp2.RequestHandler):

    ''' post param latitude and longitude'''
    def post(self):
        return None

application = webapp2.WSGIApplication([
    ('/api/1/wifi', AccessPointsRequest),
    ('/api/1/addwifi', AccessPointAdd),
], debug=True)
