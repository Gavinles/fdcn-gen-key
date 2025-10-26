# filepath: services/oracle-ai/Dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY app.py /app/
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5001
CMD ["python", "app.py"]
