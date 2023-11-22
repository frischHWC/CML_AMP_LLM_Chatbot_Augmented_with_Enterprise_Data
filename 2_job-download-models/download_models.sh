#!/bin/bash
# This script is used to pre=download files stored with git-lfs in CML Runtimes which do not have git-lfs support
# You can use any models that can be loaded with the huggingface transformers library. See utils/model_embedding_utls.py or utils/moderl_llm_utils.py
GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no"
EMBEDDING_MODEL_REPO="git@github.com:frischHWC/cml-amp-llm-models-repo.git"
EMBEDDING_MODEL_BRANCH="main"
LLM_MODEL_REPO="https://huggingface.co/h2oai/h2ogpt-oig-oasst1-512-6.9b"
LLM_MODEL_BRANCH="main"

# Optional get identity of git servers (add yours here)
mkdir -p ~/.ssh/
ssh-keyscan github.com >> ~/.ssh/known_hosts
ssh-keyscan huggingface.co  >> ~/.ssh/known_hosts

# Clear out any existing checked out models
rm -rf ./models
mkdir models
cd models

# Downloading model for generating vector embeddings
GIT_LFS_SKIP_SMUDGE=1 git clone ${EMBEDDING_MODEL_REPO} -b ${EMBEDDING_MODEL_BRANCH} embedding-model 
cd embedding-model
git checkout ${EMBEDDING_MODEL_BRANCH}
# You must provide ALL urls of .lfs files (examples are provided below)
curl -O -L "https://huggingface.co/sentence-transformers/all-MiniLM-L12-v2/resolve/main/pytorch_model.bin?download=true"
echo "Finished download of LFS file for embedding-model"
cd ..
  
# Downloading LLM model that has been fine tuned to handle instructions/q&a
GIT_LFS_SKIP_SMUDGE=1 git clone ${LLM_MODEL_REPO} -b ${LLM_MODEL_BRANCH} llm-model
cd llm-model
git checkout ${LLM_MODEL_BRANCH}
# You must provide ALL urls of .lfs files (examples are provided below)
curl -O -L "https://raw.githubusercontent.com/frischHWC/cml-amp-llm-models-repo/master/pymodel.bin"
echo "Finished download of LFS file for llm-model"

cd ..
