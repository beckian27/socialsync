"""Insta485 development configuration."""


import pathlib


# Root of this application, useful if it doesn't occupy an entire domain
APPLICATION_ROOT = '/'


# Secret key for encrypting cookies
# SECRET_KEY = b' SET WITH: $ python3 -c "import os; print(os.urandom(24))" '
SECRET_KEY = b'\x05U\xdd\xe1\xee\xca\x0b\xf6D'
SECRET_KEY += b'\xef\xe4;\x8f\x85*s;\xf5\xa7`RC\x15\xf7'
SESSION_COOKIE_NAME = 'login'


# File Upload to var/uploads/
INSTA485_ROOT = pathlib.Path(__file__).resolve().parent.parent
UPLOAD_FOLDER = INSTA485_ROOT/'var'/'uploads'
ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg', 'gif'])
MAX_CONTENT_LENGTH = 16 * 1024 * 1024


# Database file is var/insta485.sqlite3
DATABASE_FILENAME = INSTA485_ROOT/'var'/'insta485.sqlite3'
