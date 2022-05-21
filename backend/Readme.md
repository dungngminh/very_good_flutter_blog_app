# Operations Engineer Test

## Project’s Structure

It's a django app integrated with mongodb. In order to performe the 
csv upload was created a command called "cmd_upload_csv".


## Directions to running the code

It is required that you have installed on your machine:
-   docker
-   docker-compose

In the work space folder run:

0.  make build
1.	make run

In a new terminar run:

0.	Go to the work space folder
1.	make shell

Once you are inside the docker instance run:

0.	python manage.py makemigrations
1.	python manage.py migrate
2.	python manage.py cmd_upload_csv db_works_test.csv

Open the browser with the following url:

-   http://127.0.0.1:8000/musics/
