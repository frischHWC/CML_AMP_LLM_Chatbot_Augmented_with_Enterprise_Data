# This script is used to pre=download files stored with git-lfs in CML Runtimes which do not have git-lfs support
# You can use any models that can be loaded with the huggingface transformers library. See utils/model_embedding_utls.py or utils/moderl_llm_utils.py
EMBEDDING_MODEL_REPO="git@github.com:frischHWC/cml-amp-llm-models-repo.git"
EMBEDDING_MODEL_BRANCH="master"
LLM_MODEL_REPO="https://huggingface.co/h2oai/h2ogpt-oig-oasst1-512-6.9b"
LLM_MODEL_BRANCH="master"

# You must provide ALL urls of .lfs files (examples are provided below)
LFS_FILES=(
    "https://huggingface.co/sentence-transformers/all-MiniLM-L12-v2/resolve/main/pytorch_model.bin\?download\=true"
    "https://raw.githubusercontent.com/frischHWC/cml-amp-llm-models-repo/master/pymodel.bin"
)

download_lfs_files () {
    echo "These files must be downloaded manually since there is no git-lfs here:"
    for FILE_TO_DOWNLOAD in "${LFS_FILES[@]}"
    do
       echo "Starting download of: $FILE_TO_DOWNLOAD"
       curl -O -L $FILE_TO_DOWNLOAD
       echo "Finished download of: $FILE_TO_DOWNLOAD"
    done
}

# Clear out any existing checked out models
rm -rf ./models
mkdir models
cd models

# Downloading model for generating vector embeddings
GIT_LFS_SKIP_SMUDGE=1 git clone ${EMBEDDING_MODEL_REPO} --branch ${EMBEDDING_MODEL_BRANCH} embedding-model 
cd embedding-model
download_lfs_files
cd ..
  
# Downloading LLM model that has been fine tuned to handle instructions/q&a
GIT_LFS_SKIP_SMUDGE=1 git clone ${LLM_MODEL_REPO} --branch ${EMBEDDING_MODEL_BRANCH} llm-model
cd llm-model
download_lfs_files 
cd ..
