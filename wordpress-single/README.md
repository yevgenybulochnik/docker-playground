# WordPress in A single docker image
This was my first foray into docker. Technically docker images are not supposed to have multiple running processes, however, my intention was to see how well docker works in a limited resource system and if it could function as a sudo-replacement for vagrant. Ultimately its possible to replace vagrant, but with a few important caveats. 

+ Docker Caveats:
	+ Should be used for only single processes 
	+ Can be used for multi-process but requires a script to restart processes on run or start
		+ Optional service manger [supervisord](http://supervisord.org/)
		+ example start [script](https://github.com/yevgenybulochnik/docker-playground/blob/master/wordpress-single/config/start.sh)
		+ Docker `ENTRYPOINT` and `CMD` used to start services
	+ Docker Ubuntu base image has few installed packages compared to vagrant box images. (depends completely on which image is used)
		+ debconf-utils and curl needed to be installed
	+ Having `/bin/bash` in `CMD` or the last part of `ENTRYPOINT` will place you into bash in the container
  
### Example Usage:
```
docker build -t wordpress:0.1 .
docker run --name wordpress-single -it -p <host-port>:80 wordpress:0.1
```
Container can be started and stopped with `docker start wordpress-single` or `docker stop wordpress-single`. Start will place you into bash, `CTRL-p q` will keep the container running but place you back into the host. 
