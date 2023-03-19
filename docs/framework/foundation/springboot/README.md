```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- 
1.把spring-boot-starter的spring-boot-starter-logging 排除掉，
2.引入spring-boot-starter-log4j2、 lombok(@Log4j2)，
3.把默认日志文件log4j.properties改为 log4j.properties.back
4.在类上加注解@Log4j2

参考
官网翻译：https://blog.csdn.net/u013066244/article/details/72461105

https://www.callicoder.com/spring-boot-log4j-2-example/ 
https://www.cnblogs.com/keeya/p/10101547.html 
https://blog.csdn.net/lwwl12/article/details/83109815

log4j是通过一个.properties的文件作为主配置文件的，
而log4j2采用的是log4j2.xml，log4j2.json 或者 log4j2.jsn
-->

<!--
Configuration后面的status，这个用于设置log4j2自身内部的信息输出，可以不设置，
当设置成trace时，你会看到log4j2内部各种详细输出。
monitorInterval：Log4j能够自动检测修改配置 文件和重新配置本身，设置间隔秒数-->
<Configuration status="WARN" monitorInterval="30">
	<!--日志级别以及优先级排序: OFF > FATAL > ERROR > WARN > INFO > DEBUG > TRACE > ALL -->

  	<!--变量配置-->
    <Properties>
    	<!-- 格式化输出：
    	%date 或 %d ：日期，日期后面需要加格式化类型，如{yyyy-MM-dd HH:mm:ss.SSS}
    	%thread ：线程名，
    	%-5level 或 %5p：级别从左显示5个字符宽度
    	%msg 或 %m：日志消息，
    	%n：换行符，
    	%logger{36} 表示 Logger 名字最长36个字符，
    	%L 行号
    	${hostName} 计算机的名字 -->
        <!-- <Property name="LOG_PATTERN">
            %d{yyyy-MM-dd HH:mm:ss.SSS} %5p ${hostName} - [%15.15t] %-40.40c{1.} : %m%n%ex
        </Property> -->
        
        <property name="LOG_PATTERN" value="%date{yyyy-MM-dd HH:mm:ss} ${hostName} [%thread] %-5level %logger{36} %L - %msg%n" />
        
        <!-- FILE_PATH定义日志存储的路径，FILE_NAME 定义压缩日志名称前缀
	    	SpringBoot 是log4j2日志，如果在eclipse，对应的 ${catalina.home:-.}  是 "项目根目录"  ，
	    	如果部署到windows 的 tomcat，则是tomcat 的 bin目录 如  D:\apache-tomcat-8.0.53\bin，所以路径需要 ${catalina.home:-.}/../logs ，
	    	
	    	但部署到linux 的 tomcat，${catalina.home:-.}路径却是"系统根目录/" ，所以需要改为 ${sys:catalina.home}
	    	ssm 项目是logback日志， 部署到tomcat， ${catalina.home:-.}则是tomcat的 目录，如 D:\apache-tomcat-8.0.53，
	    	FILE_PATH 的 value 可以写绝对路径，如 value="H:\logs\" -->
	    <!-- dev环境，
	    window系统：	${catalina.home:-.}是 tomcat 的bin目录，如D:\apache-tomcat-8.0.53\bin，tomcat的logs目录，加.. 则在上一级目录，
	    本地IDE环境：${catalina.home:-.}在项目根目录，加了..则在上一级目录，
	    linux系统：	${catalina.home:-.}在系统根目录，
	    			${sys:catalina.home}是tomcat 目录 -->
	    <property name="FILE_NAME" value="project-name-log4j2" />
	    <property name="FILE_PATH" value="${catalina.home:-.}/../logs/${FILE_NAME}-dev" />
	    
	    <!-- beta环境-linux系统的tomcat，如果在IDE这么配置会报错，但不影响日志打印 -->
	    <!-- <property name="FILE_PATH" value="${sys:catalina.home}/logs/${FILE_NAME}-beta" /> -->
	    
	    <!-- prod环境-linux系统 -->
	    <!-- <property name="FILE_PATH" value="${sys:catalina.home}/logs/${FILE_NAME}-prod" /> -->
	    
    </Properties>
    
    <Appenders>
        <Console name="AppenderConsole" target="SYSTEM_OUT" follow="true">
        	<!--输出日志的格式-->
            <PatternLayout pattern="${LOG_PATTERN}"/>
            <!--控制台只输出level及其以上级别的信息（onMatch），其他的直接拒绝（onMismatch）-->
      		<ThresholdFilter level="debug" onMatch="ACCEPT" onMismatch="DENY"/>
        </Console>
        
        <!--文件会打印出所有信息，这个log每次运行程序会自动清空，由append属性决定，适合临时测试用-->
	    <!-- <File name="Filelog" fileName="${FILE_PATH}/${FILE_NAME}-test.log" append="false">
	      <PatternLayout pattern="${LOG_PATTERN}"/>
	    </File> -->
	    
	    <!-- 这个会打印出所有的info及以下级别的信息，每次大小超过size，
	    则这size大小的日志会自动存入按年份-月份建立的文件夹下面并进行压缩，作为存档,
	    filePattern 压缩文件名称，关键点在于 filePattern后的日期格式，
	    以及TimeBasedTriggeringPolicy的interval，filePattern日期格式精确到哪一位，
	    TimeBasedTriggeringPolicy 的 interval 也精确到哪一个单位-->
	    <RollingFile name="RollingFileInfo" fileName="${FILE_PATH}/${FILE_NAME}-info.log" 
	    			filePattern="${FILE_PATH}/${FILE_NAME}-info-%d{yyyy-MM-dd}.log.gz">
	      
	      <!--控制台只输出level及以上级别的信息（onMatch），其他的直接拒绝（onMismatch）-->
	      <ThresholdFilter level="debug" onMatch="ACCEPT" onMismatch="DENY"/>
	      <PatternLayout pattern="${LOG_PATTERN}"/>
	      <Policies>
	        <!--interval属性用来指定多久滚动一次，默认是1 hour，
	        	如果filePattern 是%d{yyyy-MM-dd}，则 interval="1"表示1天，
	        	如果是%d{yyyy-MM-dd-HH-mm}，则 interval="1"表示1分钟，
	        	如果设置 size="10MB" ，则一个interval单位内，日志超过10m，则也会滚动压缩-->
	        <TimeBasedTriggeringPolicy interval="1" modulate="true"/>
	        <!-- <SizeBasedTriggeringPolicy size="1KB"/> -->
	      </Policies>
	      <!-- DefaultRolloverStrategy属性如不设置，则默认为最多同一文件夹下7个文件开始覆盖，
	      	这个7指的是上面i的最大值，超过了就会覆盖之前的
	      	
	      	log4j-2.5开始引入了删除操作，使得用户更有效的的控制在rollover时间内删除文件，而不是使用DefaultRolloverStrategy max属性进行删除。
	      	删除操作允许用户配置一个或多个条件，选择要删除相对于基本目录的文件。
			注意：删除任何文件这是允许的操作。不仅仅是rollover时的文件。所以使用这个操作时，一定要小心。
			使用testMode参数可以测试您的配置，而不会意外删除错误的文件。
	      	
	      	basePath：必参。从哪里扫描要删除的文件的基本路径。
	      	maxDepth：要访问的目录的最大级别数。值为0表示仅访问起始文件（基本路径本身），除非被安全管理者拒绝。
	      			Integer.MAX_VALUE的值表示应该访问所有级别。默认为1，意思是指定基本目录中的文件。
	      	followLinks：
	      	testMode：默认false。如果为true，文件将不会被删除，而是将信息打印到info级别的status logger,
	      			可以利用这个来测试，配置是否和我们预期的一样
	      	：
	      	glob：如果regex没有指定的话，则必须。使用类似于正则表达式但是又具有更简单的有限模式语言来匹配相对路径（相对于基本路径）
	      	regex：如果glob没有指定的话，则必须。使用由Pattern类定义的正则表达式来匹配相对路径（相对于基本路径）
	      	age：必须。指定持续时间duration。该条件接受比指定持续时间更早或更旧的文件。即保留从当前时间至age时间之前这段时间范围内的数据,
	      		
	      		如filePattern="info-%d{yyyy-MM-dd-HH-mm-ss}.log.gz，interval="5"，IfLastModified age="1m"
	      		意思是每5秒新建一个历史文件，历史文件总保留时长1分钟，则总共有60秒/5=12个文件。
	      		
	      		如filePattern="info-%d{yyyy-MM-dd-HH-mm}.log.gz，interval="2"，IfLastModified age="10m"
	      		意思是每2分钟新建一个历史文件，历史文件总保留时长10分钟，则总共有10分钟/2=5个文件。
	      		
	      		这里我们设置filePattern="info-%d{yyyy-MM-dd}.log.gz，interval="1"，IfLastModified age="30d"
	      		即每天滚动压缩一次，总保留30天内压缩文件
	      	-->
	      <DefaultRolloverStrategy>
		      <Delete basePath="${FILE_PATH}">
	               <IfFileName glob="*.gz" />
	               <IfLastModified age="30d" />
	       	  </Delete>
	      </DefaultRolloverStrategy>
	      
	    </RollingFile>
	
	    <!-- 这个会打印出所有的warn及以下级别的信息，每次大小超过size，则这size大小的日志会自动存入按年份-月份建立的文件夹下面并进行压缩，作为存档-->
	    <RollingFile name="RollingFileWarn" fileName="${FILE_PATH}/${FILE_NAME}-warn.log" filePattern="${FILE_PATH}/${FILE_NAME}-warn-%d{yyyy-MM-dd}_%i.log.gz">
	      <!--控制台只输出level及以上级别的信息（onMatch），其他的直接拒绝（onMismatch）-->
	      <ThresholdFilter level="warn" onMatch="ACCEPT" onMismatch="DENY"/>
	      <PatternLayout pattern="${LOG_PATTERN}"/>
	      <Policies>
	        <!--interval属性用来指定多久滚动一次，默认是1 hour-->
	        <TimeBasedTriggeringPolicy interval="1"/>
	        <SizeBasedTriggeringPolicy size="10MB"/>
	      </Policies>
	      <!-- DefaultRolloverStrategy属性如不设置，则默认为最多同一文件夹下7个文件开始覆盖-->
	      <DefaultRolloverStrategy max="15"/>
	    </RollingFile>
	
	    <!-- 这个会打印出所有的error及以下级别的信息，每次大小超过size，则这size大小的日志会自动存入按年份-月份建立的文件夹下面并进行压缩，作为存档-->
	    <RollingFile name="RollingFileError" fileName="${FILE_PATH}/${FILE_NAME}-error.log" filePattern="${FILE_PATH}/${FILE_NAME}-error-%d{yyyy-MM-dd}_%i.log.gz">
	      <!--控制台只输出level及以上级别的信息（onMatch），其他的直接拒绝（onMismatch）-->
	      <ThresholdFilter level="error" onMatch="ACCEPT" onMismatch="DENY"/>
	      <PatternLayout pattern="${LOG_PATTERN}"/>
	      <Policies>
	        <!--interval属性用来指定多久滚动一次，默认是1 hour-->
	        <TimeBasedTriggeringPolicy interval="1"/>
	        <SizeBasedTriggeringPolicy size="10MB"/>
	      </Policies>
	      <!-- DefaultRolloverStrategy属性如不设置，则默认为最多同一文件夹下7个文件开始覆盖-->
	      <DefaultRolloverStrategy max="15"/>
	    </RollingFile>
	    
	    <!-- 
		邮件配置一、
		配置log4j2发送错误日志邮件，需导入activation、mail两个jar包，
	    https://www.cnblogs.com/tmxk-qfzz/p/12968291.html 
	    https://blog.csdn.net/raveee/article/details/81584153
	    https://blog.csdn.net/maskkiss/article/details/82013137 配置详解，
	    注意阿里服务器不允许开发25端口，所以改为smtps协议和465端口-->  
	    
	    <!-- 因为阿里云禁用25端口，所以测试、正式服务器都需要使用smtps协议和512端口，
	    replyTo 回信地址，from发件人邮箱，smtpUsername用户名，可以是发件人邮箱或发件人邮箱的前缀如hfq-->
	    <SMTP name="Mail" subject="邮件标题" to="a@qq.com" from="b@163.com" replyTo="b@163.com"
	          smtpProtocol="smtps" smtpHost="smtp.163.com" smtpPort="465" bufferSize="512" smtpDebug="false"
	          smtpPassword="LOQLTVTFABC密码" smtpUsername="b" smtpSsl="true" smtpStarttls="true">
	    </SMTP>
	    
	    <!-- 
		邮件配置二、
		异步发送日志，引入上面配置的Mail，但是却无法打印行号，同步日志能打印行号-->
	    <Async name="AsyncMail">
			<appender-ref ref="Mail"/>
		</Async>
    </Appenders>
    
    <!--Logger节点用来单独指定日志的形式，比如要为指定包下的class指定不同的日志级别等。-->
  	<!--然后定义loggers，只有定义了logger并引入的appender，appender才会生效-->
    <!--过滤掉spring和mybatis的一些无用的DEBUG信息，切记不能写com.imooc且level=debug，否则日志只会打印到控制台，不会写入到日志文件-->
    <Loggers>
        <Logger name="com.imooc.mapper" level="debug" additivity="false">
            <AppenderRef ref="AppenderConsole" />
            <AppenderRef ref="RollingFileInfo" />
        </Logger>
        
		<!--监控系统信息-->
	    <!--若是additivity设为false，则 子Logger 只会在自己的appender里输出，而不会在 父Logger 的appender里输出。-->
	    <Logger name="org.springframework" level="info" additivity="false">
	      <AppenderRef ref="AppenderConsole"/>
	    </Logger>
		
        <Root level="info">
            <AppenderRef ref="AppenderConsole"/>
            <appender-ref ref="Filelog"/>
			<appender-ref ref="RollingFileInfo"/>
			<appender-ref ref="RollingFileWarn"/>
			<appender-ref ref="RollingFileError"/>
			
			<!-- 同步发送邮件日志 -->
			<!-- <AppenderRef ref="Mail"  level="ERROR"/> --><!-- 增加level="ERROR"，过滤掉debug info-->
			<!--邮件配置三、
			异步发送邮件日志，引入上面配置的AsyncMail，当log.error时，发送日志-->
            <appender-ref ref="AsyncMail"  level="ERROR"/>
        </Root>
    </Loggers>
</Configuration>
```

