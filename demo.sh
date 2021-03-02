. format.sh
__ "Examine Container Image Layers"
___ "Cleanup Output"
cmd rm -rf output
cmd mkdir -p output; cd output
___ "Download Image"
cmd podman save --output chrome-rdp.tar demo/chrome-rdp
___ "Extract Image"
cmd tar xf chrome-rdp.tar
___ "List Image Layers"
cmd ls -rt
cmd jq \'.\' manifest.json
___ "RootFS"
cmd jq \'.rootfs\' b4f59ea05ae49a910caeffa65896bfbc53040fb4d480a01caf16f8590bb41a29.json
___ "Build History"
cmd jq \'.history[].created_by\' b4f59ea05ae49a910caeffa65896bfbc53040fb4d480a01caf16f8590bb41a29.json
___ "Inspect Image Layer"
cmd tar -tf eb7bf34352ca9ba2fb0218870ac3c47b76d0b1fb7d50543d3ecfa497eca242b0.tar
cmd tar -tf 5cbd821b0b9630e7fca368313ba65143e9ab442da663a0ac30ce17b0a968befc.tar

__ "Run Container"
___ "Create isolated process"
cmd podman run -d --cidfile container-id --rm demo/chrome-rdp tail -f /dev/null
pid=$(ps -efl | grep null | grep -v grep | awk '{ print $4; }')
echo $pid
___ "Host process tree"
cmd pstree -spc $pid
___ "Container process tree"
podman exec -it $(cat container-id) ls -l /proc/1/cmdline
podman exec -it $(cat container-id) cat /proc/1/cmdline
echo
___ "List container"
cmd podman ps
___ "Kill container process"
cmd kill -9 $pid
___ "List container"
cmd podman ps
___ "Container Runtime Components"
cmd podman info
