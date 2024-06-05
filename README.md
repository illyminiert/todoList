# 1. Netzwerkkonfiguration

- **Vorhandene Netzwerkverbindungen anzeigen:**
    ```sh
    nmcli connection show
    ```
    **Ausgabe:**
    ```
    NAME                UUID                                  TYPE      DEVICE
    Wired connection 1  f5aa3b6c-643f-38c8-a16a-8eb5d13182c7  ethernet  eth0
    ```
    Die Verbindung mit dem Namen der Ethernet-Schnittstelle identifizieren. In diesem Beispiel ist der Verbindungsname `Wired connection 1`.

- **Statische IP-Adresse festlegen:**
    ```sh
    nmcli con mod "Wired connection 1" ipv4.addresses 192.168.24.187/24
    ```

- **Default-Gateway festlegen:**
    ```sh
    nmcli con mod "Wired connection 1" ipv4.gateway 192.168.24.1
    ```

- **DNS-Server konfigurieren:**
    ```sh
    nmcli con mod "Wired connection 1" ipv4.dns "8.8.8.8"
    ```

- **IP-Konfigurationsmethode auf manuell setzen:**
    ```sh
    nmcli con mod "Wired connection 1" ipv4.method manual
    ```

- **Verbindung neu starten, um die Änderungen zu übernehmen:**
    ```sh
    nmcli con up "Wired connection 1"
    ```

- **Überprüfen, ob die neue IP-Adresse zugewiesen wurde:**
    ```sh
    ip addr show eth0
    ```

# 2. Benutzerverwaltung
## „willi“ – Normaler Benutzer ohne Administratorrechte

- **Benutzer "willi" hinzufügen:**
    ```sh
    sudo adduser willi
    ```
    - Passwort: `willi`
    - Full Name: /
    - Room Number: /
    - Work Phone: /
    - Home Phone: /
    - Other: /
    - Correct? "yes"

## „fernzugriff“ – Benutzer für den Zugriff von außen mittels SSH mit sudo-Rechten

- **Benutzer "fernzugriff" hinzufügen:**
    ```sh
    sudo adduser fernzugriff
    ```
    - Passwort: `fernzugriff`
    - Full Name: /
    - Room Number: /
    - Work Phone: /
    - Home Phone: /
    - Other: /
    - Correct? "yes"

- **"fernzugriff" zur Gruppe "sudo" hinzufügen:**
    ```sh
    sudo usermod -aG sudo fernzugriff
    ```
    - Erklärung des Befehls:
        - `sudo`: Führt den Befehl mit Superuser-Rechten aus.
        - `usermod`: Ist der Befehl zum Modifizieren von Benutzereigenschaften.
        - `-aG sudo`: Fügt den Benutzer zur Gruppe sudo hinzu. Das `-a` steht für "append" (hinzufügen), und das `-G` gibt die Gruppe an.
        - `fernzugriff`: Der Name des Benutzers, der zur sudo-Gruppe hinzugefügt werden soll.

## SSH-Dienst für den Benutzer „fernzugriff“ zur Administration

- **OpenSSH-Server installieren oder auf den neuesten Stand bringen:**
    ```sh
    sudo apt-get install openssh-server
    ```

- **SSH-Konfigurationsdatei bearbeiten, um SSH-Zugriff zu gewähren:**
    ```sh
    sudo nano /etc/ssh/sshd_config
    ```
    - Folgendes ans Ende der Datei hinzufügen:
        ```sh
        AllowUsers fernzugriff
        ```

- **SSH-Dienst neustarten:**
    ```sh
    sudo systemctl restart ssh
    ```

# 3. Docker

- **Docker herunterladen:**
    ```sh
    curl -fsSL https://get.docker.com -o get-docker.sh
    ```

- **Docker ausführen:**
    ```sh
    sudo sh get-docker.sh
    ```

- **Usergruppe "docker" hinzufügen, um Dockerbefehle ohne "sudo" auszuführen:**
    ```sh
    sudo usermod -aG docker $USER
    ```

- **Ordner erstellen:**
    ```sh
    mkdir ~/todo-list-app
    ```

- **Zum Ordner wechseln:**
    ```sh
    cd ~/todo-list-app
    ```

- **Dockerfile erstellen:**
    ```dockerfile
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
    ```

- **Flask als Abhängigkeit deklarieren:**
    ```sh
    sudo nano requirements.txt
    ```
    - **Inhalt der Datei:**
        ```
        flask
        ```

- **Anwendungsdatei erstellen:**
    ```sh
    sudo nano app.py
    ```
    - Die Struktur sieht dann wie folgt aus:
        ```
        todo-list-app/
        ├── app.py
        ├── requirements.txt
        └── Dockerfile
        ```

- **Docker-Image erstellen:**
    ```sh
    sudo docker build -t todo-list.app .
    ```

- **Docker-Image starten:**
    ```sh
    sudo docker run -d -p 5001:5001 todo-list.app
    ```
