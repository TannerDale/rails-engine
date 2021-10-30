import React, { Component } from 'react';
import './App.css';
import MerchantsContainer from './components/merchantsContainer'

class App extends Component {
  render() {
    return (
      <div className="container">
        <div className="header">
          <h1>Merchant Search</h1>
        </div>
        <MerchantsContainer />
      </div>
    );
  }
}

export default App;
