FROM ninjaclasher/dmoj-base:latest

ENTRYPOINT exec celery -A dmoj_celery worker -l info --concurrency=2
