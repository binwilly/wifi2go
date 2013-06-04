from google.appengine.api import users
import cgi
import webapp2

class AccessPoints(webapp2.RequestHandler):
    def get(self):
        self.response.write("#fafafa")

application = webapp2.WSGIApplication([
    ('/ap', AccessPoints),
], debug=True)
