FROM ssiegel95/hadoop-docker:2.7.1
MAINTAINER SequenceIQ

#support for Hadoop 2.7.0
RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s spark-2.1.0-bin-hadoop2.7 spark
ENV SPARK_HOME /usr/local/spark
RUN mkdir $SPARK_HOME/yarn-remote-client
ADD yarn-remote-client $SPARK_HOME/yarn-remote-client

RUN ls /usr/local/*
RUN $BOOTSTRAP && $HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave

# no lib directory in spark 2.1.0
#&& $HADOOP_PREFIX/bin/hdfs dfs -put $SPARK_HOME-2.1.0-bin-hadoop2.7/lib /spark

ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_PREFIX/bin
# update boot script
COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

#install R
RUN rpm -ivh http://mirror.math.princeton.edu/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Non-existent link
#http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

RUN yum -y install R

ENTRYPOINT ["/etc/bootstrap.sh"]
