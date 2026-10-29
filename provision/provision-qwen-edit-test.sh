#!/bin/bash

source /venv/main/bin/activate
COMFYUI_DIR=${WORKSPACE}/ComfyUI

# Lean Qwen-Image 2.1 Edit (~16GB, core nodes only) for testing the Vast serverless pipeline
# before the larger H3 setup: a reference-image model with int8_convrot weights like H3's.
# Same fail-on-error download functions as provision-h3.sh.

APT_PACKAGES=(
    #"package-1"
)

PIP_PACKAGES=(
    #"package-1"
)

NODES=(

)

# ~7GB
DIFFUSION_MODELS=(
    "https://huggingface.co/Comfy-Org/Qwen-Image-2.1/resolve/main/diffusion_models/qwen_image_2.1_int8_convrot.safetensors" # 6.8GB
)

# ~9GB
TEXT_ENCODERS=(
    "https://huggingface.co/Comfy-Org/Qwen-Image-2.1/resolve/main/text_encoders/qwen3vl_8b_int8_convrot.safetensors" # 8.7GB
)

LORA_MODELS=(

)

# ~600MB
VAE_MODELS=(
    "https://huggingface.co/Comfy-Org/Qwen-Image-2.1/resolve/main/vae/qwen_image_2.1_vae_bf16.safetensors" # 600MB
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    provisioning_print_header
    provisioning_get_apt_packages
    provisioning_get_nodes
    provisioning_get_pip_packages
    provisioning_get_files \
        "${COMFYUI_DIR}/models/diffusion_models" \
        "${DIFFUSION_MODELS[@]}" || exit 1
    provisioning_get_files \
        "${COMFYUI_DIR}/models/text_encoders" \
        "${TEXT_ENCODERS[@]}" || exit 1
    provisioning_get_files \
        "${COMFYUI_DIR}/models/loras" \
        "${LORA_MODELS[@]}" || exit 1
    provisioning_get_files \
        "${COMFYUI_DIR}/models/vae" \
        "${VAE_MODELS[@]}" || exit 1
    provisioning_print_end
}

function provisioning_get_apt_packages() {
    if [[ -n $APT_PACKAGES ]]; then
            sudo $APT_INSTALL ${APT_PACKAGES[@]}
    fi
}

function provisioning_get_pip_packages() {
    if [[ -n $PIP_PACKAGES ]]; then
            pip install --no-cache-dir ${PIP_PACKAGES[@]}
    fi
}

function provisioning_get_nodes() {
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="${COMFYUI_DIR}/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating node: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                   pip install --no-cache-dir -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                pip install --no-cache-dir -r "${requirements}"
            fi
        fi
    done
}

# Large files, so fetch them in parallel and skip any already on disk.
function provisioning_get_files() {
    if [[ -z $2 ]]; then return 0; fi

    dir="$1"
    mkdir -p "$dir"
    shift
    arr=("$@")
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    pids=()
    for url in "${arr[@]}"; do
        file="${dir}/${url##*/}"
        if [[ -s $file ]]; then
            printf "Already have: %s\n" "${file}"
            continue
        fi
        printf "Downloading: %s\n" "${url}"
        provisioning_download "${url}" "${file}" &
        pids+=($!)
    done
    failed=0
    for pid in "${pids[@]}"; do
        wait "$pid" || failed=1
    done
    return $failed
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Application will start now\n\n"
}

# Download from $1 URL to $2 file path, via .part so a failed download is never mistaken for a model
function provisioning_download() {
    auth=()
    if [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        auth=(-H "Authorization: Bearer $HF_TOKEN")
    fi

    echo "--> $1 into $2"
    for attempt in 1 2 3; do
        if curl -fsSL --retry 3 -C - "${auth[@]}" -o "$2.part" "$1"; then
            mv "$2.part" "$2"
            return 0
        fi
        echo "Download failed (attempt $attempt): $1"
        sleep $((attempt * 10))
    done
    return 1
}

# Allow user to disable provisioning if they started with a script they didn't want
if [[ ! -f /.noprovisioning ]]; then
    provisioning_start
fi
