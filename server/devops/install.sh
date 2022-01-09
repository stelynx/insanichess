sudo apt install unzip
wget https://storage.googleapis.com/dart-archive/channels/stable/release/2.15.1/sdk/dartsdk-linux-arm64-release.zip
unzip dartsdk-linux-arm64-release.zip
echo 'export PATH="$PATH:~/dart-sdk/bin"'

bash devops/nginx/setup.sh
bash devops/database/setup.sh
