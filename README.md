# Docker Image for SimplyE Patron Web Interface

This repository provides a working demonstration of the Library Simplified/SimplyE web-based client interface as a Docker image/container. You can find the parent codebase at <https://github.com/NYPL-Simplified/circulation-patron-web>.

If you will be developing code for the project, you will need to build a local version of the Docker image to review your changes. The following section provides instructions for a local build. If you are not doing any development or making any code changes, but you just want to see the project running locally, you can skip to the section *Running a Container from the Image* below and use the second command there.

## Building the Docker Image ##

When you have code changes you wish to review locally, you will need to build a local Docker image with your changes included. There are a few steps to get a working build:

1. Push your code changes into a separate git repository which is accessible for cloning in your current environment. As an example, let's assume your GitHub username is `nedgavlin`, that you've forked the parent repository into your account, and that you've pushed your code changes to a working branch named `my-code-changes` (used in step 6).

2. Clone this repository into a clean directory in preparation for the build, then change into the repository directory:
    ```
    git clone https://github.com/lyrasis/docker-patron-web.git ./patronweb
    cd patronweb
    ```

3. As instructed in the README for the parent project, you must have already configured development access to the Circulation Manager from this local application by adding a sitewide setting to the Circulation Manager. Review that document as needed.

4. Review the file `config/cm-libraries.conf.sample` for proper formatting in creating a configuration file which links the web application to a library's SimplyE Circulation Manager in order to pull catalog feeds into the display. The SimplyE web client application can be configured on behalf of multiple libraries to provide a web-based client for their patrons. In a multi-tenant environment, each library will be represented in the config file as a separate line.

5. You can create an empty config file or rename the sample file with the filename `config/cm-libraries.conf`. Here's an example entry in the file for a library with a Circulation Manager short name of `abclib` whose Circulation Manager is available at the domain `circulation-simplye.library.org`:
    ```
    abclib|http://circulation-simplye.library.org/abclib
    ```

6. Once you have created the configuration file, you're ready to build the Docker image. Here's a command to build the image using the github account and repo mentioned in step 1. (Use `sudo` if needed in your Docker environment.)
    ```
    docker build -f Dockerfile  \
        --build-arg PATRONWEB_REPO=https://github.com/nedgavlin/circulation-patron-web.git \
        --build-arg REPO_VERSION=my-code-changes \
        --no-cache -t patronweb  .
    ```

	If you wanted to build an image using the parent (unchanged) code base, the two `--build-arg` parameters above are not needed. Default values in the Dockerfile will pull the code from the parent project unless otherwise directed. So that build command would be:
	```
    docker build -f Dockerfile  \
        --no-cache -t patronweb  .
    ```
    
	If you wanted to customize the image, you could create an additional Dockerfile (e.g., Dockerfile.second) and simply specify its name in the docker build commands above. The Docker file you specify will guide the image build. For this image, the build takes about 4-6 minutes, depending on your Internet speed and load on the Node package servers, to complete the final image.

## Running a Container from the Image ##

Once you have an image to run, you can instantiate the Docker container easily. If you built a local image in the section above, you can create a container from it with the following command:
    ```
    docker run --rm --name patronweb -d -p 3000:3000 \
    	-e "CONFIG_FILE=/config/cm-libraries.conf" \
        -v "./config:/config" patronweb
    ```

If you want to use the pre-built image from the parent project we have uploaded to the Docker Hub service, issue the following variant of the command:
    ```
    docker run --rm --name patronweb -d -p 3000:3000 \
    	-e "CONFIG_FILE=/config/cm-libraries.conf" \
        -v "./config:/config" lyrasis/patron-web
    ```

## Deploying a Container Using Docker-Compose ##

Instead of using the `docker run` command at the command line, it's also possible to use the `docker-compose` utility to create the container. Using docker-compose provides the advantage of encapsulating the run parameters in a configuration file that can be committed to source control. We've added an example `docker-compose.yml` file in this repository, which you can adjust as needed with parameters that fit your development.

To create the container using docker-compose, simply issue the following command:
    ```
    docker-compose up
    ```


## Notes

Any environment varibles passed into the container will be passed into node, 
so you can setup a config file or registry server to that the app will use.

## ENV

### UID
The UID that the node process will be started with in the container. Defaults to 990.

### GID
The GID that the node process will be started with in the contatiner. Defaults to 990.
