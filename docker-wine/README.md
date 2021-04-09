
### docker-compose.yml

```yml
version: '2'
services:
  app:
    image: scottyhardy/docker-wine:latest
    restart: always
    working_dir: /work
    container_name: app
    environment:
      - LANG=zh_CN.UTF-8
      - RUN_AS_ROOT=yes
      - TZ=UTC-8
    privileged: true
    ports:
      - 8080:8080
    volumes:
      - /var/lib/work:/work
    command: wine app.exe -console
```



### Parameter description

#### time zone

Whenever you specify a timezone in the format of `+/-00:00`, you are specifying an `offset`, not the actual timezone. From the `GNU libc` [documentation](http://www.gnu.org/software/libc/manual/html_node/TZ-Variable.html)(which follows the `POSIX` standard)

```sh
# It's actual the east 8th district time zone
- TZ=UTC-8
```



#### run as a script

```
command: wine cmd.exe /C run.bat
```



#### [wine start usage](https://wiki.winehq.org/Start)

```sh
#Don't create a new console for the program.
command: wine start /b app.exe

#Start the program minimized.
command: wine start /min app.exe
```
