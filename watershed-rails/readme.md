# Watershed Rails API

## Setup

First, make a file for your environment variables:

    touch config/initializers/_environment_variables.rb

Copy over the `database.yml` file from `config/sample/database.yml` to `config/database.yml`:

    cp config/sample/database.yml config/database.yml

Edit the `config/database.yml` file by adding your username.

If you don't have postgres installed, install it now:

    brew install postgres

Create the database using:

    rake db:create

Migrate the database:

    rake db:migrate

To seed the database, we have a rake task that loads users specifically for development purposes only.

    rake db:seed

Start the server:

    rails s

Happy developing!

