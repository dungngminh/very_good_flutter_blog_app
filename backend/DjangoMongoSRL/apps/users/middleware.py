from apps.utils.jwt import JsonWebTokenHelper

class UserMiddleware:
    def authorization(jwt, dest_user_id):
        try:
            payload = JsonWebTokenHelper.decode(jwt)
            if payload['_id'] == dest_user_id:
                return True
            return False
        except:
            return False