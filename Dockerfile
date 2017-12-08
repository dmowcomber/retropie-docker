# pin to Raspbian Jessie until RetroPie supports Raspbian Stretch
# https://github.com/RetroPie/RetroPie-Setup/issues/2091
FROM resin/rpi-raspbian:jessie
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends ca-certificates git lsb-release sudo \
    && useradd -d /home/retropie -G sudo -m pi \
    && echo "pi ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/pi

RUN sudo chown -R pi:pi /root
RUN usermod -aG adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input pi
# emulationstation does not like to run as root
USER pi

WORKDIR /home/retropie
RUN git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git \
    && cd RetroPie-Setup \
    && sudo chmod +x retropie_setup.sh \
    && sudo __platform=rpi1 ./retropie_packages.sh setup basic_install

USER root
RUN sudo rm -rf /var/lib/apt/lists/* && chown -R pi.pi /home/retropie
USER pi
ENTRYPOINT "/usr/bin/emulationstation"
CMD "#auto"
