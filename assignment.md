# HW_L5_03 – Team Project

# Automatic Deployment of a Web Application with Docker and Ansible

## Project Objective

In this project, you must clone a web application from GitHub, write a `Dockerfile` and `docker-compose.yml` for it, deploy it on a server, expose it using Nginx, add TLS/SSL, and finally automate the entire deployment process using Ansible.

This project combines all of the skills you have learned into a real-world deployment scenario.

---

# Phase 1 – Environment Preparation

## 1.1 Create or Rent a Server

### Requirements

You must prepare an **Ubuntu Server 22.04**.

You have two options:

### Option 1 – VirtualBox or VMware

* Create an Ubuntu Server 22.04 virtual machine.
* Allocate at least:

  * 2 GB RAM
  * 20 GB Disk Space
* Configure networking so the server is reachable from your local machine.
* Record the server IP address.

### Option 2 – VPS

* Rent an Ubuntu Server 22.04 VPS.
* Allocate at least:

  * 2 GB RAM
  * 20 GB Disk Space
* Record:

  * Server IP Address
  * Login credentials

### Required Output

Create:

`01_environment/server_info.md`

Include:

* Server IP Address
* Username used for connection
* SSH access method
* System specifications (CPU, RAM, Disk)

---

## 1.2 Connect to the Server and Inspect It

### Requirements

1. Connect to the server using SSH.
2. Collect the following information:

* Kernel version
* OS version
* Disk usage
* Memory usage
* Network interfaces

### Hints

Use commands such as:

* `uname`
* `lsb_release`
* `df`
* `free`

Save the command outputs into a file.

### Required Output

Create:

`01_environment/connection_server.txt`

Include the outputs of all system inspection commands.

---

# Phase 2 – Preparing the Server with Ansible

## 2.1 Install and Configure Ansible

---

## 2.2 Create an Inventory

### Requirements

1. Create an inventory file.
2. Define your server in the inventory.
3. Configure appropriate variables.
4. Test the Ansible connection.

### Hints

* Use either **INI** or **YAML** inventory format.
* Specify the Python interpreter.
* Test connectivity using:

```bash
ansible -m ping
```

### Required Output

Create:

```
02_ansible_setup/inventory
```

Create:

```
02_ansible_setup/ping_test.txt
```

Include the output of the Ansible ping test.

Create:

```
02_ansible_setup/facts.txt
```

Include the output of:

```bash
ansible -m setup
```

---

## 2.3 Server Preparation Playbook

### Requirements

Write an Ansible playbook that prepares the server for deployment.

The playbook must:

1. Update the system.
2. Install required packages:

* curl
* wget
* git
* vim
* htop
* ufw (Firewall)

3. Install Docker and Docker Compose.
4. Enable and start the Docker service.
5. Add the current user to the Docker group.
6. Install and start Nginx.
7. Configure the firewall:

* Port 22 (SSH)
* Port 80 (HTTP)
* Port 443 (HTTPS)

### Hints

* Use the `apt` module to install packages.
* Use the `systemd` module to manage services.
* Use the `user` module to add users to groups.
* Use the `ufw` module for firewall configuration.
* Use `become: yes` for privilege escalation.

### Required Output

Create:

```
02_ansible_setup/server_setup.yml
```

Create:

```
02_ansible_setup/playbook_output.txt
```

Include the playbook execution output.

Create:

```
02_ansible_setup/verification.txt
```

Include:

* Docker version
* Nginx version
* Service status
* Firewall status
# Phase 3 – Selecting and Cloning a GitHub Project

## 3.1 Search and Select a Project

### Requirements

Find a suitable project on GitHub that:

* Includes a web application.
* Uses a database.
* Is suitable for Docker practice.
* Is simple and easy to understand.

### Suggestions

You may use one of the following resources:

* `docker/awesome-compose` repository
* Search for:

  * `docker compose flask mysql example`
  * `docker compose nginx flask mysql`
  * `docker example voting app`

### Hints

* Projects in the `docker/awesome-compose` repository are usually simple and suitable.
* The project should include both a frontend and a backend.
* The project should use a database.

---

## 3.2 Clone and Inspect the Project

### Requirements

1. Clone the project.
2. Inspect the project structure.
3. List the existing files.
4. Check whether a `Dockerfile` or `docker-compose.yml` already exists.
5. Identify the project requirements and dependencies.

### Required Output

Create:

`03_project_clone/project_structure.txt`

Include:

* Complete folder structure
* List of important files

Create:

`03_project_clone/project_info.md`

Include:

* Project URL
* Project description
* Technologies used
* Dependencies
* Ports used

---

# Phase 4 – Writing Dockerfile and docker-compose.yml

## 4.1 Analyze the Project

### Requirements

