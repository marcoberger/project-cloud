# The project-cloud backend

The project-cloud backend is a SpringBoot application. It provides two controllers - GreetingController and StarwarsCharacterController. The GreetingController returns a simple String which contains a greeting. The StarwarsCharacterController returns a randomly generated JSON, which represents a Starwars character.

Sample for Starwars character JSON
```json
{
  "id"    : 1,
  "name"  : "R2-D2",
  "jedi"  : false
}
```

## Build the application
To build the application execute the following commands from within the project root:
```bash
cd backend
./gradlew clean build
```

## Run the application
To run the application execute the following commands from within the project root:
```bash
cd backend
./gradlew build && java -jar build/libs/project-cloud-0.1.0.jar
```

## Sample requests
To send requests to the controllers and the heath check endpoint (SpringBoot actuator) use curl:
```bash
curl localhost:9000/starwars-character
curl localhost:9000/greeting
curl localhost:9001/actuator/health
```
