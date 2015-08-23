# Uinput::Keyboard

Ruby wrapper around uinput to create a virtual keyboard.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uinput-keyboard'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install uinput-keyboard

## Usage

```ruby
require 'uinput/keyboard'

begin
    keymap = Uinput::Keyboard.keymap(rules: 'evdev', model: 'pc104', layout: 'de', variant: 'nodeadkeys')
    keyboard = Uinput::Keyboard.new(keymap)

    sleep 1 # to give linux time to setup the new device

    # While a terminal has focus
    keyboard.type('date') # => $ date
    keyboard.tap(:Return) # => Sun Aug 23 22:57:28 CEST 2015
ensure
    keyboard.destroy if keyboard
end
```