### For EKS environment:

1) Create AWS Cluster:
```bash
  eksctl create cluster -f ./cluster/skeleton.yaml --auto-kubeconfig
```

and then use AWS EKS then set flag for eksctl or helm:
```bash
  --kubeconfig ./clusters/skeleton
```

1) Scale if needed:
```bash
  eksctl scale nodegroup --cluster=apps --nodes=4 --name=apps-nodes
```

### For local environment:

1) Start minikube:
```bash
  minikube start --cpus "4" --disk-size "40000mb"
```
1) Deploy ArgoCD and apply current repository:
```bash
  kubectl create namespace argocd
```
```bash
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
```bash
  kubectl port-forward -n argocd svc/argocd-server 8080:443
```
```bash
  kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}"
```
For win users
```bash
  base64 -d -s <previous_result>
```
```bash
  kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}"
```
```bash
  argocd login localhost:8080 --username admin --password [password]
```
Optional:
```bash
  argocd account update-password --current-password <previous_pass> --new-password <new_pass>
```
```bash
  argocd repo add https://github.com/WildEgor/argocd-boilerplate --username <github_username> --password <github_token>
```

1) Install updater:
```bash
  helm repo add argo https://argoproj.github.io/argo-helm
```
```bash
  helm upgrade argocd-image-updater argo/argocd-image-updater -n argocd --values .\argo\values\updater.yaml --install --debug
```
1) Apply apps:
```bash
  argocd app create apps --dest-namespace argocd --dest-server https://kubernetes.default.svc --repo https://github.com/WildEgor/argocd-boilerplate --path apps --revision develop
```
