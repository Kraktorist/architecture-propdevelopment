## Task4

1. Поднимите пустой minikube

1. Определите все роли и их полномочия при работе с Kubernetes
   
    Ссылки на роли даны в таблице.  

    | **Роль**                   | **Права роли**                 | **Группы пользователей**                   |
    | -------------------------- | ------------------------------ | ------------------------------------------ |
    | propDevelopment-view       | [cr-propDevelopment-view.yml](./deploy/manifests/cr-propDevelopment-view.yml)       | \- разработчики<br>\- владельцы приложений |
    | propDevelopment-privileged |[cr-propDevelopment-privileged.yml](./deploy/manifests/cr-propDevelopment-privileged.yml)  | \- инженер ИБ                              |
    | propDevelopment-admin      | [cr-propDevelopment-admin.yml](./deploy/manifests/cr-propDevelopment-admin.yml)       | \- инженер инфраструктуры<br>\- devops     |

1. Подготовьте скрипты для создания пользователей.

    [create-k8s-user.sh](./deploy/create-k8s-user.sh)

    ```bash
    ./create-k8s-user.sh anton
    ./create-k8s-user.sh boris
    ./create-k8s-user.sh vadim
    ```

1. Подготовьте скрипты, чтобы создать роли. Они должны соответствовать ролям из вашей таблицы.

    ```bash
    # скрипт не требуется, если все роли описать в виде манифестов kubernetes
    kubectl apply -f ./deploy-manifests/cr-*.yml
    ```

1. Подготовьте скрипты, чтобы связать пользователей с ролями.


    Выдача пользователю `anton` прав `view` на namespace `app01`
    ```bash
    kubectl apply -f ./deploy/manifests/rb-propDevelopment-view-anton.yml
    ```

    Выдача пользователю `boris` прав на просмотр секретов во всем кластере
    ```bash
    kubectl apply -f ./deploy/manifests/crb-propDevelopment-privileged-boris.yml
    ```

    Выдача пользователю `vadim` прав на администрирование кластера
    ```bash
    kubectl apply -f ./deploy/manifests/crb-propDevelopment-admin-vadim.yml
    ```