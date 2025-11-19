#!/usr/bin/env sh
set -e

# Create virtualenv and install pinned deps
python -m venv .venv
. .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel

# Install packages one by one so we can continue if a wheel is missing for this platform
while IFS= read -r pkg || [ -n "$pkg" ]; do
  if [ -z "$pkg" ] || [ "${pkg#"#}" != "$pkg" ]; then
    # skip blank or comment lines
    continue
  fi
  echo "Installing: $pkg"
  pip install "$pkg" || { echo "Warning: failed to install $pkg; continuing"; }
done < requirements.txt

echo "Setup complete. To run tests: ./run_tests.sh"