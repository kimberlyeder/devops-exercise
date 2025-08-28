# Hello FastAPI — Docker — Helm — ArgoCD (Minimal Starter)

- A tiny FastAPI app with `/` and `/healthz`
- Dockerfile to build an image
- Helm chart to deploy it
- ArgoCD `Application` manifest to sync the Helm chart from your repo

> Replace the placeholders `<your-docker-user>`, `<youruser>`, and `<yourrepo>` with your values.

---

## 1) Run locally (optional)

```bash
cd app
python -m venv .venv && source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload
# visit http://127.0.0.1:8000
```

## 2) Build & push Docker image

```bash
# From the repo root
IMAGE=<your-docker-user>/hello-app:v1
docker build -t $IMAGE ./app
docker push $IMAGE
```

## 3) Create a Git repo and push

```bash
# From the repo root (where this README is)
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/<youruser>/<yourrepo>.git
git push -u origin main
```

## 4) (Option A) Deploy with Helm directly (quick test)

```bash
# Set your image in the chart values on-the-fly
helm upgrade --install hello-app ./chart/hello-app \  --namespace hello-app --create-namespace \  --set image.repository=<your-docker-user>/hello-app \  --set image.tag=v1
```

- Check: `kubectl get pods -n hello-app`
- Port-forward (if no ingress): `kubectl port-forward -n hello-app svc/hello-app 8000:80` then open http://localhost:8000

## 5) (Option B) Deploy via ArgoCD (what you need for the assignment)

1. Make sure ArgoCD is installed and you can access its UI.
2. Apply the `Application` resource (update placeholders first):

```bash
kubectl apply -f argocd-application.yaml
```

This tells ArgoCD to watch your GitHub repo and sync the Helm chart in `chart/hello-app` into the cluster.

- In the ArgoCD UI you should see an app named **hello-app**.
- Click **SYNC** (or rely on auto-sync), wait until **Healthy** + **Synced**, then take a screenshot for submission.

## 6) Update the app

- Change the message in `app/main.py`.
- Build & push a new image tag, e.g. `v2`.
- Update the image tag in:
  - `chart/hello-app/values.yaml` **or**
  - `argocd-application.yaml` under `spec.source.helm.values`
- Commit & push. ArgoCD will sync the change automatically.

## Files overview

```
app/
  Dockerfile
  main.py
  requirements.txt
chart/
  hello-app/
    Chart.yaml
    values.yaml
    templates/
      deployment.yaml
      service.yaml
      ingress.yaml
argocd-application.yaml
```

Good luck! ✨
