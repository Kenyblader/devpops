# Utiliser une image de base Python légère
FROM python:3.6-alpine

# Définir le répertoire de travail
WORKDIR /opt

# Installer les dépendances nécessaires
RUN apk add --no-cache git bash && \
    pip install Flask

# Cloner le projet contenant l'application Flask et le fichier releases.txt
RUN git clone https://github.com/Kenyblader/projet_final.git /opt

# variable d'environnement
RUN awk '/ODOO_URL/ {print $2}' releases.txt > /tmp/ODOO_URL && \
    awk '/PGADMIN_URL/ {print $2}' releases.txt > /tmp/PGADMIN_URL && \
    echo "export ODOO_URL=$(cat /tmp/ODOO_URL)" >> /etc/profile.d/env.sh && \
    echo "export PGADMIN_URL=$(cat /tmp/PGADMIN_URL)" >> /etc/profile.d/env.sh && \
    chmod +x /etc/profile.d/env.sh

# Exposer le port utilisé par l'application
EXPOSE 8080

# Configurer le point d'entrée
ENTRYPOINT ["/bin/bash", "-c", "source /etc/profile.d/env.sh && python app.py"]
