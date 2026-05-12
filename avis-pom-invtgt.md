$ docker compose logs avis-service
avis-service  | 
avis-service  |   .   ____          _            __ _ _
avis-service  |  /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
avis-service  | ( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
avis-service  |  \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
avis-service  |   '  |____| .__|_| |_|_| |_\__, | / / / /
avis-service  |  =========|_|==============|___/=/_/_/_/
avis-service  | 
avis-service  |  :: Spring Boot ::                (v4.0.6)
avis-service  | 
avis-service  | 2026-05-12T09:15:01.296Z  INFO 1 --- [avis-service] [           main] e.e.avis_service.AvisServiceApplication  : Starting AvisServiceApplication v1.0.0 using Java 25.0.3 with PID 1 (/app/app.jar started by root in /app)
avis-service  | 2026-05-12T09:15:01.315Z  INFO 1 --- [avis-service] [           main] e.e.avis_service.AvisServiceApplication  : No active profile set, falling back to 1 default profile: "default"
avis-service  | 2026-05-12T09:15:06.885Z  INFO 1 --- [avis-service] [           main] .s.d.r.c.RepositoryConfigurationDelegate : Bootstrapping Spring Data JPA repositories in DEFAULT mode.
avis-service  | 2026-05-12T09:15:07.109Z  INFO 1 --- [avis-service] [           main] .s.d.r.c.RepositoryConfigurationDelegate : Finished Spring Data repository scanning in 192 ms. Found 1 JPA repository interface.
avis-service  | 2026-05-12T09:15:07.458Z  WARN 1 --- [avis-service] [           main] ConfigServletWebServerApplicationContext : Exception encountered during context initialization - cancelling refresh attempt: java.lang.IllegalStateException: Error processing condition on org.springframework.cloud.client.discovery.simple.SimpleDiscoveryClientAutoConfiguration.simpleDiscoveryProperties
avis-service  | 2026-05-12T09:15:07.495Z  INFO 1 --- [avis-service] [           main] .s.b.a.l.ConditionEvaluationReportLogger : 
avis-service  | 
avis-service  | Error starting ApplicationContext. To display the condition evaluation report re-run your application with 'debug' enabled.
avis-service  | 2026-05-12T09:15:07.542Z ERROR 1 --- [avis-service] [           main] o.s.boot.SpringApplication               : Application run failed
avis-service  | 
avis-service  | java.lang.IllegalStateException: Error processing condition on org.springframework.cloud.client.discovery.simple.SimpleDiscoveryClientAutoConfiguration.simpleDiscoveryProperties
avis-service  |         at org.springframework.boot.autoconfigure.condition.SpringBootCondition.matches(SpringBootCondition.java:60) ~[spring-boot-autoconfigure-4.0.6.jar!/:4.0.6]
avis-service  |         at org.springframework.context.annotation.ConditionEvaluator.shouldSkip(ConditionEvaluator.java:100) ~[spring-context-7.0.7.jar!/:7.0.7]
avis-service  |         at org.springframework.context.annotation.ConfigurationClassBeanDefinitionReader.loadBeanDefinitionsForBeanMethod(ConfigurationClassBeanDefinitionReader.java:196) ~[spring-context-7.0.7.jar!/:7.0.7]
avis-service  |         at org.springframework.context.annotation.ConfigurationClassBeanDefinitionReader.loadBeanDefinitionsForConfigurationClass(ConfigurationClassBeanDefinitionReader.java:148) ~[spring-context-7.0.7.jar!/:7.0.7]
avis-service  |         at org.springframework.context.annotation.ConfigurationClassBeanDefinitionReader.loadBeanDefinitions(ConfigurationClassBeanDefinitionReader.java:124) ~[spring-context-7.0.7.jar!/:7.0.7]
avis-service  |         at org.springframework.context.annotation.ConfigurationClassPostProcessor.processConfigBeanDefinitions(ConfigurationClassPostProcessor.java:464) ~[spring-context-7.0.7.jar!/:7.0.7]
avis-service  |         at org.springframework.context.annotation.ConfigurationClassPostProcessor.postProcessBeanDefinitionRegistry(ConfigurationClassPostProcessor.java:316) ~[spring-context-7.0.7.jar!/:7.0.7]
avis-service  |         at org.springframework.context.support.PostProcessorRegistrationDelegate.invokeBeanDefinitionRegistryPostProcessors(PostProcessorRegistrationDelegate.java:349) ~[spring-context-7.0.7.jar!/:7.0.7]
avis-service  |         at org.springframework.context.support.PostProcessorRegistrationDelegate.invokeBeanFactoryPostProcessors(PostProcessorRegistrationDelegate.java:118) ~[spring-context-7.0.7.jar!/:7.0.7]
avis-service  |         at org.springframework.context.support.AbstractApplicationContext.invokeBeanFactoryPostProcessors(AbstractApplicationContext.java:795) ~[spring-context-7.0.7.jar!/:7.0.7]
avis-service  |         at org.springframework.context.support.AbstractApplicationContext.refresh(AbstractApplicationContext.java:603) ~[spring-context-7.0.7.jar!/:7.0.7]
avis-service  |         at org.springframework.boot.web.server.servlet.context.ServletWebServerApplicationContext.refresh(ServletWebServerApplicationContext.java:143) ~[spring-boot-web-server-4.0.6.jar!/:4.0.6]
avis-service  |         at org.springframework.boot.SpringApplication.refresh(SpringApplication.java:756) ~[spring-boot-4.0.6.jar!/:4.0.6]
avis-service  |         at org.springframework.boot.SpringApplication.refreshContext(SpringApplication.java:445) ~[spring-boot-4.0.6.jar!/:4.0.6]
avis-service  |         at org.springframework.boot.SpringApplication.run(SpringApplication.java:321) ~[spring-boot-4.0.6.jar!/:4.0.6]
avis-service  |         at org.springframework.boot.SpringApplication.run(SpringApplication.java:1365) ~[spring-boot-4.0.6.jar!/:4.0.6]
avis-service  |         at org.springframework.boot.SpringApplication.run(SpringApplication.java:1354) ~[spring-boot-4.0.6.jar!/:4.0.6]
avis-service  |         at edu.exam.avis_service.AvisServiceApplication.main(AvisServiceApplication.java:12) ~[!/:1.0.0]
avis-service  |         at java.base/jdk.internal.reflect.DirectMethodHandleAccessor.invoke(Unknown Source) ~[na:na]
avis-service  |         at java.base/java.lang.reflect.Method.invoke(Unknown Source) ~[na:na]
avis-service  |         at org.springframework.boot.loader.launch.Launcher.launch(Launcher.java:106) ~[app.jar:1.0.0]
avis-service  |         at org.springframework.boot.loader.launch.Launcher.launch(Launcher.java:64) ~[app.jar:1.0.0]
avis-service  |         at org.springframework.boot.loader.launch.JarLauncher.main(JarLauncher.java:40) ~[app.jar:1.0.0]
avis-service  | Caused by: java.lang.IllegalStateException: @ConditionalOnMissingBean did not specify a bean using type, name or annotation and the attempt to deduce the bean's type failed
avis-service  |         at org.springframework.boot.autoconfigure.condition.OnBeanCondition$Spec.validate(OnBeanCondition.java:657) ~[spring-boot-autoconfigure-4.0.6.jar!/:4.0.6]
avis-service  |         at org.springframework.boot.autoconfigure.condition.OnBeanCondition$Spec.<init>(OnBeanCondition.java:603) ~[spring-boot-autoconfigure-4.0.6.jar!/:4.0.6]
avis-service  |         at org.springframework.boot.autoconfigure.condition.OnBeanCondition.getMatchOutcome(OnBeanCondition.java:147) ~[spring-boot-autoconfigure-4.0.6.jar!/:4.0.6]
avis-service  |         at org.springframework.boot.autoconfigure.condition.SpringBootCondition.matches(SpringBootCondition.java:47) ~[spring-boot-autoconfigure-4.0.6.jar!/:4.0.6]
avis-service  |         ... 22 common frames omitted
avis-service  | Caused by: org.springframework.boot.autoconfigure.condition.OnBeanCondition$BeanTypeDeductionException: Failed to deduce bean type for org.springframework.cloud.client.discovery.simple.SimpleDiscoveryClientAutoConfiguration.simpleDiscoveryProperties
avis-service  |         at org.springframework.boot.autoconfigure.condition.OnBeanCondition$Spec.deducedBeanTypeForBeanMethod(OnBeanCondition.java:686) ~[spring-boot-autoconfigure-4.0.6.jar!/:4.0.6]
avis-service  |         at org.springframework.boot.autoconfigure.condition.OnBeanCondition$Spec.deducedBeanType(OnBeanCondition.java:676) ~[spring-boot-autoconfigure-4.0.6.jar!/:4.0.6]
avis-service  |         at org.springframework.boot.autoconfigure.condition.OnBeanCondition$Spec.<init>(OnBeanCondition.java:596) ~[spring-boot-autoconfigure-4.0.6.jar!/:4.0.6]
avis-service  |         ... 24 common frames omitted
avis-service  | Caused by: java.lang.IllegalStateException: Failed to introspect Class [org.springframework.cloud.client.discovery.simple.SimpleDiscoveryClientAutoConfiguration] from ClassLoader [org.springframework.boot.loader.launch.LaunchedClassLoader@24d46ca6]
avis-service  |         at org.springframework.util.ReflectionUtils.getDeclaredMethods(ReflectionUtils.java:483) ~[spring-core-7.0.7.jar!/:7.0.7]
avis-service  |         at org.springframework.util.ReflectionUtils.findMethod(ReflectionUtils.java:240) ~[spring-core-7.0.7.jar!/:7.0.7]
avis-service  |         at org.springframework.util.ReflectionUtils.findMethod(ReflectionUtils.java:221) ~[spring-core-7.0.7.jar!/:7.0.7]
avis-service  |         at org.springframework.boot.autoconfigure.condition.OnBeanCondition$Spec.findBeanMethod(OnBeanCondition.java:715) ~[spring-boot-autoconfigure-4.0.6.jar!/:4.0.6]
avis-service  |         at org.springframework.boot.autoconfigure.condition.OnBeanCondition$Spec.getMethodReturnType(OnBeanCondition.java:710) ~[spring-boot-autoconfigure-4.0.6.jar!/:4.0.6]
avis-service  |         at org.springframework.boot.autoconfigure.condition.OnBeanCondition$Spec.getReturnType(OnBeanCondition.java:694) ~[spring-boot-autoconfigure-4.0.6.jar!/:4.0.6]
avis-service  |         at org.springframework.boot.autoconfigure.condition.OnBeanCondition$Spec.deducedBeanTypeForBeanMethod(OnBeanCondition.java:683) ~[spring-boot-autoconfigure-4.0.6.jar!/:4.0.6]
avis-service  |         ... 26 common frames omitted
avis-service  | Caused by: java.lang.NoClassDefFoundError: org/springframework/boot/autoconfigure/web/ServerProperties
avis-service  |         at java.base/java.lang.Class.getDeclaredMethods0(Native Method) ~[na:na]
avis-service  |         at java.base/java.lang.Class.privateGetDeclaredMethods(Unknown Source) ~[na:na]
avis-service  |         at java.base/java.lang.Class.getDeclaredMethods(Unknown Source) ~[na:na]
avis-service  |         at org.springframework.util.ReflectionUtils.getDeclaredMethods(ReflectionUtils.java:465) ~[spring-core-7.0.7.jar!/:7.0.7]
avis-service  |         ... 32 common frames omitted
avis-service  | Caused by: java.lang.ClassNotFoundException: org.springframework.boot.autoconfigure.web.ServerProperties
avis-service  |         at java.base/java.net.URLClassLoader.findClass(Unknown Source) ~[na:na]
avis-service  |         at java.base/java.lang.ClassLoader.loadClass(Unknown Source) ~[na:na]
avis-service  |         at org.springframework.boot.loader.net.protocol.jar.JarUrlClassLoader.loadClass(JarUrlClassLoader.java:107) ~[app.jar:1.0.0]
avis-service  |         at org.springframework.boot.loader.launch.LaunchedClassLoader.loadClass(LaunchedClassLoader.java:91) ~[app.jar:1.0.0]
avis-service  |         at java.base/java.lang.ClassLoader.loadClass(Unknown Source) ~[na:na]
avis-service  |         ... 36 common frames omitted