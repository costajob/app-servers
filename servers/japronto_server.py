from sys import argv
from japronto import Application


def hello(request):
    return request.Response(text='Hello World')


if __name__ == '__main__':
    workers = int(argv[1]) if len(argv) > 1 else 1
    app = Application()
    app.router.add_route('/', hello)
    app.run(port=9292, worker_num=workers)
