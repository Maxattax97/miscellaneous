On local machine:

```
sudo systemctl enable tailscaled.service
sudo systemctl start tailscaled.service
sudo tailscale set --operator=$USER
tailscale up --login-server https://mesh.maxocull.com
# Note these commands

# After establishing, this is optional
tailscale set --exit-node=citadel.mesh.net
```

On Citadel:

```
docker compose exec -it headscale headscale nodes register --user max --key <redacted>
docker compose exec -it headscale headscale nodes list

# example to rename, useful for mobile:
#docker compose exec -it headscale headscale nodes rename -i 8 pixel7a
```
