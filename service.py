from google.appengine.ext import ndb

import cgi
import webapp2
import json


class Wifi(ndb.Model):

    location = ndb.StringProperty(indexed=True)
    ssid = ndb.StringProperty(indexed=True)
    deprecate = ndb.BooleanProperty(default=False)
    password = ndb.StringProperty()
    date_added = ndb.DateTimeProperty(auto_now_add=True)

class Password(ndb.Model):
    password = ndb.StringProperty()
    date_added = ndb.DateTimeProperty(auto_now_add=True)
    date_last_update = ndb.DateTimeProperty(auto_now=True)


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
        ''' @TODO implement foursquare '''
        locations = ['adkn', 'vj']
        return locations

    def findWifiByLocations(self, locations):
        ''' @TODO Ensure location data type '''

        query_result = Wifi.query(Wifi.location.IN(locations)).fetch()
        return [wifi.to_dict(exclude=['date_added']) for wifi in query_result]


    @staticmethod
    def getLastestWifi(self, number=5):

        wifis = Wifi.query().fetch(number)
        return wifis


class AccessPointAdd(webapp2.RequestHandler):

    ''' @TODO add wifi via post'''
    def post(self):
        return None

    #return Boolean
    def addWifi(self, location, ssid, password):
        ''' @TODO check id location in foursquare '''
        wifi = Wifi()
        wifi.location = location
        wifi.ssid = ssid
        wifi.password = password
        return wifi.put()



application = webapp2.WSGIApplication([
    ('/api/1/wifi', AccessPointsRequest),
    ('/api/1/addwifi', AccessPointAdd),
], debug=True)
