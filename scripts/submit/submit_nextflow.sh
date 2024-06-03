#!/bin/bash
#SBATCH -N 1
#SBATCH --job-name nf-manager
#SBATCH --tasks-per-node=1
#SBATCH --time=4-04:00:00
#SBATCH --mem=1G
#SBATCH --partition=xeon-p8
#SBATCH --output=nf-fragfold.%j.log

ENV=fragfold
WORKFLOW=/data1/groups/keatinglab/swans/savinovCollaboration/FragFold/nextflow/main.nf
NF_CFG=/data1/groups/keatinglab/swans/savinovCollaboration/FragFold/nextflow/nextflow.config
PARAMS=/data1/groups/keatinglab/swans/savinovCollaboration/FragFold/nextflow/params/ftsZ_monomeric_example.yaml
WORK_DIR=$(pwd -P)
LOGS=${WORK_DIR}/nextflow_logs

# Go to a tmp dir
USER=$(whoami) && cd $TMPDIR
echo "tmpdir: "$TMPDIR

# If this has already been run, copy the logs back to the tmp dir so that we can resume
if [ -d "$LOGS"]; then
    cp -r $LOGS/.* .
else
    mkdir -p ${WORK_DIR}/nextflow_logs
fi

conda run -n $ENV --no-capture-output nextflow run $WORKFLOW -w $WORK_DIR -c $NF_CFG -params-file $PARAMS -resume 

cp -r .nextflow* ${WORK_DIR}/nextflow_logs && \
    *.csv $WORK_DIR && \
    echo 'Finished job and copied files from $TMPDIR'