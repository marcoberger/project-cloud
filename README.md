Welcome to the project-cloud sample repository. This repository contains the code that is referred to by the codecentric blog article [TODO: Name it here](https://blog.codecentric.de/???). The article refers to git tags at certain paragraphs. These tags are used throughout the repository to label revisions of the sample code. While you follow along the article you can switch from tag to tag in order to see the code revision for that specific part of the article.

## Build and run the sample application
In order to run the sample application follow the steps below.
```bash
cd backend
./gradlew clean build && java -jar build/libs/project-cloud-0.1.0.jar

cd ../frontend
yarn install
yarn start
```
