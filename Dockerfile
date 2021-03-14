FROM python:3.8-slim-buster as requirements
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

FROM python:3.8-slim-buster
RUN useradd -m -s /bin/bash -U appuser
USER appuser
COPY --from=requirements /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY app app
CMD hypercorn --bind "0.0.0.0:80" app.main:app
