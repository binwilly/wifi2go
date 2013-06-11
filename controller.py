from google.appengine.ext import ndb
import models


def getHumanDate(date):
    return date.strftime('%Y-%m-%d')


class SearchManager():

    def findNearLocations(self, latitude, longitude):
        ''' @TODO implement foursquare '''
        venue_id = ['Parrilla el c', 'Wifi - tu vieja3']
        return venue_id

    def findWifiByLocations(self, venues):
        ''' @TODO Ensure location data type '''

        query_result = Wifi.query(Wifi.venue_id.IN(venues)).fetch()
        return [wifi.to_dict() for wifi in query_result]

    @staticmethod
    def getLastestWifi(self, number=5):
        wifis = models.Wifi.query().fetch(number)
        result_query = []

        for wifi in wifis:
            wifi_fields = ['venue_id', 'venue_name', 'latitude', 'longitude', 'ssid', 'deprecate']
            data = {f: getattr(wifi, f) for f in wifi_fields}
            data['date_added'] = getHumanDate(wifi.date_added)
            result_query.append(data)

            for wifi_security in models.WifiSecurity.query(ancestor=wifi.key):
                print wifi_security
                data['password'] = wifi_security.password
                print wifi_security.pass_date_added
                data['pass_date_added'] = getHumanDate(wifi_security.pass_date_added)
                data['date_last_update'] = getHumanDate(wifi_security.date_last_update)
                result_query.append(data)

        return result_query


class Wifi():

    def addWifi(self, venue_id, venue_name, latitude, longitude, ssid, password):
        wifi_security = models.WifiSecurity()
        return wifi_security.addWifi(venue_id, venue_name, latitude, longitude, ssid, password)
