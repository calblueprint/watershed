### Site

### Index

`GET /api/v1/sites`

Response:

    {
      "sites":[
        ...
      ]
    }

Curl command:
`curl --header "X-AUTH-TOKEN: kDz94MkMKtZH9QQ6iS-H" --header "X-AUTH-EMAIL: mark@mark.com" http://localhost:3001/api/v1/sites --noproxy localhost --get`

### Create

`POST /api/v1/sites`

Request Body:

    {
      "site": {
        "name": "Test API Site",
        "description": "Lorem Ipsum",
        "street": "42 Wallaby Way",
        "city": "Berkeley",
        "state": "CA",
        "zip_code": 11111,
        "latitude": 100.101,
        "longitude": 101.1001
      }
    }

Response:

    {
      "site": {
        ...
      }
    }

Curl Command:
`curl -H "Content-type: application/json" --header "X-AUTH-TOKEN: kDz94MkMKtZH9QQ6iS-H" --header "X-AUTH-EMAIL: mark@mark.com" -d '{"site" : { "name": "API Site" } }' http://localhost:3001/api/v1/sites --noproxy localhost`

### Update

`PATCH /api/v1/sites/<site_id>`

Request Body:

    {
      "site": {
        "name": "Test API Site",
        "description": "Lorem Ipsum",
        "street": "42 Wallaby Way",
        "city": "Berkeley",
        "state": "CA",
        "zip_code": 11111,
        "latitude": 100.101,
        "longitude": 101.1001
      }
    }

Response:

    {
      "site": {
        ...
      }
    }

Curl Command:
`curl -H "Content-type: application/json" --header "X-AUTH-TOKEN: kDz94MkMKtZH9QQ6iS-H" --header "X-AUTH-EMAIL: mark@mark.com" -d '{"site" : { "name": "API Site2" } }' http://localhost:3001/api/v1/sites/1 --noproxy localhost --request PATCH`

