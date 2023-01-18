docker build -t riptide_image ./
docker build -t riptide_image . --progress plain (for debugging)
docker run -v $(pwd):/home/mitch/osu-uwrt -it riptide_image /bin/bash

If docker gets too full, run:
docker image prune
docker container prune 