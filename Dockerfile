# Use Ubuntu 22 as the base image
# FROM ubuntu:22.04
FROM ubuntu:22.04

ENV USERNAME mitch
ENV PASSWORD rosie7

# Set the timezone from environment variable. Avoids tzdata prompting user to set their location. (https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai)
ENV TIMEZONE=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone

# TODO: Make sure these are actually needed. Was getting and error that location on a Linux system where package files are stored after they are downloaded was too small.
# Create a new volume for the /var/cache/apt/archives directory
# VOLUME /var/cache/apt/archives
# Run the apt-get update command
# RUN apt-get update

# Create a shared volume for the workspace
VOLUME /home/$USERNAME/osu-uwrt

WORKDIR /home/$USERNAME/osu-uwrt

# # Copy the osu-uwrt contents for image creation. Note this must be done as the shared volume does not take effect until container creation.
COPY . .

# Set the working directory to the shared volume
# WORKDIR /osu-uwrt

# Get git
RUN apt-get update && apt-get install -y git

# Install sudo. Add a user. Give user a password. Give user access to sudo.
RUN apt-get update && \
    apt-get install -y sudo && \
    useradd -m -s /bin/bash $USERNAME && \
    echo "${USERNAME}:${PASSWORD}" | chpasswd && \
    adduser $USERNAME sudo

# Give everyone read and execute permissions on most files and directories
RUN chmod 755 /

# Give the user read and write permissions on their own home directory
# RUN chmod 775 /home/$USERNAME
# RUN chown -R $USERNAME:$USERNAME /home/$USERNAME

RUN chown -R mitch /home/$USERNAME

RUN apt-get update && apt-get install -y lsb-release

# Make the script executable
# COPY setup.bash /home/$USERNAME/osu-uwrt/

# RUN chmod +x riptide_setup/setup.bash
# RUN chmod +x test.bash

# As root, give the user temporary ability to run sudo without a password. This is necessary so that sudo commands in setup.bash can run correctly without a terminal for the user to be prompted.
RUN echo Defaults:$USERNAME !authenticate >> /etc/sudoers
# Run setup bash script as the user.
USER $USERNAME
# RUN ./riptide_setup/setup.bash
RUN touch if_this_file_is_here_copy_from_image_worked

RUN ./riptide_setup/setup.bash
# RUN mkdir ./test
# Switch to root. Remove the user's ability to run sudo without a password. Switch back to the user.
USER root
RUN sed -i "/Defaults:$USERNAME !authenticate/d" /etc/sudoers
USER $USERNAME

# Run the script when the container starts
# CMD ["./setup.bash"]




