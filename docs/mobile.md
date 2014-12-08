### Mobile

The mobile endpoint is hit every time the app starts up. It loads the logged in user object and the default task names.

`GET /api/v1/mobile`

Response:

    {
      "mobile": {
        "task_names": [
          ...
        ],
        "user": {
          ...
        },
      }
    }

Curl Command:

    curl --header "X-AUTH-TOKEN: kDz94MkMKtZH9QQ6iS-H" --header "X-AUTH-EMAIL: mark@mark.com" http://localhost:3001/api/v1/mobile --noproxy localhost --get

