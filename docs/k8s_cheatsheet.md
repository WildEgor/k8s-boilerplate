Apply resource by file path
```bash
kubectl apply -f [file path]
```

Show all resources from default namespace
```bash
kubectl get all
```

Create new namespace
```bash
kubectl create namespace [namespace]
```
Use namespace instead of default
```bash
kubectl config set-context --current --namespace=[namespace]
```

Delete namespace and all resources
```bash
kubectl delete namespace [namespace]
```

Install app
```bash
helm install [app-name] --dry-run --debug
```
    
Show helms
```bash
helm list --namespace [namespace]
```
 
Uninstall resource
```bash
helm uninstall [release]
```
    
Show resources
```bash
kubectl get all -n [namespace]
```
    
Get logs 
```bash
kubectl logs -n qabat -f [resourse-name]
```
    
Get pods
```bash
kubectl get pods -n [namespace]
```
    
Get services
```bash
kubectl get services -n [namespace]
```
    
Get pod info
```bash
kubectl describe pods -n [namespace] [pod-name]
```
    
Show history
```bash
helm history -n [namespace]
```
    
Port forward
```bash
kubectl port-forward [pod-name] [dest port]:[source port]
```

Get k8s contexts
```bash
kubectl config get-contexts
```

Switch k8s context
```bash
kubectl config use-context minikube
```