1. Check whether the project already has a `Dockerfile`.
2. Check whether the project already has a `docker-compose.yml`.
3. If they exist, analyze them.
4. If they do not exist or need modification, write them yourself.

### Hints

* Use `cat` or `less` to inspect files.
* Identify project requirements.
* Determine the required ports.
* Identify required environment variables.

---

## 4.2 Write the Dockerfile

### Requirements

Write a Dockerfile for the application that:

1. Chooses an appropriate base image.
2. Sets the working directory.
3. Installs dependencies.
4. Copies the application code.
5. Exposes the application port.
6. Defines the command used to run the application.

### Hints

* Use official images.
* Use multi-stage builds for optimization.
* Use `.dockerignore`.
* Optimize image layers.
* Follow security best practices.

### Required Output

Create:

`04_docker/Dockerfile`

Create (if needed):

`04_docker/.dockerignore`

Create:

`04_docker/dockerfile_explanation.md`

Include an explanation for every line of the Dockerfile.

---

## 4.3 Write docker-compose.yml

### Requirements

Write a `docker-compose.yml` that:

1. Defines the Web Application service.
2. Defines the Database service.
3. Configures an appropriate network.
4. Defines volumes for persistence.
5. Manages environment variables.
6. Configures port mapping.
7. Defines dependencies between services.
8. Configures restart policies.

### Hints

* Use version **3.8** or higher.
* Use named volumes for the database.
* Use `depends_on` to control startup order.
* Add health checks.
* Define environment variables either inline or using a separate file.

### Required Output

Create:

`04_docker/docker-compose.yml`

Create:

`04_docker/compose_explanation.md`

Include an explanation of the Docker Compose configuration.

---

## 4.4 Test the Local Build

### Requirements

1. Build the Docker images.
2. Run the containers.
3. Test the application.
4. Inspect the logs.
5. Resolve any issues if they occur.

### Hints

* Use `docker-compose build`.
* Use `docker-compose up -d` to run containers in the background.
* Use `docker-compose logs` to inspect logs.
* Test the application using `curl` or a web browser.

### Required Output

Create:

`04_docker/build_log.txt`

Include the build output.

Create:

`04_docker/container_status.txt`

Include the output of:

`docker-compose ps`

Create:

`04_docker/test_results.txt`

Include the application test results.
# Phase 5 – Deployment on the Server

## 5.1 Transfer Project Files to the Server

### Requirements

Transfer the project files to the server. You may use one of the following methods:

1. `scp`
2. `rsync`
3. Clone the Git repository directly on the server.
4. Ansible `copy` module.

### Hints

* Preserve the project directory structure.
* Consider file permissions.
* Keep sensitive files secure.

---

## 5.2 Build and Run on the Server

### Requirements

1. Connect to the server.
2. Navigate to the project directory.
3. Build the Docker images.
4. Run the containers.
5. Check the container status.
6. Review the container logs.

### Hints

* Use `docker-compose build`.
* Use `docker-compose up -d`.
* Use `docker-compose ps` to check container status.
* Use `docker-compose logs -f` to monitor logs.

### Required Output

Create:

`05_deployment/deploy_log.txt`

Include the deployment output.

Create:

`05_deployment/container_status.txt`

Include the container status.

Create:

`05_deployment/container_logs.txt`

Include important container logs.

---

## 5.3 Test Application Accessibility

### Requirements

1. Test the application from the server.
2. Test the application from the local machine.
3. Verify that the application works correctly.

### Hints

* Use:

```bash
curl http://localhost:PORT
```

* From the local system use:

```bash
curl http://SERVER_IP:PORT
```

* Check the response.

### Required Output

Create:

`05_deployment/test_results.txt`

Include:

* Test results from the server.
* Test results from the local machine.
* Screenshot or sample response.

---

# Phase 6 – Nginx Configuration

## 6.1 Design the Configuration

### Requirements

Before writing the configuration, design:

1. The domain name (for example: `local.myapp`)
2. The application port.
3. Reverse proxy settings.
4. Required HTTP headers.

### Hints

* Use the Reverse Proxy pattern.

* Important headers:

  * `Host`
  * `X-Real-IP`
  * `X-Forwarded-For`
  * `X-Forwarded-Proto`

* Use `proxy_pass`.

---

## 6.2 Create the Nginx Configuration

### Requirements

Write an Nginx configuration file that:

1. Listens on port **80**.
2. Handles the selected domain name.
3. Proxies requests to the application.
4. Sets the required headers.
5. Includes error handling.

### Hints

* Place the configuration inside:

```
/etc/nginx/sites-available/
```

* Use `proxy_pass`.
* Use `proxy_set_header`.
* Use `location` blocks.

### Required Output

Create:

`06_nginx/nginx_config.txt`

Create:

`06_nginx/nginx_explanation.md`

