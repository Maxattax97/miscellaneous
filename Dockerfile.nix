# checkov:skip=CKV_DOCKER_7: We intentionally use latest to stay up-to-date
# checkov:skip=CKV_DOCKER_3: The nixos/nix image only has root
# hadolint ignore=DL3007
FROM nixos/nix:latest
ARG REPO_URL
ARG COMMIT_SHA

ENV NIX_CONFIG="experimental-features = nix-command flakes"

RUN nix profile add nixpkgs#bashInteractive nixpkgs#gnugrep && \
	nix-collect-garbage -d

RUN mkdir -p /root/src
WORKDIR /root/src
RUN git clone "$REPO_URL" miscellaneous

WORKDIR /root/src/miscellaneous
RUN git checkout --detach "$COMMIT_SHA" && \
	/bin/sh -c "yes n | AUTOMATED=1 /root/src/miscellaneous/install.sh && \
	nix-collect-garbage -d"

WORKDIR /root
