. format.sh
__ "Cleanup Environment"
___ "Cleanup Output"
cmd rm -rf output
cmd mkdir -p output; cd output
___ "Download Image"
cmd podman save --output chrome-rdp.tar demo/chrome-rdp
___ "Extract Image"
cmd tar xf chrome-rdp.tar
___ "Inspect Image Layers"
cmd ls -rt
cmd jq \'.\' manifest.json
___ "RootFS"
cmd jq \'.rootfs\' b4f59ea05ae49a910caeffa65896bfbc53040fb4d480a01caf16f8590bb41a29.json
___ "Build History"
cmd jq \'.history[].created_by\' b4f59ea05ae49a910caeffa65896bfbc53040fb4d480a01caf16f8590bb41a29.json
