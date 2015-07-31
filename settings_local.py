import os

# You probably do not want to edit these settings
PROJECT_ROOT = os.path.realpath(os.path.dirname(__file__))
SESSION_ENGINE = "django.contrib.sessions.backends.db"
REDIRECT_BASE = None

#
# Edit the following Django settings
#

# Set the desired database, sqlite for local/dev installations works good;
# Postgres is better and should definitely be enabled for production installs.
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'cloudlaunch',
        'USER': 'launch',
        'PASSWORD': 'pwd',
        'HOST': 'localhost',
        'PORT': '5432',
    }
}

# Set this absolute path then run: python biocloudcentral/manage.py collectstatic
STATIC_ROOT = '/srv/cloudlaunch/media'


#
# App-specific settings (i.e., not Django-related)
#

# Page title and brand text
BRAND = "Cloud Launch"

# Whether to add an email field to the form and make it required or optional.
ASK_FOR_EMAIL = False
REQUIRE_EMAIL = False
