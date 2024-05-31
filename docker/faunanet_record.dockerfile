FROM python:3.11-slim

# install portaudio 
RUN apt-get update \ 
&& apt-get install --no-install-recommends -y libportaudio2 libportaudiocpp0 \ 
portaudio19-dev libasound-dev libsndfile1-dev build-essential alsa-utils \ 
&& apt-get autoremove -y \ 
&& apt-get clean \ 
&& rm -rf /var/lib/apt/lists/*

WORKDIR /home/faunanet

# install package 
RUN pip install faunanet-record && faunanet_record install

# locally set up faunanet-record
CMD ["/bin/bash", "-c", "echo Welcome to faunanet-record!"]