# Jenkins-BlueOcean Setup

This repository provides a set of scripts to simplify and automate the setup of a Jenkins-BlueOcean environment using Docker containers.

## Prerequisites

- **Docker:** Ensure that Docker is installed and running on your system (Windows, macOS, or Linux).

## Usage

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/manishdait/jenkins-blueocean-setup.git
   cd jenkins-blueocean-setup
   ```

2. **Run the Setup Script:**

   - **For Windows:**
   
      Open `cmd.exe` and execute the following command:
      ```bash
      setup.bat
      ```
   - **For Linux/macOS:**
      
      Open your terminal, make the script executable, and then run it:
      ```bash
      ./setup.sh
      ```

3. **Access Jenkins:**

   Once the script has completed, open your web browser and navigate to the following URL to access your Jenkins instance:
   
   ```
   http://localhost:8080
   ```

## Setting Up Docker Cloud Agents

To enable Jenkins to use the Docker daemon on the host machine for building and running containers, you can set up a Docker Cloud Agent. This avoids running Docker within the Jenkins container itself.

**Using `alpine/socat` to Forward Traffic**

The `alpine/socat` container acts as a proxy, forwarding requests from the Jenkins container to the Docker daemon on your host machine.

1. **Run the alpine/socat container:**

    Execute the following command to start the `socat` container. This command exposes the host's Docker socket to the Jenkins container through a TCP port.

    ```bash
   docker run -d --restart=always --network jenkins -v /var/run/docker.sock:/var/run/docker.sock alpine/socat tcp-listen:2375,fork,reuseaddr unix-connect:/var/run/docker.sock
   ```

2. **Find the IP Address of the socat container:**

   After the container is running, you need its internal IP address to configure the Jenkins Docker plugin.

   ```bash
   docker inspect <container_id> | grep IPAddress
   ```

3. **Configure Jenkins:**

   - In the Jenkins dashboard, navigate to **Manage Jenkins** -> **Manage Nodes and Clouds** -> **Configure Clouds**.
   
   - Add a new cloud and select **Docker**.
   
   - In the Docker Host URI field, enter the IP address you found in the previous step, followed by the port `2375`.

      Example: `tcp://<IP_Address>:2375`
    
   - Save the configuration.