Include an explanation of the Nginx configuration.

---

## 6.3 Enable the Configuration

### Requirements

1. Place the configuration inside `sites-available`.
2. Create a symbolic link in `sites-enabled`.
3. Disable the default site.
4. Test the configuration.
5. Reload Nginx.

### Hints

Use:

* `ln -s`
* `nginx -t`
* `systemctl reload nginx`

---

## 6.4 Configure /etc/hosts

### Requirements

1. Edit the `/etc/hosts` file on the local machine.
2. Map the selected domain name to the server IP.
3. Save the changes.

### Hints

Use:

```bash
sudo nano /etc/hosts
```

Format:

```
IP_ADDRESS domain_name
```

After saving, clear the DNS cache.

### Required Output

Create:

`06_nginx/hosts_file.txt`

Include the contents of the `/etc/hosts` file.

---

## 6.5 Test Access

### Requirements

1. Test the application from the local machine using the configured domain name.
2. Verify that Nginx correctly proxies requests.
3. Inspect the HTTP response.

### Hints

* Use:

```bash
curl http://domain_name
```

* Test using a web browser.
* Verify the HTTP headers.

### Required Output

Create:

`06_nginx/nginx_test_results.txt`

Include the results of the access tests.
# Phase 7 – TLS/SSL Configuration

## 7.1 Generate a Self-Signed Certificate

### Requirements

1. Create a directory for the certificates.
2. Generate a private key.
3. Create a certificate request (CSR).
4. Generate a self-signed certificate.
5. Configure appropriate permissions.

### Hints

* Use `openssl genrsa` to generate the private key.
* Use `openssl req` to generate the certificate request.
* Use `openssl x509` to create the self-signed certificate.
* Keep certificate permissions secure.

### Required Output

Create:

`07_ssl/certificate_info.txt`

Include:

* Certificate file paths
* Certificate information
* Expiration date

---

## 7.2 Update the Nginx Configuration

### Requirements

Update the Nginx configuration so that it:

1. Redirects HTTP requests to HTTPS.
2. Listens on port **443**.
3. Loads the SSL certificate and private key.
4. Configures SSL protocols and ciphers.
5. Proxies requests to the application.

### Hints

* Use `return 301` for HTTP redirection.

* Use:

  * `ssl_certificate`
  * `ssl_certificate_key`

* Configure:

  * `ssl_protocols`
  * `ssl_ciphers`

* Follow security best practices.

### Required Output

Create:

`07_ssl/nginx_ssl_config.txt`

Include the complete SSL-enabled Nginx configuration.

---

## 7.3 Reload and Test

### Requirements

1. Test the Nginx configuration.
2. Reload Nginx.
3. Test the HTTP redirect.
4. Test the HTTPS connection.

### Hints

* Use:

```bash id="omznbk"
nginx -t
```

* Use:

```bash id="n8gmbd"
curl -L
```

to follow redirects.

* Use:

```bash id="vz31z7"
curl -k
```

to ignore certificate warnings while testing.

### Required Output

Create:

`07_ssl/test_results.txt`

Include:

* HTTP redirect test results
* HTTPS test results
* Certificate information

---

# Phase 8 – Automation with Ansible

## 8.1 Design the Automation

### Requirements

Before writing the playbooks, design:

1. Which tasks should be automated.
2. The execution order.
3. Required variables.
4. Required handlers.
5. Required templates.

### Hints

* Break down the deployment process.
* Identify dependencies.
* Consider error handling.

---

## 8.2 Application Deployment Playbook

### Requirements

Write a playbook that:

1. Creates the application directory.

2. Copies the project files:

   * Dockerfile
   * docker-compose.yml
   * Application source code

3. Builds the Docker images.

4. Runs the containers.

5. Verifies the deployment status.

### Hints

* Use the `copy` module for files.
* Use the `docker_compose` module for Docker operations.
* Use `wait_for` to wait for services.
* Use `register` and `debug` for verification.

### Required Output

Create:

`08_ansible_automation/deploy_app.yml`

Create (if needed):

`08_ansible_automation/app_vars.yml`

---

## 8.3 Nginx Deployment Playbook

### Requirements

Write a playbook that:

1. Creates the SSL directory.
2. Generates the SSL certificate.
3. Deploys the Nginx configuration template.
4. Enables the site.
5. Disables the default site.
6. Reloads Nginx.

### Hints

* Use the `openssl_certificate` module.
* Use the `template` module for the configuration.
* Use the `file` module to create symbolic links.
* Use handlers to reload Nginx.

### Required Output

Create:

`08_ansible_automation/deploy_nginx.yml`

Create:

`08_ansible_automation/templates/nginx.conf.j2`

Create (if needed):

`08_ansible_automation/nginx_vars.yml`

---

