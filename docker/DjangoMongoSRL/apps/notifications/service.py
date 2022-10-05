from email import message
import os
from firebase_admin import initialize_app, credentials, messaging 

class FirebaseService:
    # def get_cert(self):
    #     sec_client = secretmanager.SecretManagerServiceClient()
    #     name = sec_client.secret_version_path(GOOGLE_CLOUD_PROJECT_NUMBER, FIREBASE_SA_SECRET_NAME, "latest")
    #     response = sec_client.access_secret_version(name)
    #     service_account_info = json.loads(response.payload.data.decode('utf-8'))

    def __init__(self) -> None:
        self.client = None
        self.credentials = credentials.Certificate(os.path.join(os.getcwd(), './firebase_key.json'))
        self.load()
    
    def load(self):
        if self.client is None:
            self.client = initialize_app(self.credentials)


class PubSub:
    _shared_instance = None

    def __init__(self) -> None:
        self.firebase_instance = FirebaseService()
        PubSub._shared_instance = self
        PubSub.__new__ = lambda _ : PubSub._shared_instance

    def load(self):
        pass

    def subscribe(self, device_token, topic_name):
        messaging.subscribe_to_topic(tokens=device_token, topic=topic_name)

    def unsubscribe(self, device_token, topic_name):
        messaging.unsubscribe_from_topic(tokens=device_token, topic=topic_name)

    def publish(self, topic_name, title, body):
        message = messaging.Message(
            data = {
                'title': title,
                'body': body,
            },
            topic =  topic_name
        )
        messaging.send(message = message)
    
    def personal_publish(self, token, title, body):
        message = messaging.Message(
            data = {
                'title': title,
                'body': body,
            },
            token = token,
        )
        messaging.send(message = message)

pubsub = PubSub()