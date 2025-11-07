# vscode-remote-tunnels

VSCode remote tunnels Docker image that can be easily deployed everywhere you want

Its purpose is to provide a [Visual Studio Code Server](https://code.visualstudio.com/docs/remote/vscode-server) instance accessible through [vscode.dev](https://vscode.dev). 

## Configuration

### local storage directory

1. create a local `data/` directory to persist the vscode server data:
    ```sh
    mkdir data
    ```

2. create 2 empty files in the `data/` directory:
    ```sh
    touch data/code_tunnel.json data/token.json
    ```

### configure environment variables in `.env`

The container is configurable using the following environment variables:

| Name | Mandatory | Default value| Description |
|------|-----------|--------------|-------------|
|MACHINE_NAME|No|`vscode-tunnel`|The name of the machine that will be used to access the tunnel. It **must** be less than 20 characters.|
|UID|No|`0`|User ID to run the container as. Use your local user ID to avoid permission issues.|
|GID|No|`0`|Group ID to run the container as. Use your local group ID to avoid permission issues.|
|USER|No|`root`|Username for the container environment.|
|HOME|No|`/root`|Home directory path for the container user.|

A sample environment file ([example.env](./example.env)) is provided for reference. Copy it to `.env` and adjust the values according to your setup:

```sh
cp example.env .env
# Edit .env with your values
```

Additionally, it is also possible to override the script at path `/usr/local/bin/init` to install additional software when the container boots.

## Running

You can run this image using [Docker compose](https://docs.docker.com/compose/).

```sh
docker compose build
docker compose up -d
```
