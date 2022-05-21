from rest_framework.response import Response

class ResponseMessage:
    LOGIN_SUCCESS = 'login_successfully'
    LOGIN_FAILED = 'authentication_failed'
    REGISTER_SUCCESS = 'successfully_registered'
    REGISTER_FAILED = 'register_failed'



class HttpResponse:
    @staticmethod
    def response(data, message, status):
        if type(data) is dict and 'message' not in data.keys():
            data['message'] = message 

        return Response(
            data,
            status,
        )