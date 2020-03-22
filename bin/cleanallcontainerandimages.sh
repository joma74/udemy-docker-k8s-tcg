#!/bin/bash
# Alle Container löschen
docker rm $(docker ps -a -q)
# Alle Abbilder/Images löschen
docker rmi -f $(docker images -q)