import cgi
import webapp2
import service


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

        wifis = service.AccessPointsRequest.getLastestWifi(5)

        for wifi in wifis:
            self.response.write('<div> <b>Location:</b> %s | <b>Wi-fi:</b> %s : <b>Added:</b> %s</div></br>' %  \
                (wifi.venue_id, wifi.ssid, wifi.date_added.strftime('%Y-%m-%d')))

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


        accessPointAdd = service.AccessPointAdd()
        accessPointAdd.addWifi(venue_id, venue_name, ssid, latitude, longitude, password)

        self.redirect('/')


application = webapp2.WSGIApplication([
    ('/', MainPage)
], debug=True)
