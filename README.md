# Shopping Alerts Api
JSON api that can take an Amazon URL and parse out the product info, including price. Creates an alert that will notify users when the price changes.

```ruby
bundle install
bundle exec rails s
```

### Prerequisites
Create a `.env` file in the root directory with the following vars:
```sh
DATABASE_NAME=[your database name]
DATABASE_IP=[your database ip]
DEVISE_JWT_SECRET_KEY=[secret]
```
You can see an example in `.env.sample`
