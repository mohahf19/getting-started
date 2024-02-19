#! /bin/bash

# Submit a job to runai with the following parameters
runai submit \
  --name sandbox-cpu \
  --interactive \
  --image ic-registry.epfl.ch/mlo/fakhouri:micromamba-v2 \
  --pvc runai-mlo-$GASPAR_USERNAME-scratch:/home/$GASPAR_USERNAME/mloscratch \
  --large-shm  \
  --environment EPFML_LDAP=$GASPAR_USERNAME \
  --environment MLOSCRATCH_DIR=/home/$GASPAR_USERNAME/mloscratch/homes/fakhouri \
  --environment GITHUB_PAT=SECRET:github-pat,GITHUB_PAT \
  --command -- sleep infinity 
