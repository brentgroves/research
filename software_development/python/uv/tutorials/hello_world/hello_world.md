# First let’s start a web server on vm2 using python3

```bash
mkdir -p ~/src
cd ~/src/
uv init my-flask-app
uv add flask
touch app.py
vi app.py
```

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
  return "Hello, World from Flask and uv!"

if __name__ == "__main__":
  app.run(host="0.0.0.0")
```

run app

```bash
uv run app.py
```
