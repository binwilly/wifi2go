from google.appengine.ext import ndb
import controller
import webapp2
import json


def sendResponse(self, data, error=None):

    data_response = {
        'error': False if error is None else True,
        'error_message': "" if error is None else error,
        'response': data
    }
    
    self.response.headers['Content-Type'] = 'application/json'
    self.response.write(json.dumps(data_response))

class AccessPointsRequest(webapp2.RequestHandler):

    def get(self):
        ll_param = self.request.get('ll')
        ll_split = ll_param.split(',')

        if len(ll_split) != 2:
            sendResponse(self, None, 'latitude or longitude param missing')
            return

        latitude = ll_split[0]
        longitude = ll_split[1]

        search_controller = controller.SearchManager()
        near_locations = search_controller.findNearLocations(latitude, longitude)
        near_wifis = search_controller.findWifiByLocations(near_locations)

        if len(near_wifis) == 0:
            sendResponse(self, None, 'no access points found')
        else:
            sendResponse(self, near_wifis)


class AccessPointAdd(webapp2.RequestHandler):

    def post(self):

        data = json.loads(self.request.body)
        venue_id = data['venue_id']
        venue_name = data['venue_name']
        latitude = data['latitude']
        longitude = data['longitude']
        password = data['password']
        ssid = data['ssid']

        wifi_controller = controller.Wifi()
        result = wifi_controller.addWifi(venue_id, venue_name, latitude, longitude, ssid, password)

        if result is True:
            sendResponse(self, None)
        else:
            sendResponse(self, None, "couldn't save, Maybe wrong type")



application = webapp2.WSGIApplication([
    ('/api/1/wifi', AccessPointsRequest),
    ('/api/1/addwifi', AccessPointAdd),
], debug=True)
