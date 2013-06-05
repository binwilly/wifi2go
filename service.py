from google.appengine.ext import ndb

import cgi
import webapp2
import json


class Wifi(ndb.Model):

    venue_id = ndb.StringProperty(indexed=True)
    ssid = ndb.StringProperty()
    deprecate = ndb.BooleanProperty(default=False)
    password = ndb.StringProperty()
    date_added = ndb.DateTimeProperty(auto_now_add=True)

class Password(ndb.Model):
    password = ndb.StringProperty()
    date_added = ndb.DateTimeProperty(auto_now_add=True)
    date_last_update = ndb.DateTimeProperty(auto_now=True)

def wrap_response(response, error=None):
    d = {
        'error': False if error is None else True,
        'error_message': "" if error is None else error,
        'response': response
    }
    return d

class AccessPointsRequest(webapp2.RequestHandler):

    def get(self):
        self.response.headers['Content-Type'] = 'application/json'
        ll_param = self.request.get('ll')
        ll_split = ll_param.split(',')

        if len(ll_split) != 2:
            self.response.write(json.dumps(wrap_response(None, 'latitude or longitude param missing')))
            return

        latitude = ll_split[0]
        longitude = ll_split[1]

        near_locations = self.findNearLocations(latitude, longitude)
        near_wifis = self.findWifiByLocations(near_locations)

        if len(near_wifis) == 0:
            self.response.write(json.dumps(wrap_response(None, 'no access points found')))
        else:

            self.response.write(json.dumps(wrap_response(near_wifis)))


    def findNearLocations(self, latitude, longitude):
        ''' @TODO implement foursquare '''
        venue_id = ['Parrilla el c', 'La nona']
        return venue_id

    def findWifiByLocations(self, venues):
        ''' @TODO Ensure location data type '''

        query_result = Wifi.query(Wifi.venue_id.IN(venues)).fetch()
        return [wifi.to_dict(exclude=['date_added']) for wifi in query_result]


    @staticmethod
    def getLastestWifi(self, number=5):

        wifis = Wifi.query().fetch(number)
        return wifis


class AccessPointAdd(webapp2.RequestHandler):

    ''' @TODO add wifi via post'''
    def post(self):


        location = self.request.get('venue_id')
        ssid = self.request.get('ssid')
        password = self.request.get('password')

        result = self.addwifi(venue_id, ssid, password)
        self.response.write(json.dumps(wrap_response(result)))


    #return Boolean
    def addWifi(self, venue_id, ssid, password):
        ''' @TODO check id venue_id in foursquare '''
        wifi = Wifi()
        wifi.venue_id = venue_id
        wifi.ssid = ssid
        wifi.password = password
        return wifi.put()



application = webapp2.WSGIApplication([
    ('/api/1/wifi', AccessPointsRequest),
    ('/api/1/addwifi', AccessPointAdd),
], debug=True)
