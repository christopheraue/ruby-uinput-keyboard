# Uinput::Keyboard

Ruby wrapper around uinput to create a virtual keyboard from an xkb keymap.

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

    # While pasting this code into irb
    keyboard.type('Time.now')   # types 'Time.now'
    keyboard.tap(:Return)       # presses the Return key and returns the timestamp
ensure
    keyboard.destroy if keyboard
end
```