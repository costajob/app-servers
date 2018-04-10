from sys import argv
from japronto import Application


class App(Application):
    def __init__(self):
        super().__init__()
        self.router.add_route('/', self._handle)

    def _handle(self, request):
        return request.Response(text='Hello World')


if __name__ == '__main__':
    app = App()
    workers = int(argv[1]) if len(argv) > 1 else None
    app.run(port=9292, worker_num=workers)
