
迁移 Maven 包制品 
============


## 简介

要将 Maven 包（即 artifact）从公网 Internet 迁移到防火墙后的内网仓库中吗？或者，要将 Maven 包带着依赖项一同发布到客户的仓库？这个工具就是给你用的！

这个脚本工具包含两个部分:
- `resolve`: 为给定的 artifact 解析并下载所有依赖项，暂存在目录中，以备后续迁移步骤使用。下载好的文件存储于 `.deps-proj`子目录;
- `deploy`: 把 `resolve` 步骤准备好的包和依赖等文件部署到指定的仓库中。这一步需要能直接连接目标仓库，并发布包和依赖项。如果需要在另外一台机器上运行这个步骤，请确保在运行之前，将整个运行了 `resolve` 步骤之后的目录（包含隐藏文件）都复制到该机器。


## 使用方法


**首先**, 准备包和依赖，这一步骤在需要时会使用机器上的 Maven settings.xml 文件:

```powershell
PS> .\resolve.ps1 org.springframework.security spring-security-web 5.0.0.RELEASE 
```

请用空格将 *groupId*, *artifactId* and *version* 字段隔开，并传入于 `resolve` 命令行使用。

<br />

**然后**，迁移步骤，在运行了 `resolve` 的同一个目录，运行：
 ```powershell
PS> .\deploy.ps1 http://your-target-repo/ [http://repo-for-detecting/]
```

如果在同一个目录下存在 `deploy-settings.xml` 文件，它将作为 Maven 发布包时所用的配置文件。主要用途是，如果目标 maven 仓库需要登录的话，可以在这个文件里添加一个 id 为 `deploy` 的 server 配置节。如果需要用另一个仓库（如 central）来检查特定的依赖项有没有必要发布到目标仓库中，可以将那个仓库的地址作为第二个参数传入。

**注意：** 运行此工具前，电脑上需要安装有 Maven，并且命令为 `mvn`。

*对于 macOS/Linux 用户，请将上述命令行中的 `.ps1` 替换为 `.sh` 即可。*


## 开源协议

本项目的代码采用 [MIT 协议](https://opensource.org/licenses/MIT) 开源。





