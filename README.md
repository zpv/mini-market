

<p align="center">
  <a href="https://mini-market.zhao.io/">
    <img src="http://cl.ly/f7c864167637/shop.svg" alt="Shop logo" width=72 height=72>
  </a>

  <h3 align="center">Mini-Market</h3>

  <p align="center">
    Shopify Backend Challenge 2019
    <br>
    <a href="https://mini-market.zhao.io/docs"><strong>Explore mini-market docs »</strong></a>
    <br>
    <a href="https://mini-market.zhao.io/"><strong>Demo it now »</strong></a>
  </p>
</p>

<br>

### Getting Started
To get the Rails server running locally:

1. Clone the repository
2. `bundle install` to install required dependencies
3. `rails db:migrate` to build database migrations 
4. For mock data, use `rails db:seed`
5. `rails s` to start the server
6. Visit `http://localhost:3000/` to access the demo

### Tests

1.  `cd` into the project directory
2. Run tests using `rails test`

### Usage

##### GraphQL Endpoint

Unlike a RESTFul API, mini-market has a single endpoint:

**POST** `https://mini-market.zhao.io/graphql`

Using the <a href="https://mini-market.zhao.io/"><strong>demo</strong></a> interface, you can follow executing some commands below:

#### Queries

##### Viewing Products

*Example Request:*

```graphql
{
  products(onlyAvailable: true) {
    id
    title
    price
    inventoryCount
  }
}
```

*Response:*

```graphql
{
  "data": {
    "products": [
      {
        "id": "1",
        "title": "Iron Helmet",
        "price": 79.99,
        "inventoryCount": 25
      },
      {
        "id": "2",
        "title": "Hylian Shield",
        "price": 1333.37,
        "inventoryCount": 1
      },
      {
        "id": "3",
        "title": "Leather Boots",
        "price": 16.99,
        "inventoryCount": 10
      }
    ]
  }
}
```
Argument | Type | Default  | Description 
--------- | ----------- | -------- | ----
onlyAvailable | Boolean | `false` | Show only products with available inventory 

##### Current Cart

*Example Request:*

```graphql
{
  cart {
    cartItems {
      product{
        title
      }
      price
      quantity
    }
  }
}
```

*Response:*

```graphql
{
  "data": {
    "cart": {
      "cartItems": [
        {
          "product": {
            "title": "Iron Helmet"
          },
          "price": 79.99,
          "quantity": 3
        }
      ]
    }
  }
}
```



#### Mutations

##### Adding to Cart

Similarly to how Shopify handles mutation errors, you should always be including `userErrors` in your mutation queries. Otherwise, if an error occurs, it's likely you won't see it without it.

*Example Request:*

```graphql
mutation {
  addToCart(productId: 1, quantity: 3) {
    cart{
      cartItems {
        product {
          title
        }
        price
        quantity
      }
      subtotal
    }
    userErrors {
      message
      path
    }
  }
}
```

*Response:*

```graphql
{
  "data": {
    "addToCart": {
      "cart": {
        "cartItems": [
          {
            "product": {
              "title": "Iron Helmet"
            },
            "price": 79.99,
            "quantity": 3
          }
        ],
        "subtotal": 239.97
      },
      "userErrors": []
    }
  }
}
```

| Argument  | Type    | Default | Description                        |
| --------- | ------- | ------- | ---------------------------------- |
| productId | Integer |         | Product ID of the item to be added |
| quantity  | Integer |         | Number of items to be added        |

##### Checkout Cart

Checkout the current session's cart.
You must be be logged in before performing this action.

*Example Request:*

```graphql
mutation {
  checkoutCart {
    receipt {
      receiptItems {
        price
        product {
          title
        }
        quantity
      }
      subtotal
    }
    userErrors {
      message
      path
    }
  }
}
```

*Response:*

```graphql
{
  "data": {
    "checkoutCart": {
      "receipt": {
        "receiptItems": [
          {
            "price": 79.99,
            "product": {
              "title": "Iron Helmet"
            },
            "quantity": 3
          }
        ],
        "subtotal": 239.97
      },
      "userErrors": []
    }
  }
}
```

#### Authentication

##### Creating a user

> Due to the limitations of this project, tokens are currently stored in the session. In practice, this should be avoided in favour of JWT and other stateless authentication methods.

Before you are able to checkout your cart, you must be logged in and authenticated. 

*Example Request:*

```graphql
mutation {
  createUser(name: "Steven Z.", email: "steven@zhao.io", password: "hunter2") {
    user {
      id
    }
    userErrors {
      message
      path
    }
  }
}
```

*Response:*

```graphql
{
  "data": {
    "createUser": {
      "user": {
        "id": "1"
      },
      "userErrors": []
    }
  }
}
```

##### Sign-in

Once you have an account, you must sign-in to generate an authentication token.

*Example Request:*

```graphql
mutation {
  signInUser(email: "steven@zhao.io", password: "hunter2") {
    token
  }
}
```

*Response*:

```graphql
{
  "data": {
    "signInUser": {
      "token": "TI3MuWQMvB37N/xls/CqXeTrvw==--dJwQyWh1WW+ATSIT--+eAMWr6FZxx31CQ3GqonLw=="
    }
  }
}
```

#### Final Remarks

This project was a great learning experience. I had nil experience working with Ruby/Rails nor GraphQL prior to this challenge. Takeaways:

1. Ruby is *very* idiomatic. It's simple and beautiful when it works. I spent a lot of time researching best practices before I dove in and was always surprised how readable Ruby can get. I will need to improve on this front.
2. Juggling between Rails/GraphQL types was daunting at first, but now I really appreciate how well they work together.
3. Linting saves lives! Rubocop helped guide me away from taking practices from other languages over when I first started out.