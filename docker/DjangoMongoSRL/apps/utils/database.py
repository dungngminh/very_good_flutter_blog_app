from pymongo import MongoClient

class MongoDatabase:
    def __init__(self) -> None:
        self.client = None
        self.database = None
    
    def load_client(self):
        uri = 'mongodb://root:password@database:27017/?authSource=admin&retryWrites=true&w=majority'
        print('mongo client is loading')
        self.client = MongoClient(uri)
        self.database = self.client['db-mongo']

    def get_database(self):
        if self.client is None:
            self.load_client()
        return self.database

mongo_extension = MongoDatabase()
