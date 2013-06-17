import cgi
import webapp2
import controller
import foursquareManager


MAIN_PAGE_HTML = """\
<html>
  <body>
    <form action="/" method="post">
      <div>venue_id: <input name="venue_id" col="20" > As appear in Four Square</div>
      <div>venu name: <input name="venue_name" col="20" > As appear in Four Square</div>
      <div>Wifi SSID: <input name="ssid" col="20" ></div>
      <div>latitude: <input name="latitude" col="20" ></div>
      <div>longitude: <input name="longitude" col="20" ></div>
      <div>Wifi Pass: <input name="password" col="20" ></div>
      <div><input type="submit" value="Add wifi"></div>
    </form>
  </body>
</html>
"""

class MainPage(webapp2.RequestHandler):

    def get(self):
        self.response.write('<html><body>')

        wifis = controller.SearchManager.getLastestWifi(5)

        controller.SearchManager().findNearLocations('222', '22')

        for wifi in wifis:
          self.response.write('<div><b>V_id:</b> %d <b>V_name:</b> %s <b>ll:</b> %d,%d <b>ssid:</b> %s <b>Deprecate:</b> %s <b>date_added:</b> %s <b>Pass:</b> %s <b>pass_date_added:</b> %s <b>date_last_update:</b> %s </div></br>' % 
            (wifi['venue_id'], wifi['venue_name'], wifi['latitude'], wifi['longitude'], wifi['ssid'], wifi['deprecate'], wifi['date_added'], wifi['password'], wifi['pass_date_added'], wifi['date_last_update']))


        if len(wifis) == 0:
            self.response.write('No hay wifi che!')

        self.response.write(MAIN_PAGE_HTML)

    def post(self):

        venue_id = self.request.get('venue_id')
        venue_name = self.request.get('venue_name')
        ssid = self.request.get('ssid')
        latitude = self.request.get('latitude')
        longitude = self.request.get('longitude')
        password = self.request.get('password')

        controller.Wifi.addWifi(venue_id, venue_name, ssid, latitude, longitude, password)

        self.redirect('/')


application = webapp2.WSGIApplication([
    ('/', MainPage),
], debug=True)
