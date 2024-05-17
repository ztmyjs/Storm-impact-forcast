# Pulling ubuntu base image
FROM ubuntu:22.10
RUN apt-get update
SHELL ["/bin/bash", "-c"]

RUN apt-get -y install git
RUN apt-get install -y --no-install-recommends \
	clang \
	cmake \
	libgtk-3-dev \
	ninja-build \
	pkg-config \
	unzip \
	curl 

# Installing flutter and setting environment variables
RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
ENV PATH="$PATH:/usr/local/flutter/bin"
RUN flutter doctor

# Creating new project
WORKDIR $HOME/stormimpact_dashboard
ADD . .
RUN flutter pub get
ENV PORT=8080
EXPOSE 8080
CMD ["flutter", "run", "-d", "web-server", "--web-port", "8080", "--web-hostname", "0.0.0.0"]


