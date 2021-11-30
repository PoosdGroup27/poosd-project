![Backend Deployment](https://github.com/PoosdGroup27/poosd-project/actions/workflows/deploy.yml/badge.svg)
![Backend Build + Lint Lint](https://github.com/PoosdGroup27/poosd-project/actions/workflows/build_and_lint.yml/badge.svg)
![Swift Lint](https://github.com/PoosdGroup27/poosd-project/actions/workflows/swift_lint.yml/badge.svg)

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
4. Open [TutorTrade.xcodeproj](https://github.com/PoosdGroup27/poosd-project/tree/main/frontend/TutorTrade/TutorTrade.xcodeproj)
   file
5. Change emulator to iPhone 12 or iPhone 12 Pro
6. Command R or Hit _play_ button on Xcode to run and build project

## Deploying + Building Backend

1. If not done above, clone repo
2. Create [AWS account](https://aws.amazon.com/)
3. Download [NodeJS](https://nodejs.org/en/download/)
4. Using NPM, which was installed with Node, `npm install -g serverless` to install
   the [Serverless Framework](https://www.serverless.com/)
5. Ensure you have Java 11 and Maven on your machine and available in the project directory
   1. If using Intellji (recommended), go to File -> Project Structure -> Project and select Amazon Corretto 11 JDK in
      the SDK dropdown. You will need to add it first using the edit and then + buttons. Then right click on the
      pom.xml file in the backend directory and select Maven -> add as Maven project
6. Change `prod` to `<your stage name>` in the folder locations:
   1. `<version>prod</version>` in pom.xml
   2. `stage: prod` in serverless.yml
   3. `@DynamoDBTable(tableName = "userTable-prod")` in User.java
   4. `@DynamoDBTable(tableName = "requestTable-prod")` in Request.java
   5. `@DynamoDBTable(tableName = "chatTable-prod")` in Chat.java
7. `cd` into the backend/TutorTrade directory
8. Follow the steps under the `Creating AWS Access Keys` heading and then config access using instructions
   under `Setup with serverless config credentials command`
   subheading [here](https://www.serverless.com/framework/docs/providers/aws/guide/credentials)
9. Build the project using `mvn install` or, if using Intellij, in the Maven panel -> tutor-api -> Lifecycle -> install.
   If you make any changes, and want to rebuild, you will need to Maven clean before using install again
10. In a terminal window, ensure you are in the backend/TutorTrade directory and
    then `serverless package && serverless deploy`
11. Take note of the API URI output.
    1. Update the APIs in com.tutor.utils.ApiStage with your stage name in all uppercase and using underscores as
       separators, and the associated API URI as the argument
    2. Update the APIs in frontend source as needed

# Image Resources

#### This project is purely for educational purposes, and the images were used via Fair Use. Do not redistribute.
- [Unread Chat -- mark chat unread](https://fonts.google.com/icons?icon.query=chat)
- [Major](https://stock.adobe.com/images/id/315003907?as_campaign=Flaticon&as_content=api&as_audience=srp&tduid=2494635b2a9db8907e49b3817624f22e&as_channel=affiliate&as_campclass=redirect&as_source=arvato)
- [Face to Face](https://thenounproject.com/search/?q=face+to+face&i=4143277)
- [Default Person -- Recruitment Process Vector Human Resources Choice Of Ca](https://abilitytolov3.blogspot.com/1997/02/illustration-vector-human.html)
- [Tickbox](https://icons8.com/icon/15427/tick-box)
- [Globe/Online](https://www.flaticon.com/free-icon/laptop_2799156?term=online%20globe%20laptop&related_id=2799156)
- [Phone](https://thenounproject.com/search/?q=phone&i=4410706)
- [Bookmark (changed color)](https://www.flaticon.com/free-icon/bookmark_102279?term=bookmark&page=1&position=3&page=1&position=3&related_id=102279&origin=search)
- [Star](https://www.flaticon.com/free-icon/star_929495?term=star&page=1&position=14&page=1&position=14&related_id=929495&origin=search)
- [Exit](https://thenounproject.com/search/?q=x&i=2663763)
- [Undo](https://www.flaticon.com/free-icon/undo_725004?term=undo&page=1&position=19&page=1&position=19&related_id=725004&origin=search)
- [No Cards Remaining](https://www.flaticon.com/free-icon/confetti_3163797?term=star%20confetti&related_id=3163797)
- [Filter](https://iconscout.com/icon/filter-1774652)
- [Star Chat Bubble](https://thenounproject.com/search/?q=star+inside+chat+bubble&i=3774537)
- [3 Dots](https://thenounproject.com/search/?q=three+dots&i=384290)
- [Circle Checkmark](https://www.flaticon.com/premium-icon/check_3747610?term=checkmark%20in%20circle&page=1&position=18&page=1&position=18&related_id=3747610&origin=search)
- [Finger Swipe](https://www.flaticon.com/free-icon/swipe_6009248?term=finger%20swipe&page=2&position=7&page=2&position=7&related_id=6009248&origin=search)
- [Chat Message](https://www.flaticon.com/premium-icon/comment_3193061?term=chat%20message&page=1&position=13&page=1&position=13&related_id=3193061&origin=search)
- [School](https://www.flaticon.com/premium-icon/school_2602414?term=school&page=1&position=2&page=1&position=2&related_id=2602414&origin=search)
- [Points](https://www.flaticon.com/free-icon/point_4291373?term=points&page=1&position=25&page=1&position=25&related_id=4291373&origin=search)
- [Question Mark](https://thenounproject.com/search/?q=question+mark&i=178771)
- [Arrow](https://www.flaticon.com/premium-icon/next_2989988?term=arrow&page=1&position=1&page=1&position=1&related_id=2989988&origin=search)
- [Graph](https://pixabay.com/vectors/social-media-network-people-5508549/)
- [Requests Tab Bar Icon -- requires Nucleo app download](https://nucleoapp.com/premium-icons)
- [Profile Tab Bar Icon -- requires Nucleo app download](https://nucleoapp.com/premium-icons)
- [Time -- requires Nucleo app download](https://nucleoapp.com/premium-icons)