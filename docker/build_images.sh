docker build --platform linux/amd64 . -t rucadi/webos-base-image:x86_64-linux
docker build --platform linux/arm64 . -t rucadi/webos-base-image:aarch64-linux

docker push rucadi/webos-base-image:x86_64-linux
docker push rucadi/webos-base-image:aarch64-linux