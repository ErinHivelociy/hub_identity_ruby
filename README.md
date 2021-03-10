# HubIdentityRuby
A Rails Engine designed to make implementing HubIdentity authentication easy and fast.
In order to use this package you need to have an account with [HubIdentity](https://stage-identity.hubsynch.com/)

Currently this is only for [Hivelocity](https://www.hivelocity.co.jp/) uses. If you have a
commercial interest please contact the Package Manager Erin Boeger through linkedIn or Github or
through [Hivelocity](https://www.hivelocity.co.jp/contact/).

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'hub_identity_ruby'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install hub_identity_ruby
```

inside your ApplicationController:
```ruby
include HubIdentityRuby::ControllerHelpers
```

inside your routes.rb mount the HubIdentity routes.
```ruby
mount HubIdentityRuby::Engine => "/hub_identity_ruby"
```
This will add the following routes to your application:
- sessions_new GET    /sessions/new(.:format)     hub_identity_ruby/sessions#new
- sessions_create GET    /sessions/create(.:format)  hub_identity_ruby/sessions#create
- sessions_destroy DELETE /sessions/destroy(.:format) hub_identity_ruby/sessions#destroy


## Environmental Variables
set your public and private keys and HubIdentity url
```bash
HUBIDENTITY_PRIVATE_KEY="a private key from HubIdentity website"
HUBIDENTITY_PUBLIC_KEY="a public key from HubIdentity website"
HUBIDENTITY_URL="for production deployment defaults to staging server"
```

Currently the HUBIDENTITY_URL defaults to staging HubIdentity server.

## Restricted routes

For authentication required (restricted) routes add the `before_action` helpers.
for example:

```ruby
before_action :authenticate_user!, only: [:page_1, :page_2]
before_action :set_current_user
```
use the `before_action :authenticate_user!` to restrict routes and require a user to authenticate.
use the `before_action :set_current_user` helper to have an `@current_user` in your views to help with navigation.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
