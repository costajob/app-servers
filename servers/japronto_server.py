from japronto import Application

def hello(request):
    return request.Response(text='Hello World')

app = Application()
app.router.add_route('/', hello)
app.run(port=9292, debug=False)
