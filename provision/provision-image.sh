#!/bin/bash

COMFYUI_DIR=${WORKSPACE}/ComfyUI

# Packages are installed after nodes so we can fix them...

APT_PACKAGES=(
    #"package-1"
    #"package-2"
)

PIP_PACKAGES=(
    #"package-1"
    #"package-2"
)

# ~30 Minutes for the ComfyUI custom nodes
NODES=(
    # Always Need
    "https://github.com/kijai/ComfyUI-KJNodes"
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack"
    "https://github.com/rgthree/rgthree-comfy"
    "https://github.com/pythongosssss/ComfyUI-Custom-Scripts"

    "https://github.com/justUmen/Bjornulf_custom_nodes"
    "https://github.com/kijai/ComfyUI-MMAudio"
    "https://github.com/Artificial-Sweetener/comfyui-WhiteRabbit"
    "https://github.com/Extraltodeus/Skimmed_CFG"
    "https://github.com/Fannovel16/ComfyUI-Frame-Interpolation"
    "https://github.com/Fannovel16/comfyui_controlnet_aux"
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite"
    "https://github.com/LukeCoulson1/Comfyui_LoraCombine"
    "https://github.com/M1kep/ComfyLiterals"
    "https://github.com/SeargeDP/SeargeSDXL"
    "https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes"
    "https://github.com/alexopus/ComfyUI-Image-Saver"
    "https://github.com/chibiace/ComfyUI-Chibi-Nodes"
    "https://github.com/cubiq/ComfyUI_IPAdapter_plus"
    "https://github.com/giriss/comfy-image-saver"
    "https://github.com/jags111/efficiency-nodes-comfyui"
    "https://github.com/jamesWalker55/comfyui-various"
    "https://github.com/moonwhaler/comfyui-seedvr2-tilingupscaler"
    "https://github.com/receyuki/comfyui-prompt-reader-node"
    "https://github.com/spacepxl/ComfyUI-Image-Filters"
    "https://github.com/stduhpf/ComfyUI-WanMoeKSampler"
    "https://github.com/twri/sdxl_prompt_styler"
    "https://github.com/un-seen/comfyui-tensorops"
    "https://github.com/vrgamegirl19/comfyui-vrgamedevgirl"
    "https://github.com/willmiao/ComfyUI-Lora-Manager"
)

WORKFLOWS=(

)


# ~36GB
CHECKPOINT_MODELS=(
    # "https://civitai.com/api/download/models/2334591?type=Model&format=SafeTensor&size=pruned&fp=fp16" # CyberRealistic Pony v14.1 - 6.5GB
    # "https://civitai.com/api/download/models/2388548?type=Model&format=SafeTensor&size=full&fp=fp8"    # aSiWa WAN 2.2 I2V 14B Lightspeed MidnightFlirt - 14GB High Noise
    # "https://civitai.com/api/download/models/2388627?type=Model&format=SafeTensor&size=full&fp=fp8"    # aSiWa WAN 2.2 I2V 14B Lightspeed MidnightFlirt - 14GB Low Noise
   # "https://civitai.com/api/download/models/2342708?type=Model&format=SafeTensor&size=full&fp=fp8"    # DaSiWa WAN 2.2 I2V 14B Lightspeed LureNoir - 14GB High Noise
   # "https://civitai.com/api/download/models/2342740?type=Model&format=SafeTensor&size=full&fp=fp8"    # DaSiWa WAN 2.2 I2V 14B Lightspeed LureNoir - 14GB Low Noise
)

# ~20GB
DIFFUSION_MODELS=(
    # "https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_2509_fp8_e4m3fn.safetensors" #QWEN Image EDIT 2509 20GB
)

# ~17GB
TEXT_ENCODERS=(
    # "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors" # 6.8GB
    # "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors" # 9.4GB
)

UNET_MODELS=(

)

# ~33GB
LORA_MODELS=(
    # "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors" #1.3GB
    # "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors". #1.3GB
    # "https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Edit-2509/Qwen-Image-Edit-2509-Lightning-4steps-V1.0-bf16.safetensors" # 811MB
    # "https://civitai.com/api/download/models/2274776?type=Model&format=Diffusers"  # Secret Sauce 28GB
    # "https://civitai.com/api/download/models/2239404?type=Model&format=SafeTensor" # Micro Bikini / Sling Bikini Low 300MB
    # "https://civitai.com/api/download/models/2239110?type=Model&format=SafeTensor" # Micro Bikini / Sling Bikini High 300MB
    # "https://civitai.com/api/download/models/2270582?type=Model&format=SafeTensor" # v4 Instagram Women (Wan 2.1 & 2.2) - Official 2.2 Low 300MB
    # "https://civitai.com/api/download/models/2270577?type=Model&format=SafeTensor" # v4 Instagram Women (Wan 2.1 & 2.2) - Official 2.2 High 300MB
)

# ~500MB
VAE_MODELS=(
    # "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors" # 254MB
    # "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors" # 250MB
)

# ~50MB
ESRGAN_MODELS=(
    # "https://huggingface.co/Comfy-Org/Real-ESRGAN_repackaged/resolve/main/RealESRGAN_x4plus.safetensors" # 50MB
)

UPSCALE_MODELS=(
    # "https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth" #67MB
)

CONTROLNET_MODELS=(
    # "https://huggingface.co/comfyanonymous/ControlNet-v1-1_fp16_safetensors/resolve/main/control_v11p_sd15_openpose_fp16.safetensors" # 723MB
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    provisioning_print_header
    provisioning_get_apt_packages
    provisioning_get_nodes
    provisioning_get_pip_packages
    provisioning_get_files \
        "${COMFYUI_DIR}/models/checkpoints" \
        "${CHECKPOINT_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/diffusion_models" \
        "${DIFFUSION_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/text_encoders" \
        "${TEXT_ENCODERS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/unet" \
        "${UNET_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/loras" \
        "${LORA_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/controlnet" \
        "${CONTROLNET_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/vae" \
        "${VAE_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/esrgan" \
        "${ESRGAN_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/upscale_models" \
        "${UPSCALE_MODELS[@]}"        
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

function provisioning_get_files() {
    if [[ -z $2 ]]; then return 1; fi
    
    dir="$1"
    mkdir -p "$dir"
    shift
    arr=("$@")
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${arr[@]}"; do
        printf "Downloading: %s\n" "${url}"
        provisioning_download "${url}" "${dir}"
        printf "\n"
    done
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Application will start now\n\n"
}

function provisioning_has_valid_hf_token() {
    [[ -n "$HF_TOKEN" ]] || return 1
    url="https://huggingface.co/api/whoami-v2"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

function provisioning_has_valid_civitai_token() {
    [[ -n "$CIVITAI_TOKEN" ]] || return 1
    url="https://civitai.com/api/v1/models?hidden=1&limit=1"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $CIVITAI_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

# Download from $1 URL to $2 file path
function provisioning_download() {
    if [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        auth_token="$HF_TOKEN"
    elif 
        [[ -n $CIVITAI_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?civitai\.com(/|$|\?) ]]; then
        auth_token="$CIVITAI_TOKEN"
    fi

    echo "--> $1 into $2"
    if [[ -n $auth_token ]];then
        echo "--> $1 into $2"
        curl -L -J -O --output-dir "$2" -H "Authorization: Bearer $auth_token" "$1"
    else
        curl -L -J -O --output-dir "$2" "$1"
    fi
}

# Allow user to disable provisioning if they started with a script they didn't want
if [[ ! -f /.noprovisioning ]]; then
    provisioning_start
fi
