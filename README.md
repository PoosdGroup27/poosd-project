Repository for POOSD Group 27, Fall 2021 - TutorTrade
- Brock Davis
- Adam Fernandes
- Jesse Gingold
- Sebastian Hernandez


# Deployment

## Deploying + Building Frontend App
1. Install Xcode (version 13 recommended)
2. Clone repo
3. Open Xcode
4. Open  [TutorTrade.xcodeproj](https://github.com/PoosdGroup27/poosd-project/tree/main/frontend/TutorTrade/TutorTrade.xcodeproj)  file
5. Change emulator to iPhone 12 or iPhone 12 Pro
6. Command R or Hit *play* button on Xcode to run and build project

## Deploying + Building Backend
1. If not done above, clone repo
2. Create [AWS account](https://aws.amazon.com/)
3. Download [NodeJS](https://nodejs.org/en/download/)
4. Using NPM, which was installed with Node, `npm install -g serverless` to install the [Serverless Framework](https://www.serverless.com/)
5. Ensure you have Java 11 and Maven on your machine and available in the project directory
   1. If using Intellji (recommended), go to File -> Project Structure -> Project and select Amazon Corretto 11 JDK in the SDK dropdown. You will need to add it first using the edit and then + buttons. Then right click on the pom.xml file in the backend directory and select Maven -> add as Maven project
6. Change `prod` to `<your stage name>` in the folder locations:
   1. `<version>prod</version>` in pom.xml
   2. `stage: prod` in serverless.yml
   3. `@DynamoDBTable(tableName = "userTable-prod")` in User.java
   4. `@DynamoDBTable(tableName = "requestTable-prod")` in Request.java
7. `cd` into the backend/TutorTrade directory
8. Follow the steps under the `Creating AWS Access Keys` heading and then config access using instructions under `Setup with serverless config credentials command` subheading [here](https://www.serverless.com/framework/docs/providers/aws/guide/credentials)
9. Build the project using `mvn install` or, if using Intellij, in the Maven panel -> tutor-api -> Lifecycle -> install. If you make any changes, and want to rebuild, you will need to Maven clean before using install again
10. In a terminal window, ensure you are in the backend/TutorTrade directory and then `serverless package && serverless deploy`
11. Take note of the API URI output.
    1. Update the APIs in com.tutor.utils.ApiStage with your stage name in all uppercase and using underscores as separators, and the associated API URI as the argument
    2. Update the APIs in frontend source as needed
