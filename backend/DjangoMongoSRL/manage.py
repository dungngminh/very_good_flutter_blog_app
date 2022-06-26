#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
import sys
from apps.utils.database import mongo_extension

def main():
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc
    execute_from_command_line(sys.argv)


def load_db():
    mongo_extension.load_client()

if __name__ == '__main__':
    main()
    load_db()