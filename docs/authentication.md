### Authentication

We're using [Devise](https://github.com/plataformatec/devise).

### Login

`POST /api/v1/users/sign_in`

Request Body:
    {
      "email":"mark@mark.com",
      "password":"password"
    }

Response:
    {
      "authentication_token":"kDz94MkMKtZH9QQ6iS-H",
      "email":"mark@mark.com"
    }

Curl command:
`curl -H "Content-Type: application/json" -d '{ "user": { "email": "mark@mark.com", "password": "password" } }' http://localhost:3000/api/v1/users/sign_in --noproxy localhost`

### Making Requests

All subsequent requests must have two pieces of information in the header, the `auth_token` and the user's `email`. The headers must be called: `X-AUTH-TOKEN` and `X-AUTH-EMAIL`

Here is an example of the sites#index request:

`GET /api/v1/sites`

Response:
    {
      "sites":[
        ...
      ]
    }

Curl command:
`curl --header "X-AUTH-TOKEN: kDz94MkMKtZH9QQ6iS-H" --header "X-AUTH-EMAIL: mark@mark.com" http://localhost:3001/api/v1/sites --noproxy localhost --get`

