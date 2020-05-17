# The project-cloud frontend

The project-cloud frontend is a React Single Page-Application that was bootstrapped with [Create React App](https://github.com/facebook/create-react-app). It renders a single page with a button. When clicking the button, a simple request is send to the backend, which returns a sample Star Wars character. The frontend renders the name of the character.

## Prerequisites
- watchman (brew install watchman)


## Build the application
To install dependencies and build the application execute the following commands from within the project root:
```bash
cd frontend
yarn install
yarn build
```

## Run the tests
To run the tests execute the following commands from within the project root. This will start the smoke tests in watch mode.
```bash
cd frontend
yarn test
```

## Run the application
To run the application execute the following commands from within the project root. Make sure you have started the backend first. This code sample does not include a mock backend server. 
```bash
cd frontend
yarn start
```
