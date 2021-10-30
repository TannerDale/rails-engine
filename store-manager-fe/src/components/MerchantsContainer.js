import React, { Component } from 'react'

class MerchantsContainer extends Component {
  render() {
    return (
      <div>
        <div className="inputContainer">
          <input className="merchantInput" type="text" placeholder="Merchant Name" maxLength="50" />
        </div>
        <div className="merchantWrapper">
          <ul className="merchantList">
          </ul>
        </div>
      </div>
    )
  }
}

export default MerchantsContainer
