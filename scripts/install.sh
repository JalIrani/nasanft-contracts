#!/bin/sh
#Install Dependencies
sudo apt-get update && sudo apt-get upgrade && sudo apt-get install -y pkg-config build-essential libudev-dev libssl-dev

#Install Rust and Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

#Install Solana CLI
sh -c "$(curl -sSfL https://release.solana.com/v1.15.0/install)"
. ~/.cargo/env
. $(dirname "$0")/setEnv.sh
solana --version

#Install Anchor
cargo install --git https://github.com/coral-xyz/anchor avm --locked --force
avm install latest
avm use latest
anchor --version

#Install NodeJs and yarn
curl -fsSL https://deb.nodesource.com/setup_19.x | sudo -E bash - && sudo apt-get install -y nodejs
sudo corepack enable
corepack prepare yarn@stable --activate
yarn --version