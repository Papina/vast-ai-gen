

FROM vastai/comfy:cuda-12.9-auto

# Install your applications into /opt/workspace-internal/
# This ensures files can be properly synced between instances
WORKDIR /opt/workspace-internal/

COPY provision.sh .

RUN . provision.sh
# Activate virtual environment from base image
# RUN . /venv/main/bin/activate

# RUN your-installation-commands