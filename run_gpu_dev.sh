t#! /bin/bash

# Submit a job to runai with the following parameters

SHARED_MLOSCRATCH_DIR=/mnt/mloscratch
MY_MLOSCRATCH_DIR=$SHARED_MLOSCRATCH_DIR/homes/$GASPAR_USERNAME
MAMBA_ROOT_PREFIX=$MY_MLOSCRATCH_DIR/micromamba

runai submit \
  --name sandbox-gpu \
  --interactive \
  --gpu 1 \
  --image ic-registry.epfl.ch/mlo/fakhouri:pixi-v1 \
  --pvc runai-mlo-$GASPAR_USERNAME-scratch:$SHARED_MLOSCRATCH_DIR \
  --large-shm  \
  --environment EPFML_LDAP=$GASPAR_USERNAME \
  --environment MLOSCRATCH_DIR=$MY_MLOSCRATCH_DIR \
  --environment MAMBA_ROOT_PREFIX=$MAMBA_ROOT_PREFIX \
  --environment GITHUB_PAT=SECRET:github-pat,GITHUB_PAT \
  --command -- sleep infinity 
