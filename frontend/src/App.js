import React, { Component } from 'react'
import './assets/css/main.css'
import Trooper from './images/stormtrooper.jpg'

import axios from 'axios'


class App extends Component {
    constructor(props) {
        super(props);
        this.state = {
            bootstrap: {
                greeting: ''
            },
            character: ''
        };

        this.handleClick = this.handleClick.bind(this);
    }

    componentDidMount() {
        let bootstrap = Object.assign({}, this.state.bootstrap);
        axios.get('/greeting')
            .then(
                response => {
                    bootstrap['greeting'] = response.data;
                    this.setState({bootstrap})
                },
                error => {
                    bootstrap['greeting'] = 'Something went wrong: ' + error.message;
                    this.setState({bootstrap})
                }
            )
    }

    render() {
        return (
            <div className="App">
                <div id="wrapper" className="divided">

                    <section className="banner style1 orient-left content-align-left image-position-right fullscreen onload-image-fade-in onload-content-fade-right">
                        <div className="content">
                            <h1>May the force be with you</h1>
                            <p className="major">{this.state.bootstrap.greeting}</p>
                            <ul className="actions stacked">
                                <li><a href="#first" className="button big wide smooth-scroll-middle" onClick={this.handleClick}>Get character</a></li>
                            </ul>
                            <p className="major">{this.state.character}</p>
                        </div>
                        <div className="image">
                            <img src={Trooper} alt="" />
                        </div>
                    </section>



                    <footer className="wrapper style1 align-center">
                        <div className="inner">
                            <p><a href="https://blog.codecentric.de">codecentric Blog</a></p>
                        </div>
                    </footer>

                </div>
            </div>
        )
    }

    handleClick () {
        axios.get('/starwars-character')
            .then(response => this.setState({character: response.data.name}))
    }
}

export default App
