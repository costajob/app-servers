from japronto import Application


class App(Application):
    def __init__(self):
        super().__init__()
        self.router.add_route('/', self._handle)

    def _handle(self, request):
        return request.Response(text='Hello World')


if __name__ == '__main__':
    app = App()
    app.run(port=9292)
