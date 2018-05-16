
Migrate Maven Artifact
============


## Overview

Ever wanted to migrate an artifact from the open Internet to some repository behind a firewall, or wanted to publish your artifact to your client's repository along with all dependencies? Here is a tool for you.

This tool contains two command line scripts:
- `resolve`: Resolves all dependencies for given artifact, download these dependencies and get ready for migration. The prepared materials will be put at `.deps-proj` sub directory;
- `deploy`: Deploy the prepared artifact and its dependencies by the `resolve` step to given respository. This step connects to your destination repository directly and publish your artifact and dependencies. If you want to run this step on the other machine, please copy the entire directory including the hidden files along to that machine before running this step. 



## Usage


First, prepare the artifact and its dependencies for the migration, this will apply your maven settings on necessary:

```powershell
PS> .\resolve.ps1 org.springframework.security spring-security-web 5.0.0.RELEASE 
```

Use spaces to separate *groupId*, *artifactId* and *version* fields and pass them to `resolve` command line.


Next, the migrating step, deploy the prepared artifact and dependencies to destination repository. On the same directory you run `resolve`, execute:
 ```powershell
PS> .\deploy.ps1 http://your-target-repo/ [http://repo-for-detecting/]
```

This command will use `deploy-settings.xml` if provided in the same directory, if your repository requires authentication, you can define a server with credential and give it an id `deploy`, the command will use it.
You may use a separate repository (e.g. the central) to detect if the deployment is necessary for a specific package, in that case, sepecify the second argument to the command line.


**Note:** Maven has to be installed as `mvn` command on your local computer.

*For macOS/Linux users, please replace following comamnd lines to `.sh` files.*


## License

This code is licensed under the [MIT lincense](https://opensource.org/licenses/MIT).





