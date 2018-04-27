BODY = b'Hello World'
LEN = str(len(BODY))


def app(_, resp):
    body = BODY
    resp('200 OK', [('Content-Type', 'text/plain'), ('Content-Length', LEN)])
    yield body
