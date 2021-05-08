# Pacman

After awhile you're pacman cache will begin to accumulate. Install paccache and
automate cleanup.

```
sudo pacman -Syu paccache
sudo systemctl enable paccache.timer
sudo systemctl start paccache.timer
```
