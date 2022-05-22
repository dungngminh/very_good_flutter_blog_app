import re

class ValidationMessage:
    EMAIL_WRONG_FORMAT = 'invalid_email',
    USERNAME_TOO_SHORT = 'username_requires_at_least_5'


class Validation:
    email_regex = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'

    @staticmethod
    def register(self, user):
        username = user['username']
        password = user['password']
        last_name = user['last_name']
        first_name = user['first_name']
        email = user['email']

        last_name = last_name.trim()
        username = username.trim()
        first_name = first_name.trim()
        email = email.trim()

        if (
            not email
            or (not password)
            or (not last_name)
            or (not first_name)
            or (not username)
        ):
            return False

        if not re.fullmatch(self.email_regex, email):
            return False

        if len(username) + len(password) < 10:
            return False

        return True