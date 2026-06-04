# Build the go-librespot armv6 binary and the UI dist zip,
# then drop both into this firmware tree where build.sh expects them.
# Also bump the patch build-number 
prepare:
    printf '%s\n' "$(( $(cat .build-number 2> /dev/null || echo 0) + 1 ))" > .build-number
    @echo ">> build v0.4.$(cat .build-number)   (edit VERSION_MAJOR/VERSION_MINOR in build.sh to change the v0.4 part)"
    cd ../thing-daemon && ./crosscompile.sh armv6
    cp ../thing-daemon/go-librespot-armv6 ./go-librespot-armv6
    cp ../thing-daemon/config.yml ./go-librespot-config.yml
    cd ../thing-ui && (command -v bun >/dev/null && bun install || npm install)
    cd ../thing-ui && (command -v bun >/dev/null && bun run build || npm run build)
    rm -f ./ui.zip
    cd ../thing-ui/dist && zip -r9 {{justfile_directory()}}/ui.zip .

run: prepare
    sudo ./build.sh

lint:
    pre-commit run --all-files

docker-qemu:
    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

docker-build: prepare
    docker build -t firmware-builder .

docker-run: docker-build
    docker run --rm --privileged -v ./output:/work/output firmware-builder:latest