https 443

http 80

https:3899

htttps://gnicks.restaurant.com/account/78


- 初始化项目
    
    ```xml
    mvn archetype:generate -DinteractiveMode=false -DgroupId=com.gnicks -DartifactId=javaSE -Dversion=1.0.0-SNAPSHOT
    
    - mvn：maven命令
    - archetype:generate：这是一个Maven插件，原型 archetype 插件是一个Maven项目模板工具包，可以用它创建基本的java项目结构。
    - DgourpId: 组织名，公司网址的反写 + 项目名称
    - DartifactId: 项目名（模块名）
    - Dversion：项目版本号
    - DinteractiveMode：是否使用交互模式：false不使用，直接创建；true使用，需要根据提示输入相关信息。
    
    ```
    
- 公共POM
    
    ```xml
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
        <modelVersion>4.0.0</modelVersion>
    
        <parent>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-parent</artifactId>
            <version>2.7.2</version>
            <relativePath/>
        </parent>
    
        <groupId>com.gnicks.study</groupId>
        <artifactId>gnicks-study-parent</artifactId>
        <packaging>pom</packaging>
        <version>1.0.0-SNAPSHOT</version>
    
        <properties>
            <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
            <java.version>1.8</java.version>
            <junit.version>3.8.1</junit.version>
        </properties>
    
        <name>parent</name>
        <url>http://maven.apache.org</url>
    
        <dependencies>
            <dependency>
                <groupId>junit</groupId>
                <artifactId>junit</artifactId>
                <version>${junit.version}</version>
                <scope>test</scope>
            </dependency>
    					<!--springboot核心依赖-->
    				<dependency>
    				    <groupId>org.springframework.boot</groupId>
    				    <artifactId>spring-boot-starter</artifactId>
    				</dependency>
    				<!--web启动-->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-web</artifactId>
            </dependency>
            <!--对面向切面变成的支持，通过spring-aop和AspectJ -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-aop</artifactId>
            </dependency>
    
        </dependencies>
        <build>
            <plugins>
                <plugin>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-maven-plugin</artifactId>
                </plugin>
                <!-- 设置jdk版本 -->
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-compiler-plugin</artifactId>
                    <configuration>
                        <source>${java.version}</source>
                        <target>${java.version}</target>
                        <encoding>${project.build.sourceEncoding}</encoding>
                    </configuration>
                </plugin>
            </plugins>
        </build>
    
    </project>
    ```
    
-