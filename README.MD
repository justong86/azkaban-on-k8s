
### 按需创建namespace
```
kubectl apply -f namespace.yaml
```
### MYSQL数据库

- 修改文件，保存数据库密码
```
eg. echo -n "123456"| base64
kubectl apply -f secret.yaml 
```
- 创建mysql节点

```
kubectl apply -f mysql.yaml
```

> 以后考虑使用initcontainers来初始化，减少手工操作(需要判断是否已经初始化)

- 数据库数据初始化
```
kubectl exec azkaban-mysql -n azkaban -it -- mysql -uroot -pmypassword azkaban < create-all-sql-3.84.4.sql
```

### 创建executor节点
- 修改/创建节点配置文件
```
kubectl apply -f exe-cm.yaml 
```
- 创建exe节点
```
kubectl apply -f exe.yaml 
```
- 到数据库中查看exe节点注册情况
```
kubectl -n azkaban exec pod/azkaban-mysql-6f9b69c478-xlhpt -- mysql -uazkaban -p123456 -e "select * from azkaban.executors"
```
- 在数据库中激活exe节点
```
kubectl -n azkaban exec pod/azkaban-mysql-6f9b69c478-xlhpt -- mysql -uazkaban -p123456 -e "update azkaban.executors set active=1"
```
### 创建web节点
- 修改/创建节点配置文件
```
kubectl apply -f web-cm.yaml 
```
- 创建web节点
```
kubectl apply -f web.yaml 
```

### 登陆访问web ui

```
kubectl -n azkaban get svc
```
<http://CLUSTER-IP:8081>