## 8.4 Create the Main Playbook

### Requirements

Create a main playbook that:

1. Imports all playbooks.
2. Maintains the correct execution order.
3. Is reusable.

### Hints

* Use `import_playbook`.
* Use `main.yml` or `site.yml`.

### Required Output

Create:

`08_ansible_automation/site.yml`

---

## 8.5 Execute and Test

### Requirements

1. Run the playbooks.
2. Review the output.
3. Verify the application.
4. Fix any issues if they occur.

### Hints

* Use `--check` for dry-run.
* Use `-v` for verbose output.
* Use `--diff` to view changes.

### Required Output

Create:

`08_ansible_automation/playbook_output.txt`

Include the playbook execution output.

Create:

`08_ansible_automation/verification.txt`

Include the verification results.
# Phase 9 – Documentation

## 9.1 README.md

### Requirements

Write a complete `README.md` that includes:

1. Project description
2. Prerequisites
3. Installation instructions
4. Usage instructions
5. Project structure
6. Configuration
7. Troubleshooting

### Required Output

Create:

`README.md`

Place it in the project root directory.

---

## 9.2 Architecture Documentation

### Requirements

Write an architecture document that:

1. Explains the overall architecture.
2. Introduces all components.
3. Describes the deployment flow.
4. Includes diagrams.

### Hints

* Use text-based diagrams.
* Use ASCII art.
* Show the deployment flow step by step.

### Required Output

Create:

`09_documentation/architecture.md`

---

## 9.3 Deployment Guide

### Requirements

Write a deployment guide that:

1. Contains step-by-step instructions.
2. Includes all required commands.
3. Shows the expected outputs.
4. Covers common deployment issues.

### Required Output

Create:

`09_documentation/deployment_guide.md`

---

## 9.4 Troubleshooting Guide

### Requirements

Write a troubleshooting guide that:

1. Lists common issues.
2. Explains the cause of each issue.
3. Provides solutions.

### Required Output

Create:

`09_documentation/troubleshooting.md`

---

# Phase 10 – Final Delivery

## 10.1 Git Repository

### Requirements

1. Initialize a Git repository.
2. Add all project files.
3. Make meaningful commits.
4. Push the repository to GitHub or GitLab.

### Hints

* Use `.gitignore`.
* Write meaningful commit messages.
* Follow a proper branching strategy.

### Required Output

* Complete Git repository containing all commits.

Create:

`10_delivery/git_history.txt`

Include the output of:

```bash
git log --oneline --graph
```

---

## 10.2 Project Summary

### Requirements

Write a project summary that includes:

1. Challenges encountered.
2. Solutions implemented.
3. Lessons learned.
4. Suggested improvements.

### Required Output

Create:

`10_delivery/project_summary.md`

---

## 10.3 Final Project Structure

### Requirements

Document the final project structure.

### Required Output

Create:

`10_delivery/final_structure.txt`

Include the output of either:

* `tree`
* `find`

---

## 10.4 Team Contribution

### Requirements

Document the contribution of each team member.

### Required Output

Create:

`10_delivery/team_contribution.md`

Include:

* Work distribution
* Contribution of each member
* Challenges faced by each member

---

# Important Notes

## Teamwork

* Divide responsibilities logically.
* One team member should focus on Docker while another focuses on Ansible.
* Perform code reviews.
* Make regular commits.

---

## Testing

* Test every stage before moving to the next.
* Use logs for debugging.
* Use Ansible dry-run whenever possible.

---

## Security

* Store passwords in variables files.
* Use `.gitignore` for sensitive files.
* Keep SSL certificates secure.

---

## Best Practices

* Keep the code clean and readable.
* Write meaningful comments.
* Keep the documentation up to date.

---

# Useful Resources

* Docker Documentation: https://docs.docker.com/
* Docker Compose Documentation: https://docs.docker.com/compose/
* Ansible Documentation: https://docs.ansible.com/
* Nginx Documentation: https://nginx.org/en/docs/
* OpenSSL Documentation: https://www.openssl.org/docs/

---

# Common Problems

## Docker Build Fails

### What to check

* Review the build logs.
* Check the Dockerfile syntax.
* Verify all dependencies.
* Verify the base image.

---

## Ansible Connection Fails

### What to check

* Test the SSH connection.
* Verify the inventory file.
* Check file permissions.
* Verify the Python interpreter.

---

## Nginx – 502 Bad Gateway

### What to check

* Check the container status.
* Verify the port mapping.
* Review the proxy configuration.
* Review the container logs.

---

## SSL Certificate Errors

### What to check

* Verify the certificate path.
* Check file permissions.
* Verify certificate validity.
* Test the Nginx configuration.

---

This project is an excellent opportunity to apply all of the skills you have learned in a real-world scenario. Enjoy the process and do your best!
