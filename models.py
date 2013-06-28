from google.appengine.ext import ndb
import random
import string

class Wifi(ndb.Model):
    venue_id = ndb.StringProperty(indexed=True)
    ssid = ndb.StringProperty()
    deprecate = ndb.BooleanProperty(default=False)
    date_added = ndb.DateTimeProperty(auto_now_add=True)

class WifiSecurity(ndb.Model):
    password = ndb.StringProperty()
    '''Without dafult=True doesn't work properly (I don't know why)'''
    has_password = ndb.BooleanProperty(default=True)
    pass_date_added = ndb.DateTimeProperty(auto_now_add=True)
    date_last_update = ndb.DateTimeProperty(auto_now=True)

    def add(self, venue_id, ssid, has_password, password):
        ''' return Boolean '''
        try:
            wifi_key = ndb.Key('Wifi', venue_id)

            wifi = Wifi(key=wifi_key)
            wifi.venue_id = venue_id
            wifi.ssid = ssid
            wifi.put()

            wifiSecurity = WifiSecurity(parent=wifi.key)
            wifiSecurity.password = password
            WifiSecurity.has_password = has_password
            wifiSecurity.put()

        except Exception, e:
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

