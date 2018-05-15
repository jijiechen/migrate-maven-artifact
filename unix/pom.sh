groupId=$1
artifactId=$2
version=$3


pom_groupId="<groupId>$groupId</groupId>"
pom_artifactId="<artifactId>$artifactId</artifactId>"
pom_version="<version>$version</version>"

pom_template_1='<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<groupId>resolve-deps</groupId>
	<artifactId>resolve-deps</artifactId>
	<name>resolve-deps</name>
	<packaging>jar</packaging>
	<version>1.0.0</version>

	<dependencies>
	<dependency>'

pom_template_2='</dependency></dependencies>
	<build>
		<finalName>${project.artifactId}</finalName>
		<plugins>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-compiler-plugin</artifactId>
				<version>3.7.0</version>
				<configuration>
					<source>${java-version}</source>
					<target>${java-version}</target>
				</configuration>
			</plugin>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-dependency-plugin</artifactId>
				<executions>
					<execution>
						<id>install</id>
						<phase>install</phase>
						<goals>
							<goal>sources</goal>
						</goals>
					</execution>
				</executions>
			</plugin>
		</plugins>
	</build>
</project>'

echo "$pom_template_1 $pom_groupId $pom_artifactId $pom_version $pom_template_2"


