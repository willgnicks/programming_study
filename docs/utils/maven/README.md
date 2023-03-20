- 配置
    
    ```xml
    <!-- 镜像 -->
    <mirror>
      <id>aliyun-central</id>
      <mirrorOf>central</mirrorOf>
      <name>aliyun mvn</name>
      <url>https://maven.aliyun.com/repository/public/</url>
    </mirror>
    
    <mirror>
      <id>huaweicloud</id>
      <mirrorOf>central</mirrorOf>
      <name>huawei mvn</name>
      <url>https://repo.huaweicloud.com/repository/maven/</url>
    </mirror>
    
    <!-- 本地仓库 -->
    <localRepository>/Users/gnicks/Documents/study/maven/repository</localRepository>
    ```