#!/bin/bash

USERNAME=${1}

if [ -z "$USERNAME" ]; then
  echo "Usage: $0 <username>"
  exit 1
fi

# Generate private key
openssl genrsa -out ${USERNAME}.key 4096

# Create CSR
openssl req -new -key ${USERNAME}.key -out ${USERNAME}.csr -subj "/CN=${USERNAME}"

# Create Kubernetes CSR manifest
cat <<EOF > ${USERNAME}-csr.yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ${USERNAME}-csr
spec:
  request: $(cat ${USERNAME}.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF

# Apply CSR manifest to cluster
kubectl apply -f ${USERNAME}-csr.yaml

# Approve CSR 
kubectl certificate approve ${USERNAME}-csr

# Retrieve the signed certificate and decode from base64
kubectl get csr ${USERNAME}-csr -o jsonpath='{.status.certificate}' | base64 -d
