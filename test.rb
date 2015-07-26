$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'bundler/setup'
require 'uinput/keyboard'

begin
  keymap = Uinput::Keyboard.keymap(rules: 'evdev', model: 'pc104', layout: 'de', variant: 'nodeadkeys')
  keyboard = Uinput::Keyboard.new(keymap)

  sleep 1

  keyboard.type('ö ü ä')
  #('a'..'z').each{ |char| keyboard.tap(char) }
  keyboard.tap(:Return)
ensure
  keyboard.destroy if keyboard
end