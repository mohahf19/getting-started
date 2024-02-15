#! /bin/bash

# Submit a job to runai with the following parameters
runai submit \
  --name sandbox-cpu \
  --interactive \
  --image ic-registry.epfl.ch/mlo/fakhouri:micromamba-v1 \
  --pvc runai-mlo-$GASPAR_USERNAME-scratch:/mloscratch \
  --large-shm --host-ipc \
  --environment EPFML_LDAP=$GASPAR_USERNAME \
  --command -- sleep infinity
