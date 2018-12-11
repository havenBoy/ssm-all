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
  - 8 整合redis -- 

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
  
    <welcome-file-list>
      <welcome-file>index.html</welcome-file>
    </welcome-file-list>
  
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
  
      <!-- 连接池 -->
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
    
        <!-- 删除用户信息 -->
        <delete id="delUserById" parameterType="java.lang.Integer">
            DELETE FROM user where id = #{id}
        </delete>
    
    </mapper>
    ```

​          