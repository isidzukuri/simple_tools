# SimpleTools

Collection of classes which helps to organize code, increase readability and maintainability.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_tools', source: 'https://github.com/isidzukuri/simple_tools'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_tools

## Usage

* [Operation](#Operation)
* [Pub/Sub (Events)](#Pub_Sub)


### Operation
Inspired by trailblaizer operation.

Idea is to put complex task(operation) in class, split it into commands(steps) and invoke each step one by one.

```ruby
class BasicOperation < SimpleTools::Operation
  step :command_one
  step :command_two

  def command_one
    p 'run some code'
    update_context(:first_var, params[:some_value])
  end

  def command_two
    context[:first_var]
    p 'run other code'
  end
end
```
Example of calling operation:
```ruby
=> result = BasicOperation.call(some_value: 100)
# 'run some code'
# 'run other code'
=> result.success?
# true
=> result.context[:first_var]
# 100
```

`SimpleTools::Operation` respond to `.call` and can receive hash of parameters.
Inside operation to share variables between steps use `update_context(:any_key, 'any value')` setter and `context[:any_key]` getter.

`.call` returns object which respond to `.success?` and returns boolean value.

Also `.context` method is available which returns setted in operation values.

If on some step occurs error next steps will not be invoked and current call of operation is considered as failed.

```ruby
class FailedOperation < SimpleTools::Operation
  step :command_one
  step :command_with_error
  step :command_three

  def command_one
    p '1'
  end

  def command_with_error
    p '2'
    error!(:name, 'not valid message')
    # or for multiple errors:
    errors!({name: ['one more error', 'and another error']})
    p '2.1'
  end

  def command_three
    # will not run because :command_with_error has failed
    p '3'
  end
end
```
`error!`, `errors!` - add new item(s) to list of errors. It do not raise exception and dont break execution of current method.

Example of calling failed operation:
```ruby
=> result = FailedOperation.call
# 1
# 2
# 2.1
=> result.success?
# false
=> result.errors
# {name: ['error description', 'one more error', 'and another error']}
```


### Pub/Sub
Publish/subscribe messaging, or pub/sub messaging, is a form of asynchronous service-to-service communication. In a pub/sub model, any message published to a topic is immediately received by all of the subscribers to the topic. Pub/sub messaging can be used to enable event-driven architectures, or to decouple applications in order to increase performance, reliability and scalability.

```ruby
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/isidzukuri/simple_tools.
