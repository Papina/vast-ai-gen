# ComfyUI Python Client

A Python client for interacting with ComfyUI via WebSocket and HTTP API.

## Features

- 🔌 WebSocket connection to monitor ComfyUI in real-time
- 📊 Check server status and queue information
- 📤 Upload and execute workflows
- 💻 View system stats (GPU VRAM usage, etc.)
- 🎯 Simple CLI interface

## Installation

```bash
pip install -r requirements.txt
```

## Usage

### Check Server Status (Default)

Simply run without any flags to check the current status:

```bash
python src/main.py
```

This displays:
- Server connection info
- Queue status (running and pending tasks)
- System information (GPU/VRAM usage)

### Upload and Run a Workflow

Use the `--upload` flag to upload and execute a workflow:

```bash
python src/main.py --upload src/comfy-api-workflows/dualfk-api.json
```

Or use the `--run` flag (same functionality):

```bash
python src/main.py --run src/comfy-api-workflows/dualfk-api.json
```

This will:
1. Load the workflow JSON file
2. Queue it for execution in ComfyUI
3. Establish WebSocket connection to monitor progress
4. Display real-time updates until completion

### Custom Server Address

Specify a different ComfyUI server address:

```bash
python src/main.py --server 192.168.1.100:8188
```

## Command-Line Options

```
--server SERVER         ComfyUI server address (default: 127.0.0.1:8000)
--upload WORKFLOW_PATH  Upload and execute a workflow JSON file
--run WORKFLOW_PATH     Run a workflow (same as --upload)
```

## Examples

```bash
# Check status
python src/main.py

# Upload workflow
python src/main.py --upload src/comfy-api-workflows/dualfk-api.json

# Use custom server
python src/main.py --server localhost:8188 --run my-workflow.json

# Just check status on custom server
python src/main.py --server 192.168.1.100:8188
```

## API Usage

You can also use the `ComfyUIClient` class directly in your own Python scripts:

```python
import asyncio
from main import ComfyUIClient

async def main():
    client = ComfyUIClient(server_address="127.0.0.1:8000")
    
    # Check status
    await client.display_status()
    
    # Execute workflow
    prompt_id = await client.execute_workflow("path/to/workflow.json")
    
    # Connect and listen for updates
    await client.connect()
    await client.listen()

asyncio.run(main())
```

## Requirements

- Python 3.7+
- websockets>=12.0
- aiohttp>=3.9.0

## License

MIT
