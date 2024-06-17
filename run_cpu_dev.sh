#! /bin/bash

# Submit a job to runai with the following parameters

SHARED_MLOSCRATCH_DIR=/mnt/mloscratch
MY_MLOSCRATCH_DIR=$SHARED_MLOSCRATCH_DIR/homes/$GASPAR_USERNAME
HF_HOME=$MY_MLOSCRATCH_DIR/huggingface

runai submit \
  --name sandbox-cpu \
  --interactive \
  --image ic-registry.epfl.ch/mlo/fakhouri:pixi-v2 \
  --pvc runai-mlo-$GASPAR_USERNAME-scratch:$SHARED_MLOSCRATCH_DIR \
  --large-shm  \
  --environment EPFML_LDAP=$GASPAR_USERNAME \
  --environment MLOSCRATCH_DIR=$MY_MLOSCRATCH_DIR \
  --environment WANDB_API_KEY=$WANDB_API_KEY \
  --environment HF_HOME=$HF_HOME \
  --environment GITHUB_PAT=SECRET:github-pat,GITHUB_PAT \
  --command -- sleep infinity 
