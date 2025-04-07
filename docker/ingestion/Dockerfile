FROM python:3.10-slim
WORKDIR /app/ingestion
COPY requirements.txt /app/ingestion/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY ingestion/ /app/ingestion/
CMD ["tail", "-f", "/dev/null"]