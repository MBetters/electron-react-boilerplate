#!/bin/bash

# if on Windows:
# TODO: Doesn't work
# pip install pyenv-win --target %USERPROFILE%/.pyenv
# if on Ubuntu:
sudo apt-get install -y build-essential cmake git libgit2-dev clang libncurses5-dev libncursesw5-dev zlib1g-dev pkg-config libssl-dev llvm
curl https://pyenv.run | bash
export PATH="/home/vagrant/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Set this project to use a particular version of Python
PY_VER=3.7.3
pyenv install $PY_VER
pyenv local $PY_VER

# Install pipenv
pip install --upgrade pip
pip install -U pipenv

# Setup the pipenv
# pipenv --rm
# rm -f Pipfile.lock
# rm -rf ~/.cache/pip
# rm -rf ~/.cache/pipenv
# Sometimes you need these too...
# pipenv clean
# pipenv lock --clear
# pipenv sync
pipenv install --skip-lock --python $PY_VER

# Install an iPython Kernel
pipenv run python -m ipykernel install --user --name=${PWD##*/}

# Set up the nodeenv within the pipenv
# TODO: On Windows, these commands require an Admin console. Fix that.
pipenv run nodeenv -p # Installs NodeJS and NPM into the project's pipenv
pipenv run npm install -g npm # Update the NPM in the project's pipenv
pipenv run npm install -g yarn # Installs Yarn into the project's pipenv

# NPM configs
pipenv run npm config set scripts-prepend-node-path auto # "auto" vs "true"?

# Some random extra installs for this project
pipenv run npm install -g cross-env
pipenv run npm install -g electron

# Download the project's yarn dependencies
rm -rf node_modules
pipenv run yarn cache clean
pipenv run yarn
pipenv run yarn electron-rebuild

# Run the app
# TODO: This only works in a GUI X11 setting.
#       Try to get it to work in VS Code's Integrated Terminal.
# pipenv run DEBUG_PROD=true yarn build && DEBUG_PROD=true yarn start
# pipenv run yarn dev

# Install these JupyterLab extensions
pipenv run jupyter labextension install @jupyter-widgets/jupyterlab-manager

# Show the user where the pipenv is
echo "Your pipenv is fully set up. It's at..."
pipenv --venv
