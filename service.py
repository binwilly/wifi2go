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
        limit_param = self.request.get('limit')
        ll_param = self.request.get('ll')

        search_controller = controller.SearchManager()
        near_locations = search_controller.findNearVenues(ll_param, limit_param)

        sendResponse(self, near_locations)
        return

        if len(near_wifis) == 0:
            sendResponse(self, None, 'no access points found')
        else:
            sendResponse(self, near_wifis)


class AccessPointAdd(webapp2.RequestHandler):

    def post(self):

        data = json.loads(self.request.body)
        venue_id = data['venue_id']
        has_password = data['has_password']
        password = data['password']
        ssid = data['ssid']

        wifi_controller = controller.WifiManager()
        result = wifi_controller.addWifi(venue_id, ssid, has_password, password)

        if result is True:
            sendResponse(self, None)
        else:
            sendResponse(self, None, "couldn't save, Maybe wrong type")



application = webapp2.WSGIApplication([
    ('/api/1/wifi', AccessPointsRequest),
    ('/api/1/addwifi', AccessPointAdd),
], debug=True)
