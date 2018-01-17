def app(environ, response):
    data = b"{\"status\": \"ok\"}"
    response("200 OK", [
        ("Content-Type", "application/json"),
        ("Content-Length", str(len(data)))
    ])
    return iter([data])