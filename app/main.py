from fastapi import FastAPI
import os

app = FastAPI(title="hello-app")

APP_NAME = os.getenv("APP_NAME", "hello-app")

@app.get("/")
def read_root():
    return {"app": APP_NAME, "message": "Hello from Kubernetes via ArgoCD! \n Joke: Why did the developer go broke? Because he used up all his cache!"}

@app.get("/healthz")
def healthz():
    return {"status": "ok"}
