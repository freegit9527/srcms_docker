# 基础镜像为daocloud.io/liusheng/lamp
FROM daocloud.io/liusheng/lamp

# 作者为liusec
MAINTAINER liusec <75065472@qq.com>

ARG SRCMS_URL=https://github.com/martinzhou2015/SRCMS/archive/master.zip

# 解压srcms.zip 到 /var/www/html/下
RUN set -x \
    && apt-get update \
    && apt-get install -y --force-yes wget \
    && wget -qO /tmp/srcms.zip $SRCMS_URL \
    && unzip -q /tmp/srcms.zip -d /tmp/ \
    && mv /tmp/SRCMS-master/* /var/www/html/ \
    && rm -rf /tmp/SRCMS-master

# 创建数据库srcms ，导入sql
# 修改接收邮件的邮箱
RUN set -x \
    && mysql -e "CREATE DATABASE srcms DEFAULT CHARACTER SET utf8;" -uroot -proot \
    && mysql -e "use srcms;source /var/www/html/DB/srcms.sql;" -uroot -proot
    && rm -f /var/www/html/DB/srcms.sql \
    && sed -i 's/1009465756@qq.com/75065472@qq.com/g' /var/www/html/Application/User/Controller/PostController.class.php

COPY src/start.sh /start.sh
RUN chmod a+x /start.sh

EXPOSE 80

