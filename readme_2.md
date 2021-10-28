<div id="top"></div>

-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />

<h3 align="center">Rails Engine</h3>

  <p align="center">
    API for fetching information about Merchants, Items, and Invoices
modeled off of the back-end functionality for a large product
distribution center.
    <br />
    <a href="https://github.com/TannerDale/rails-engine"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/TannerDale/rails-engine">View Demo</a>
    ·
    <a href="https://github.com/TannerDale/rails-engine/issues">Report Bug</a>
    ·
    <a href="https://github.com/TannerDale/rails-engine/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

<p align="right">(<a href="#top">back to top</a>)</p>


### Built With

* [Ruby on Rails](https://rubyonrails.org/) 5.2.6
* [Ruby](https://www.ruby-lang.org/en/) 2.7.2
* [PostgreSQL](https://www.postgresql.org/)
* [RSpec](https://rspec.info/)
* [SimpleCov](https://github.com/simplecov-ruby/simplecov)
* [JSONAPI](https://github.com/jsonapi-serializer/jsonapi-serializer)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/TannerDale/rails-engine.git
   ```
2. Install gem packages
   ```sh
   bundle install
   ```
3. Set up your database
   ```sh
   rails db:{create,seed}
   rails db:schema:dump
   ```

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## V1 Endpoints

### Merchants
  - `/merchants` - get, valid paramaters: `per_page=<integer>`, `page=<integer>`
  - `/merchants/:id` - get
  - `/merchants/:id/items` - get

### Items
  - `/items` - get, valid paramaters: `per_page=<integer>`, `page=<integer>`
  - `/items/:id` - get, post, patch, delete
  - `/items/:id/merchant` - get

### Item, Merchants Searching
  - `/merchants/find` - get, valid paramaters: `name=<string>`
  - `/merchants/find_all` - get, valid paramaters: `name=<string>`
  - `/merchants/most_items` - get
  - `/items/find` - get, valid paramaters: `name=<string>` OR `min_price=<float>`, `max_price=<float>`
  - `/items/find_all` - get, valid paramaters: `name=<string>` OR `min_price=<float>`, `max_price=<float>`

### Revenue Details
  - `/revenue` - get, valid parameters: `start=<YYYY-MM-DD>`, `end=<YYYY-MM-DD>`
  - `/revenue/items` - get, valid parameters: `quantity=<integer>`
  - `/revenue/weekly` - get
  - `/revenu/merchants` - get, valid parameters: `qauntity=<integer>`
  - `/revenue/unshipped` - get, valid parameters: `qauntity=<integer>`
  - `/revenue/merchants/:merchant_id`

<p align="right">(<a href="#top">back to top</a>)</p>

## Example Responses

`GET v1/items?per_page=2`
```json
{
  "data": [
    {
      "id": "1",
        "type": "merchant",
        "attributes": {
          "name": "Mike's Awesome Store",
        }
    },
    {
      "id": "2",
      "type": "merchant",
      "attributes": {
        "name": "Store of Fate",
      }
    }
  ]
}
```
`GET /v1/merchants/1`
```json
{
  "data": {
    "id": "1",
    "type": "item",
    "attributes": {
      "name": "Super Widget",
      "description": "A most excellent widget of the finest crafting",
      "unit_price": 109.99
    }
  }
}
```
`GET /api/v1/revenue?start=2012-03-09&end=2012-03-24`
```json
{
  "data": {
    "id": null,
    "attributes": {
      "revenue"  : 43201227.8000003
    }
  }
}
```

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Tanner Dale  - tanner@tannerdale.com

Project Link: [https://github.com/TannerDale/rails-engine](https://github.com/TannerDale/rails-engine)

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/TannerDale/rails-engine.svg?style=for-the-badge
[contributors-url]: https://github.com/TannerDale/rails-engine/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/TannerDale/rails-engine.svg?style=for-the-badge
[forks-url]: https://github.com/TannerDale/rails-engine/network/members
[stars-shield]: https://img.shields.io/github/stars/TannerDale/rails-engine.svg?style=for-the-badge
[stars-url]: https://github.com/TannerDale/rails-engine/stargazers
[issues-shield]: https://img.shields.io/github/issues/TannerDale/rails-engine.svg?style=for-the-badge
[issues-url]: https://github.com/TannerDale/rails-engine/issues
[license-shield]: https://img.shields.io/github/license/TannerDale/rails-engine.svg?style=for-the-badge
[license-url]: https://github.com/TannerDale/rails-engine/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/TannerDale
