from bottle import template


class Application():

    def __init__(self):
        self.pages = {
            'helper': self.helper,
            'index': self.index,
            'login': self.login
        }


    def render(self,page):
       content = self.pages.get(page, self.helper)
       return content()

    def helper(self):
        return template('app/views/html/helper')

    def index(self):
        return template('app/views/html/index')
    
    def login(self):
        return template('app/views/html/login')
    