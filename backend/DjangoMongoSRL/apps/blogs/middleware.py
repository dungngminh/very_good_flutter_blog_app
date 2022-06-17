from apps.utils.jwt import JsonWebTokenHelper

class BlogMiddleware:
    def authorization(jwt):
        try:
            payload = JsonWebTokenHelper.decode(jwt)
            return payload
        except:
            return False