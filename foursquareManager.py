from foursquare_secrets import SECRETS
import urllib
import json
import logging

API_VERSION = u'20130613'

def getVenusNearby(ll, limit=None):

    
    limit = 30
    uri = 'https://api.foursquare.com/v2/venues/search?ll=%s&client_id=%s&client_secret=%s&v=%s&limit=%s'
    url = uri % (ll, SECRETS['client_id'], SECRETS['client_secret'], API_VERSION, limit)
    return fetchJson(url)


def fetchJson(url):
  """Does a GET to the specified URL and returns a dict representing its reply."""
  logging.info('fetching url: ' + url)  
  result = urllib.urlopen(url).read()
  #logging.info('got back: ' + result)
  return json.loads(result)
