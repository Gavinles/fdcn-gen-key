# filepath: services/oracle-ai/Dockerfile
FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1

# create app user
RUN useradd --create-home --shell /bin/bash appuser

WORKDIR /app
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# copy app last so layer changes are minimized
COPY --chown=appuser:appuser app.py /app/

USER appuser
EXPOSE 5001
# Run with gunicorn (production WSGI server)
CMD ["gunicorn", "-b", "0.0.0.0:5001", "app:app", "--workers", "2", "--threads", "2"]
