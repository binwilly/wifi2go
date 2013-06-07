from google.appengine.ext import ndb

class Wifi(ndb.Model):
    venue_id = ndb.IntegerProperty(indexed=True)
    venue_name = ndb.StringProperty()
    latitude = ndb.IntegerProperty()
    longitude = ndb.IntegerProperty()
    ssid = ndb.StringProperty()
    deprecate = ndb.BooleanProperty(default=False)
    date_added = ndb.DateTimeProperty(auto_now_add=True)

class WifiSecurity(ndb.Model):
    password = ndb.StringProperty()
    date_added = ndb.DateTimeProperty(auto_now_add=True)
    date_last_update = ndb.DateTimeProperty(auto_now=True)

    def addWifi(self, venue_id, venue_name, latitude, longitude, ssid, password):
        ''' return Boolean '''
        try:
            wifi = Wifi()
            wifi.venue_id = venue_id
            wifi.venue_name = venue_name
            wifi.latitude = latitude
            wifi.longitude = longitude
            wifi.ssid = ssid
            wifi.put()

            wifiSecurity = WifiSecurity(parent=wifi.key)
            wifiSecurity.password = password
            wifiSecurity.put()


        except Exception, e:
            print e
            return False
        else:
            return True

    def addPassword(self, venue_id):
        try:
            wifiSecurity = WifiSecurity()
            wifiSecurity.password = password
            wifiSecurity.put()

        except Exception, e:
            print e
            return False
        else:
            return True