# Use the latest OpenJDK 21 base image
FROM openjdk:21-jdk-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Install Maven
RUN apt-get update && \
    apt-get install -y curl unzip && \
    curl -fsSL https://downloads.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz -o /tmp/maven.tar.gz && \
    tar -xzvf /tmp/maven.tar.gz -C /opt && \
    rm /tmp/maven.tar.gz && \
    ln -s /opt/apache-maven-3.9.9 /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/bin/mvn

# Set Maven environment variables
ENV MAVEN_HOME=/opt/maven
ENV PATH=$MAVEN_HOME/bin:$PATH

# Expose port 8080 (if running a web application)
EXPOSE 8080

# Set the default command to run when the container starts
CMD ["mvn", "--version"]
