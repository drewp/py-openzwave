#!bin/python

import sys, restkit, logging
import cyclone.web
from twisted.python import log
from twisted.internet import reactor
from manager import Manager
logging.basicConfig(level=logging.DEBUG)

class IndexHandler(cyclone.web.RequestHandler):
    def get(self):
        self.write("openzwave server")

class NodesHandler(cyclone.web.RequestHandler):
    """
    GET /nodes
    GET /nodes/2 {...}
    PUT /nodes/2/level 0.5
    """
    def put(self, path):
        assert path == "/2/level", path
        val = max(0, min(99, int(99*float(self.request.body.strip()))))
        restkit.Resource("http://dash:9999").post(
            "valuepost.html",
            payload="2-SWITCH MULTILEVEL-user-byte-1-0=%d" % val,
            headers={"content-type":"application/x-www-form-urlencoded"},
            )
        self.write("done")

class Application(cyclone.web.Application):
    def __init__(self, manager):
        handlers = [
            (r"/", IndexHandler),
            (r"/nodes(.*)", NodesHandler),
        ]

        settings = {
            "manager" : manager,
            "static_path": "./static",
            "template_path": "./template",
        }

        cyclone.web.Application.__init__(self, handlers, **settings)

if __name__ == "__main__":
    log.startLogging(sys.stdout)
    # currently this needs 'ozwcp -p 9999' to be running, and you have to initialize it with /dev/serial/by-id/usb-Prolific_Technology_Inc._USB-Serial_Controller_D-if00-port0
    manager = None#Manager(configDir="localconfig")
    reactor.listenTCP(9082, Application(manager))
    reactor.run()
