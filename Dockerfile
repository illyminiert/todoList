# Verwende ein offizielles Python-Runtime-Image als Basis-Image
FROM python:3.8-slim-buster

# Setze das Arbeitsverzeichnis im Container
WORKDIR /app

# Kopiere die Anforderungen-Datei in das Arbeitsverzeichnis
COPY requirements.txt .

# Installiere die Python-Abhängigkeiten
RUN pip install --no-cache-dir -r requirements.txt

# Kopiere den Rest des Anwendungsquellcodes in das Arbeitsverzeichnis
COPY . .

# Setze den Standardbefehl, der beim Starten des Containers ausgeführt wird
CMD ["python", "app.py"]
