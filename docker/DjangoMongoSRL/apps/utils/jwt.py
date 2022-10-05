import jwt
from datetime import datetime

class JsonWebTokenHelper:
    @staticmethod
    def decode(token):
        try:
            payload = jwt.decode(token, 'secret', algorithms=["HS256"])
            issued_at = payload['issued_at']
            expired_at = payload['expired_at']
            date_expired = datetime.strptime(expired_at, "%m/%d/%Y %H:%M:%S")
            now = datetime.now()
            if (date_expired < now):
                return False
            return payload
        except Exception as e:
            print(e)
            return False
    
    @staticmethod
    def generate(data):
        return jwt.encode(data, 'secret', algorithm='HS256')

