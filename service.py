from google.appengine.ext import ndb
import models
import webapp2
import json


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
        venue_id = ['Parrilla el c', 'Wifi - tu vieja3']
        return venue_id

    def findWifiByLocations(self, venues):
        ''' @TODO Ensure location data type '''

        query_result = Wifi.query(Wifi.venue_id.IN(venues)).fetch()
        return [wifi.to_dict(exclude=['date_added']) for wifi in query_result]


    @staticmethod
    def getLastestWifi(self, number=5):
        wifis = models.Wifi.query().fetch(number)
        for wifi in wifis:
            print wifi.ssid
            for password in models.WifiSecurity.query(ancestor=wifi.key):
                print password.password

        return wifis


class AccessPointAdd(webapp2.RequestHandler):

    def post(self):

        data = json.loads(self.request.body)
        venue_id = data['venue_id']
        venue_name = data['venue_name']
        latitude = data['latitude']
        longitude = data['longitude']
        password = data['password']
        ssid = data['ssid']

        wifi_security = models.WifiSecurity()
        result = wifi_security.addWifi(venue_id, venue_name, latitude, longitude, ssid, password)

        if result is True:
            self.response.write(json.dumps(wrap_response(None)))
        else:
            self.response.write(json.dumps(wrap_response(None, "couldn't save, Maybe wrong type")))



application = webapp2.WSGIApplication([
    ('/api/1/wifi', AccessPointsRequest),
    ('/api/1/addwifi', AccessPointAdd),
], debug=True)
