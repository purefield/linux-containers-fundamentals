. format.sh
__ "Examine Example Container Image Layers using podman"
___ "Create Image"
cmd podman build image -t demo-ubi
___ "Cleanup Output"
cmd rm -rf output
cmd mkdir -p output; cd output
___ "Save Image to directory"
cmd podman save --output image.tgz localhost/demo-ubi
___ "Extract Image"
cmd tar xf image.tgz
___ "List Image Layers"
cmd ls -rt
cmd jq \'.\' manifest.json
___ "RootFS"
configJson=$(jq -r '.[0].Config' manifest.json)
cmd jq \'.rootfs\' $configJson
___ "Build History for each Layer"
cmd jq \'.history[].created_by\' $configJson
___ "Inspect Image Layers"
___ " * Layer 1 "
layer1=$(jq -r '.[0].Layers[0]' manifest.json)
cmd tar -tf $layer1
___ " * Layer 2 "
layer2=$(jq -r '.[0].Layers[1]' manifest.json)
cmd tar -tf $layer2
___ " * Layer 3 "
layer3=$(jq -r '.[0].Layers[2]' manifest.json)
cmd tar -tf $layer3
cd - 2>&1 > /dev/null


__ "Examine Java Container Image Layers using podman"
___ "Cleanup Output"
cmd rm -rf output
cmd mkdir -p output; cd output
___ "Download Image"
cmd podman pull docker://docker.io/openjdk:8-jdk-alpine
___ "Save Image to directory"
cmd podman save --output image.tgz openjdk:8-jdk-alpine
___ "Extract Image"
cmd tar xf image.tgz
___ "List Image Layers"
cmd ls -rt
cmd jq \'.\' manifest.json
___ "RootFS"
configJson=$(jq -r '.[0].Config' manifest.json)
cmd jq \'.rootfs\' $configJson
___ "Build History for each Layer"
cmd jq \'.history[].created_by\' $configJson
___ "Inspect Image Layers"
___ " * Layer 1 "
layer1=$(jq -r '.[0].Layers[0]' manifest.json)
cmd tar -tf $layer1
___ " * Layer 2 "
layer2=$(jq -r '.[0].Layers[1]' manifest.json)
cmd tar -tf $layer2
___ " * Layer 3 "
layer3=$(jq -r '.[0].Layers[2]' manifest.json)
cmd tar -tf $layer3
cd - 2>&1 > /dev/null


__ "Examine Container Image Layers using skopeo"
___ "Cleanup Output"
cmd rm -rf output
cmd mkdir -p output; cd output
___ "Inspect Image Layer at the source"
cmd skopeo inspect docker://docker.io/sfoxdev/chrome-vnc-rdp:latest
___ "Download Image"
cmd skopeo copy docker://docker.io/sfoxdev/chrome-vnc-rdp:latest dir:.
___ "List Image Layers"
cmd ls -rt
cmd jq \'.\' manifest.json
___ "RootFS"
configJson=$(jq -r '.config.digest | split(":") | .[1]' manifest.json)
cmd jq \'.rootfs\' $configJson
___ "Build History for each Layer"
cmd jq \'.history[].created_by\' $configJson
___ "Inspect Image Layers"
___ " * Layer 1 "
layer1=$(jq -r '.layers[2].digest | split(":") | .[1]' manifest.json)
cmd tar -tf $layer1
___ " * Layer 2 "
layer2=$(jq -r '.layers[3].digest | split(":") | .[1]' manifest.json)
cmd tar -tf $layer2
___ " * Layer 3 "
layer3=$(jq -r '.layers[4].digest | split(":") | .[1]' manifest.json)
cmd tar -tf $layer3
cd - 2>&1 > /dev/null


__ "Run Container"
___ "Create isolated process"
cmd podman run -d --cidfile container-id --rm --name endurance localhost/demo-ubi:latest tail -f /dev/null
pid=$(podman inspect endurance --format '{{.State.Pid}}')
echo $pid
___ "Host process tree"
cmd pstree -spc $pid
___ "Container process tree"
podman exec -it $(cat container-id) ls -l /proc/1/cmdline
podman exec -it endurance cat /proc/1/cmdline
podman exec -it endurance cat /app/hello.txt
echo
___ "List container"
cmd podman ps
___ "Kill container process"
cmd kill -9 $pid
___ "List container"
cmd podman ps
rm container-id -f 2>&1 > /dev/null
