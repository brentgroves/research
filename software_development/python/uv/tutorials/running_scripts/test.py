#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "flask",
# ]
# ///
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello from Flask!\n'

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)