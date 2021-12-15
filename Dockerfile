FROM python:3.8.12-alpine3.15

ADD parser.py .

CMD ["python3", "parser.py"]
