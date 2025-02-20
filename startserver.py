from app.controllers.route import App
import eventlet
import eventlet.wsgi
app = App()

if __name__ == '__main__':
    eventlet.wsgi.server(eventlet.listen(('0.0.0.0', 8080)), app.wsgi_app)