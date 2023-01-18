docker build -t riptide_image ./
docker build -t riptide_image . --progress plain (for debugging)
docker run -v $(pwd):/home/mitch/osu-uwrt -it riptide_image /bin/bash

<!-- docker volume create --opt type=none --opt device=~/osu-uwrt --opt o=bind volume-osu-uwrt -->

# Create a temporary docker container. Copy the contents of the docker container to the host machine's user home directory. Delete the container. (Set up is done this way to make sure all the files are in the host's osu-uwrt folder that will also be in the development container once a volume is created. There is no way to mount the contents of the container to the host machine right when the container is initialized from an image. Instead we must copy using this approach.) (https://stackoverflow.com/questions/25292198/docker-how-can-i-copy-a-file-from-an-image-to-a-host, https://github.com/moby/moby/issues/17470)
id=$(docker create riptide_image) 
docker cp $id:/home/mitch/osu-uwrt ~/ -a
docker rm -v $id

# Create the development container. This time create a volume between host and container osu-uwrt directories.
docker run -v $(pwd):/home/mitch/osu-uwrt -it riptide_image /bin/bash

If docker gets too full, run:
docker image prune
docker container prune