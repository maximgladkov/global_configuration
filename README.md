# Global Configuration

Global Configuration gem helps to add global configuration to your Rails 4 app.

## Installation

Add this line to your application's Gemfile:

    gem 'global_configuration'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install global_configuration
    
Finally, generate needed migrations:

    $ rake global_configuration_engine:install:migrations
    
And migrate your database:

    $ rake db:migrate
    
## Usage

### Write configuration

    GlobalConfiguration::Configuration.write(:test, 'Test string') # => true
    GlobalConfiguration::Configuration.write('test', 30.56) # => true
    
    GlobalConfiguration::Configuration.write(nil, 'Test string') # => false
    GlobalConfiguration::Configuration.write!(nil, 'Test string') # => ArgumentError 
    
    GlobalConfiguration::Configuration[:test] = 364
    
### Read configuration

    GlobalConfiguration::Configuration.read(:test)
    GlobalConfiguration::Configuration[:test]
    
### Delete configuration

    GlobalConfiguration::Configuration.delete(:test)
    GlobalConfiguration::Configuration.write(:test, nil)
    GlobalConfiguration::Configuration[:test] = nil
    
## Testing

    $ rspec