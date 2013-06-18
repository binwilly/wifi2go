import cgi
import webapp2
import controller
import foursquareManager

class MainPage(webapp2.RequestHandler):

    def get(self):
        self.response.write('<html><body>')

        wifis = controller.SearchManager.getLastestWifi(5)

        controller.SearchManager().findNearVenues("58.371839, 34.59624", 30)

        for wifi in wifis:
          self.response.write('<div><b>V_id:</b> %s <b>ssid:</b> %s <b>Deprecate:</b> %s <b>date_added:</b> %s <b>Pass:</b> %s <b>pass_date_added:</b> %s <b>date_last_update:</b> %s </div></br>' % 
            (wifi['venue_id'], wifi['ssid'], wifi['deprecate'], wifi['date_added'], wifi['password'], wifi['pass_date_added'], wifi['date_last_update']))


        if len(wifis) == 0:
            self.response.write('No hay wifi che!')

application = webapp2.WSGIApplication([
    ('/', MainPage),
], debug=True)
