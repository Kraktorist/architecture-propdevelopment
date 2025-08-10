## Task5

[Манифесты политик](./deploy/netpols/)

```bash
kubectl apply -R -f deploy/
```

### Тесты

Возвращают http код запроса. В случае таймаута возвращают 000

```bash
pods=(
  "admin-back-end-api-app"
  "admin-front-end-app"
  "back-end-api-app"
  "front-end-app"
)

script_inside_pod='
#!/bin/bash

urls=(
  "http://admin-back-end-api-app"
  "http://admin-front-end-app"
  "http://back-end-api-app"
  "http://front-end-app"
)

for url in "${urls[@]}"; do
  status_code=$(curl -o /dev/null -m 2 -s -w "%{http_code}" "$url")
  echo "$url $status_code"
done
'

for pod in "${pods[@]}"; do
  echo "Running script inside pod: $pod"
  echo "$script_inside_pod" | kubectl  exec -i "$pod" -- bash
done
```

Вывод:

```console
Running script inside pod: admin-back-end-api-app
http://admin-back-end-api-app 200
http://admin-front-end-app 200
http://back-end-api-app 000
http://front-end-app 000
Running script inside pod: admin-front-end-app
http://admin-back-end-api-app 200
http://admin-front-end-app 200
http://back-end-api-app 000
http://front-end-app 000
Running script inside pod: back-end-api-app
http://admin-back-end-api-app 000
http://admin-front-end-app 000
http://back-end-api-app 200
http://front-end-app 200
Running script inside pod: front-end-app
http://admin-back-end-api-app 000
http://admin-front-end-app 000
http://back-end-api-app 200
http://front-end-app 200
```