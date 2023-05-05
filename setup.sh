#!/bin/bash
rm -rf .venv
poetry run python -m venv .venv

# パッケージのインストール
source .venv/bin/activate
poetry run pip install --upgrade pip
poetry install
poetry run pre-commit install --install-hooks
