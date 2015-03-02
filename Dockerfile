FROM resin/rpi-raspbian:wheezy
RUN apt-get update -qq && apt-get install -qy python python-pip python-dev git && apt-get clean
RUN useradd -d /home/user -m -s /bin/bash user
WORKDIR /code/

ADD requirements.txt /code/
RUN pip install -r requirements.txt

ADD requirements-dev.txt /code/
RUN pip install -r requirements-dev.txt

RUN apt-get install -qy wget && \
    wget -q https://pypi.python.org/packages/source/P/PyInstaller/PyInstaller-2.1.tar.gz && \
    tar xzf PyInstaller-2.1.tar.gz && \
    cd PyInstaller-2.1/bootloader && \
    python ./waf configure --no-lsb build install && \
    ln -s /code/PyInstaller-2.1/PyInstaller/bootloader/Linux-32bit-arm /usr/local/lib/python2.7/dist-packages/PyInstaller/bootloader/Linux-32bit-arm

ADD . /code/
RUN python setup.py install

RUN chown -R user /code/

ENTRYPOINT ["/usr/local/bin/docker-compose"]
