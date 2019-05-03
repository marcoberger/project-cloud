import React from 'react';
import ReactDOM from 'react-dom';
import App from './App'

describe('Smoke testing of the App component', () => {
    it('renders without crashing', () => {
        const div = document.createElement('div');
        ReactDOM.render(<App/>, div);
    })
});
