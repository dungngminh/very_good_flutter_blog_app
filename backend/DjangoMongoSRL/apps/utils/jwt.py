import jwt
from datetime import datetime

class JsonWebTokenHelper:
    @staticmethod
    def decode(token):
        try:
            payload = jwt.decode(token, 'secret', algorithms=["HS256"])
            issued_at = payload['issued_at']
            expired_at = payload['expired_at']
            date_expired = datetime.strptime(expired_at, "%d/%m/%y %H:%M:%S")
            now = datetime.now()
            if (date_expired < now):
                return False
            return True
        except:
            return False
    
    @staticmethod
    def generate(data):
        return jwt.encode(data, 'secret', algorithm='HS256')

