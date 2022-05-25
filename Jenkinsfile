apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: devsecops
  name: devsecops
spec:
  replicas: 2
  selector:
    matchLabels:
      app: devsecops
  strategy: {}
  template:
    metadata:
      labels:
        app: devsecops
    spec:
      containers:
      - image:  lakshit45/imagesssshcufhiufu 
        name: devsecops-container
        securityContext:
          runAsNonRoot: true
          runAsUser: 100
      
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: devsecops
  name: devsecops-svcc
spec:
  ports:
  - port: 8071
    nodePort: 32290
    protocol: TCP
    targetPort: 8080
  selector:
    app: devsecops
  type: NodePort
