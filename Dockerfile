# Image de base (Python 3.12 pour rester compatible avec ton venv local)
FROM python:3.12-slim

# Créer un utilisateur non-root
RUN useradd -m flask

# Répertoire de travail
WORKDIR /home/flask

# Copier les fichiers du projet dans l'image
ADD . .

# Mise à jour pip + installation des dépendances
RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

# Droits d'exécution
RUN chmod a+x app.py test.py && chown -R flask:flask ./

# Variable d'environnement
ENV FLASK_APP=app.py

# Exposer le port de l’app
EXPOSE 5000

# Exécuter avec l’utilisateur flask
USER flask

# Commande de lancement
CMD ["python", "app.py"]
