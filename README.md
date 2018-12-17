### SSM 项目整合
> how to make ssm project

* 1 创建maven工程，并完善文件结构

  * 整体的效果如如下：
  * ![图片](https://github.com/havenBoy/notes/raw/master/img/6.png)

* 2 引入pom文件
  - 1 spring相关     --    <version>4.1.4.RELEASE </version>
  - 2 mybatis相关  --    <version>3.4.1</version>
  - 3 spring-mybatis整合包  --   <version>1.3.1</version>
  - 4 日志log4j    --   <version>1.2.3</version>
  - 5 数据库连接池(druid,c3p0)  --    <version>0.9.5.2</version>
  - 6 数据库驱动  --   <version>5.1.41</version>
  - 7 json转化包   --   <version>2.8.7</version>    --- fastjson

* 3  配置web.xml

  * 示例：

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
           version="3.1">
  
    <display-name>ssm-all</display-name>
    <description>ssm-all-0.0.1</description>
  
    <!-- 编码过滤器 -->
    <filter>
      <filter-name>encodingFilter</filter-name>
      <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
      <init-param>
        <param-name>encoding</param-name>
        <param-value>UTF-8</param-value>
      </init-param>
    </filter>
    <filter-mapping>
      <filter-name>encodingFilter</filter-name>
      <url-pattern>/*</url-pattern>
    </filter-mapping>
  
    <!-- 实例化SpringIOC容器的监听器 -->
    <context-param>
      <param-name>contextConfigLocation</param-name>
      <param-value>classpath:applicationContext.xml</param-value>
    </context-param>
  
    <listener>
      <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>
  
    <!-- 配置DispatcherServlet -->
    <servlet>
      <servlet-name>SpringMVC</servlet-name>
      <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
      <!-- 配置springMVC需要加载的配置文件-->
      <init-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:spring-mvc.xml</param-value>
      </init-param>
      <load-on-startup>1</load-on-startup>
      <async-supported>true</async-supported>
    </servlet>
    <servlet-mapping>
      <servlet-name>SpringMVC</servlet-name>
      <!-- 匹配所有请求，此处也可以配置成 *.do 形式 -->
      <url-pattern>/</url-pattern>
    </servlet-mapping>
    <!-- 配置Druid数据源 -->
    <filter>
      <filter-name>DruidWebStatFilter</filter-name>
      <filter-class>com.alibaba.druid.support.http.WebStatFilter</filter-class>
      <init-param>
        <param-name>exclusions</param-name>
        <param-value>*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*</param-value>
      </init-param>
    </filter>
    <filter-mapping>
      <filter-name>DruidWebStatFilter</filter-name>
      <url-pattern>/*</url-pattern>
    </filter-mapping>
  
    <!-- Sql监控 -->
    <servlet>
      <servlet-name>druidStatView</servlet-name>
      <servlet-class>com.alibaba.druid.support.http.StatViewServlet</servlet-class>
      <init-param>
        <!-- 允许清空统计数据 -->
        <param-name>resetEnable</param-name>
        <param-value>true</param-value>
      </init-param>
      <init-param>
        <!-- 用户名 -->
        <param-name>loginUsername</param-name>
        <param-value>druid</param-value>
      </init-param>
      <init-param>
        <!-- 密码 -->
        <param-name>loginPassword</param-name>
        <param-value>druid</param-value>
      </init-param>
      <init-param>
        <!-- 运行访问的IP，使用，隔开 -->
        <param-name>allow</param-name>
        <param-value>druid</param-value>
      </init-param>
      <init-param>
        <!-- 限制访问的IP，同理使用，隔开-->
        <param-name>deny</param-name>
        <param-value>192.168.13.20</param-value>
      </init-param>
    </servlet>
    <servlet-mapping>
      <servlet-name>druidStatView</servlet-name>
      <url-pattern>/druid/*</url-pattern>
    </servlet-mapping>
  
    <error-page>
      <error-code>404</error-code>
      <location>/views/error/404.jsp</location>
    </error-page>
    <error-page>
      <error-code>500</error-code>
      <location>/views/error/500.jsp</location>
    </error-page>
  </web-app>
  ```

* applicationContext.xml    Spring的配置文件

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns:context="http://www.springframework.org/schema/context"
         xmlns:tx="http://www.springframework.org/schema/tx"
         xmlns:mybatis-spring="http://mybatis.org/schema/mybatis-spring"
         xsi:schemaLocation="http://mybatis.org/schema/mybatis-spring http://mybatis.org/schema/mybatis-spring-1.2.xsd
  		http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
  		http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd
  		http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx-4.0.xsd">
  
  
      <!-- 组件扫描 -->
      <context:component-scan base-package="com.**">
          <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
      </context:component-scan>
      <bean id="propertiesFactoryBean" class="org.springframework.beans.factory.config.PropertiesFactoryBean">
          <property name="locations">
              <list>
                  <value>classpath:db.properties</value>
              </list>
          </property>
      </bean>
  
      <context:property-placeholder properties-ref="propertiesFactoryBean"/>
  
  <!--    &lt;!&ndash; 连接池c3p0 &ndash;&gt;
      <context:property-placeholder location="classpath:db.properties"/>
      <bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource">
          <property name="driverClass" value="${jdbc.driver}"></property>
          <property name="jdbcUrl" value="${jdbc.url}"></property>
          <property name="user" value="${jdbc.username}"></property>
          <property name="password" value="${jdbc.password}"></property>
          <property name="maxPoolSize" value="${c3p0.maxPoolSize}"></property>
          <property name="minPoolSize" value="${c3p0.minPoolSize}"></property>
          <property name="autoCommitOnClose" value="${c3p0.autoCommitOnClose}"></property>
          <property name="checkoutTimeout" value="${c3p0.checkoutTimeout}"></property>
          <property name="acquireIncrement" value="${c3p0.acquireRetryAttempts}"></property>
      </bean>-->
      <!--数据连接池 druid -->
      <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource" init-method="init" destroy-method="close">
          <property name="driverClassName" value="${jdbc.driver}" />
          <property name="url" value="${jdbc.url}" />
          <property name="username" value="${jdbc.username}" />
          <property name="password" value="${jdbc.password}" />
          <property name="filters" value="stat" />
          <property name="maxActive" value="20" />
          <property name="initialSize" value="1" />
          <property name="maxWait" value="60000" />
          <property name="minIdle" value="1" />
          <property name="timeBetweenEvictionRunsMillis" value="60000"/>
          <property name="minEvictableIdleTimeMillis" value="300000"/>
  
          <property name="validationQuery" value="SELECT 'x'" />
          <property name="testWhileIdle" value="true" />
          <property name="testOnBorrow" value="false" />
          <property name="testOnReturn" value="false" />
          <property name="poolPreparedStatements" value="true" />
          <property name="maxPoolPreparedStatementPerConnectionSize" value="50"/>
      </bean>
  
      <!-- 事务 -->
      <bean id="dataSourceTransactionManager"
            class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
          <property name="dataSource" ref="dataSource"></property>
      </bean>
      <tx:annotation-driven transaction-manager="dataSourceTransactionManager"/>
  
      <!-- redis 配置,也可以把配置挪到properties配置文件中,再读取 -->
      <bean id="jedisPool" class="redis.clients.jedis.JedisPool">
          <constructor-arg index="0" ref="jedisPoolConfig" />
          <!-- 端口，默认6379 -->
          <constructor-arg index="2" value="${redis.port}"  name="port" type="int"/>
          <constructor-arg index="3" value="5000"  name="timeout" type="int"/>
          <constructor-arg index="1" value="${redis.ip}" name="host" type="java.lang.String"/>
          <!-- 如果你需要配置密码 <constructor-arg index="4" value="你的密码" name="password" type="java.lang.String"/>
          -->
      </bean>
      <bean id="jedisPoolConfig" class="redis.clients.jedis.JedisPoolConfig">
          <property name="maxIdle" value="${redis.maxIdle}"/><!-- 最大闲置 -->
          <property name="maxWaitMillis" value="${redis.maxWait}" />
          <property name="testOnBorrow" value="${redis.testOnBorrow}" />
      </bean>
  
      <!-- Spring 整合 Mybatis -->
      <!--1. SqlSession  -->
      <bean class="org.mybatis.spring.SqlSessionFactoryBean">
          <!-- 指定数据源 -->
          <property name="dataSource" ref="dataSource"></property>
          <!-- MyBatis的配置文件 -->
          <property name="configLocation" value="classpath:mybatis-config.xml"></property>
          <!-- MyBatis的SQL映射文件 -->
          <property name="mapperLocations" value="classpath:mybatis/mapper/*.xml"></property>
          <property name="typeAliasesPackage" value="com.xiong.entity"></property>
      </bean>
  
      <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
          <property name="basePackage" value="com.xiong.mapper"></property>
      </bean>
  </beans>
  ```

* MyBatis 配置包    

  * mybatis-config.xml

    ```xml
    <?xml version="1.0" encoding="UTF-8" ?>
    <!DOCTYPE configuration
            PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
            "http://mybatis.org/dtd/mybatis-3-config.dtd">
    <configuration>
        <!--  Spring 整合 MyBatis 后， MyBatis中配置数据源，事务等一些配置都可以
             迁移到Spring的整合配置中。MyBatis配置文件中只需要配置与MyBatis相关
             的即可。
         -->
        <!-- settings: 包含很多重要的设置项  -->
        <settings>
            <!-- 映射下划线到驼峰命名 -->
            <setting name="mapUnderscoreToCamelCase" value="true"/>
            <!-- 设置Mybatis对null值的默认处理 -->
            <setting name="jdbcTypeForNull" value="NULL"/>
            <!-- 开启延迟加载 -->
            <setting name="lazyLoadingEnabled" value="true"/>
            <!-- 设置加载的数据是按需还是全部 -->
            <setting name="aggressiveLazyLoading" value="false"/>
            <!-- 配置开启二级缓存 -->
            <setting name="cacheEnabled" value="true"/>
        </settings>
    </configuration>
    ```

* 日志记录

  * log4j.properties

    ```properties
    log4j.rootLogger=debug,Console
    
    log4j.appender.Console=org.apache.log4j.ConsoleAppender
    log4j.appender.Console.Target=System.out
    log4j.appender.Console.layout=org.apache.log4j.PatternLayout
    log4j.appender.Console.layout.ConversionPattern=[%p][%d{yyyy-MM-dd HH\:mm\:ss,SSS}][%c]%m%n
    ```

* mapper.xml

  * ***Mapper.xml

    ```xml
    <?xml version="1.0" encoding="UTF-8" ?>
    <!DOCTYPE mapper
            PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
            "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
    
    <mapper namespace="com.xiong.mapper.UserMapper">
    
        <select id="findByPage" parameterType="java.lang.Integer" resultType="com.xiong.entity.User" >
            select * from user
             order by id
                limit #{start},#{end}
        </select>
    
        <select id="findByNameAndPassword" parameterType="java.lang.String" resultType="com.xiong.entity.User">
            SELECT * FROM user
            where username = #{name} and password = #{password}
        </select>
        <select id="findAll" resultType="com.xiong.entity.User" >
            select * from user order by id
        </select>
    
        <insert id="addUser" parameterType="com.xiong.entity.User">
            INSERT INTO user (id,username,age,address,desc) VALUES (#{id},#{username},#{age},#{address},#{desc})
        </insert>
    
        <!-- 修改用户信息 -->
        <update id="saveUser" parameterType="com.xiong.entity.User">
            UPDATE user u set u.username = #{username}, u.age = #{age},
            u.address = #{address}, u.desc = #{desc}
            where id = #{id}
        </update>
    
        <!-- 通过name 查询用户-->
        <select id="checkUser" parameterType="java.lang.String" resultType="com.xiong.entity.User">
            SELECT * FROM user
            where username = #{name} and password = #{password}
        </select>
    
        <!-- 修改用户密码 -->
        <update id="changePassword" parameterType="java.lang.String">
            UPDATE user u set u.password = #{repassword}
            where u.username = #{name} and u.password = #{password}
        </update>
    
        <!-- 删除用户信息 -->
        <delete id="delUserById" parameterType="java.lang.Integer">
            DELETE FROM user where id = #{id}
        </delete>
    
    </mapper>
    ```

* pom.xml

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  
  <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
      <modelVersion>4.0.0</modelVersion>
  
      <groupId>com.xiong</groupId>
      <artifactId>ssm-all</artifactId>
      <version>1.0-SNAPSHOT</version>
      <packaging>war</packaging>
  
      <name>ssm-all Maven</name>
      <!-- FIXME change it to the project's website -->
      <url>http://127.0.0.1:8080/ssm/</url>
  
      <properties>
          <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
          <maven.compiler.source>1.7</maven.compiler.source>
          <maven.compiler.target>1.7</maven.compiler.target>
          <!-- spring版本号 -->
          <spring.version>4.1.4.RELEASE</spring.version>
          <!-- mybatis版本号 -->
          <mybatis.version>3.4.1</mybatis.version>
          <!-- mybatis版本号 -->
          <druid.version>1.1.10</druid.version>
      </properties>
  
      <dependencies>
  
          <dependency>
              <groupId>org.apache.taglibs</groupId>
              <artifactId>taglibs-standard-impl</artifactId>
              <version>1.2.5</version>
          </dependency>
  
          <!-- 实现slf4j接口并整合 -->
          <dependency>
              <groupId>log4j</groupId>
              <artifactId>log4j</artifactId>
              <version>1.2.17</version>
          </dependency>
          <dependency>
              <groupId>org.slf4j</groupId>
              <artifactId>slf4j-log4j12</artifactId>
              <version>1.7.16</version>
          </dependency>
          <!-- https://mvnrepository.com/artifact/javax.servlet/javax.servlet-api -->
          <dependency>
              <groupId>javax.servlet</groupId>
              <artifactId>javax.servlet-api</artifactId>
              <version>3.1.0</version>
          </dependency>
          <!-- JSON -->
          <dependency>
              <groupId>com.fasterxml.jackson.core</groupId>
              <artifactId>jackson-databind</artifactId>
              <version>2.8.9</version>
          </dependency>
  
          <!-- 数据库驱动 -->
          <dependency>
              <groupId>mysql</groupId>
              <artifactId>mysql-connector-java</artifactId>
              <version>5.1.41</version>
              <scope>runtime</scope>
          </dependency>
  
          <!-- 数据库连接池 -->
          <dependency>
              <groupId>com.mchange</groupId>
              <artifactId>c3p0</artifactId>
              <version>0.9.5.2</version>
          </dependency>
          <!-- https://mvnrepository.com/artifact/com.alibaba/druid -->
          <dependency>
              <groupId>com.alibaba</groupId>
              <artifactId>druid</artifactId>
              <version>${druid.version}</version>
          </dependency>
  
          <!-- 实现slf4j接口并整合 -->
          <dependency>
              <groupId>ch.qos.logback</groupId>
              <artifactId>logback-classic</artifactId>
              <version>1.2.3</version>
          </dependency>
  
          <!-- mybatis/spring整合包 -->
          <dependency>
              <groupId>org.mybatis</groupId>
              <artifactId>mybatis-spring</artifactId>
              <version>1.3.1</version>
          </dependency>
  
          <!-- mybatis 包 -->
          <dependency>
              <groupId>org.mybatis</groupId>
              <artifactId>mybatis</artifactId>
              <version>3.2.8</version>
          </dependency>
  
          <!-- redis begin -->
          <dependency>
              <groupId>redis.clients</groupId>
              <artifactId>jedis</artifactId>
              <version>2.8.0</version>
          </dependency>
          <!-- redis end -->
  
  
          <!-- Spring -->
          <dependency>
              <groupId>org.springframework</groupId>
              <artifactId>spring-core</artifactId>
              <version>${spring.version}</version>
          </dependency>
          <dependency>
              <groupId>org.springframework</groupId>
              <artifactId>spring-beans</artifactId>
              <version>${spring.version}</version>
          </dependency>
          <dependency>
              <groupId>org.springframework</groupId>
              <artifactId>spring-context</artifactId>
              <version>${spring.version}</version>
          </dependency>
          <dependency>
              <groupId>org.springframework</groupId>
              <artifactId>spring-jdbc</artifactId>
              <version>${spring.version}</version>
          </dependency>
          <dependency>
              <groupId>org.springframework</groupId>
              <artifactId>spring-tx</artifactId>
              <version>${spring.version}</version>
          </dependency>
          <dependency>
              <groupId>org.springframework</groupId>
              <artifactId>spring-web</artifactId>
              <version>${spring.version}</version>
          </dependency>
          <dependency>
              <groupId>org.springframework</groupId>
              <artifactId>spring-webmvc</artifactId>
              <version>${spring.version}</version>
          </dependency>
          <dependency>
              <groupId>org.springframework</groupId>
              <artifactId>spring-test</artifactId>
              <version>${spring.version}</version>
          </dependency>
          <dependency>
              <groupId>junit</groupId>
              <artifactId>junit</artifactId>
              <version>4.11</version>
              <scope>test</scope>
          </dependency>
      </dependencies>
  
      <build>
          <finalName>ssm-all</finalName>
          <pluginManagement><!-- lock down plugins versions to avoid using Maven defaults (may be moved to parent pom) -->
              <plugins>
                  <plugin>
                      <groupId>org.apache.maven.plugins</groupId>
                      <artifactId>maven-compiler-plugin</artifactId>
                      <configuration>
                          <!-- 设置JDK版本 -->
                          <source>1.8</source>
                          <target>1.8</target>
                      </configuration>
                  </plugin>
              </plugins>
          </pluginManagement>
      </build>
  </project>
  ```