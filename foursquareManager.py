from foursquare_secrets import SECRETS
import urllib
import json
import logging

API_VERSION = u'20130613'

<<<<<<< HEAD
def getVenusNearby(latitude, longitude):

  uri = 'https://api.foursquare.com/v2/venues/search?ll=%s,%s&client_id=%s&client_secret=%s&v=%s'
  url = uri % (latitude, longitude, SECRETS['client_id'], SECRETS['client_secret'], API_VERSION )
  return fetchJson(url)
=======
def getVenusNearby(ll, limit=None):

    
    limit = 30
    uri = 'https://api.foursquare.com/v2/venues/search?ll=%s&client_id=%s&client_secret=%s&v=%s&limit=%s'
    url = uri % (ll, SECRETS['client_id'], SECRETS['client_secret'], API_VERSION, limit)
    return fetchJson(url)
>>>>>>> 6bcdb0a832b65e306c6968b0f77b9d6aa31adbde


def fetchJson(url):
  """Does a GET to the specified URL and returns a dict representing its reply."""
<<<<<<< HEAD
  logging.info('fetching url: ' + url)
=======
  logging.info('fetching url: ' + url)  
>>>>>>> 6bcdb0a832b65e306c6968b0f77b9d6aa31adbde
  result = urllib.urlopen(url).read()
  #logging.info('got back: ' + result)
  return json.loads(result)
