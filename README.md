# Multipass demo
# multipass-template

## Prerequisites
### Ubuntu 22.04
### Install canonical multipass from snap

`
sudo snap install multipass
`

## Install VM

### Clone repository:
`
git clone https://github.com/manzolo/multipass-gns3 multipass-gns3
`

`
cd multipass-gns3
`
### Set parameters:
```
cp env.dist env
```
### Edit env parameters
```
nano env
```
![immagine](https://user-images.githubusercontent.com/7722346/216776538-df1c2820-a0f5-4001-bca1-42e8ffe9cebd.png)

### Install
```
./setup.sh
```
### Uninstall
```
./uninstall.sh
```

## Demo
[![Watch demo](http://img.youtube.com/vi/dN8rc0C8aB0/0.jpg)](http://www.youtube.com/watch?v=dN8rc0C8aB0 "Demo video")
