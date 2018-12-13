### SSM 项目整合
> how to make ssm project

* 1 创建maven工程，并完善文件结构

  * 整体的效果如如下：
  * ![图片](https://github.com/havenBoy/notes/raw/master/img/6.png)

* 2 引入pom文件
  - 1 spring相关     --    <version>4.1.4.RELEASE </version>
  - 2 mybatis相关  --    <version>3.4.1</version>
  - 3 spring-mybatis整合包  --   <version>1.3.1</version>
  - 4 日志log4j 或者 logback    --   <version>1.2.3</version>
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
        <param-value>classpath:springmvc.xml</param-value>
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

  * logback.xml

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <configuration debug="true">
        <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
            <encoder>
                <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
            </encoder>
        </appender>
        <root level="debug">
            <appender-ref ref="STDOUT"/>
        </root>
    </configuration>
    ```

* mapper.xml

  *  ***Mapper.xml

    ```xml
    <?xml version="1.0" encoding="UTF-8" ?>
    <!DOCTYPE mapper
            PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
            "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
    
    <mapper namespace="com.xiong.mapper.UserMapper">
        <!--不做映射的 -->
        <select id="findAll" resultType="com.xiong.entity.User" >
            select * from user
        </select>
        <!--做映射的 -->
    	<select id="getAllEmps" resultMap="myEmpsAndDept" >
    		select e.id eid, e.last_name,e.email,e.gender, d.id did, d.dept_name
    		from tbl_employee e ,tbl_dept d 
    		where e.d_id = d.id 
    	</select>
    	<resultMap type="com.atguigu.ssm.beans.Employee" id="myEmpsAndDept">
    		<id column="eid" property="id"/>
    		<result column="last_name" property="lastName"/>
    		<result column="email" property="email"/>
    		<result column="gender" property="gender"/>
    		
    		<association property="dept"
                         javaType="com.atguigu.ssm.beans.Department">
    			<id column="did" property="id"/>
    			<result column="dept_name" property="departmentName"/>
    		</association>
    	</resultMap>
    </mapper>
    
    ```

​          