FROM vastai/comfy:cuda-12.9-auto

# Install your applications into /opt/workspace-internal/
# This ensures files can be properly synced between instances
WORKDIR /opt/workspace-internal/

# Activate virtual environment from base image
RUN . /venv/main/bin/activate

COPY provision.sh .

ENV WORKSPACE=/opt/workspace-internal
RUN . provision.sh
