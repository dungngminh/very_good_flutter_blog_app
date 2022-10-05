import bcrypt

class HashingHelper:
    @staticmethod
    def encrypt(plain_text_password):
        print('PLAIN_TEXT_PASSWORD: ', plain_text_password)
        return bcrypt.hashpw(plain_text_password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
    
    @staticmethod
    def compare(hashed_password, plain_text_password):
        return bcrypt.checkpw(
            password=plain_text_password.encode('utf-8'),
            hashed_password=hashed_password.encode('utf-8'),
        )

