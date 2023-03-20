# 1. 启动命令

```bash
docker run --name gnicks -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -v /data/mysql:/var/lib/mysql mysql:latest
```

- 命令详解：
    - -name 实例名
    - -d 后台运行
    - -p 指定映射端口
    - -e MYSQL_ROOT_PASSWORD=root 设置账户密码
    - -v /data/mysql:/var/lib/mysql  加卷挂载

# 2. 远程访问

## 2.1 修改远程访问的root账户密码

```sql
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root';
```

## 2.2 授权远程访问的root账户

```sql
GRANT ALL ON *.* TO 'root'@'%';
```

## 2.3 刷新权限

```sql
flush privileges;
```

# 3. 执行sql脚本

```sql
source /path/you/put/script.sql
```