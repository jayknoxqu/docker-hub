FROM scottyhardy/docker-wine:latest

MAINTAINER jayknoxqu@gmail.com

ENV TZ=Asia/Shanghai RUN_AS_ROOT=yes

WORKDIR /app

COPY . .

#ENTRYPOINT ["/usr/bin/entrypoint"]

#ENTRYPOINT ["wineconsole","run.bat"]

ENTRYPOINT ["wine","xxx.exe","-console"]
