$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'bundler/setup'
require 'uinput/keyboard'

begin
  keymap = Uinput::Keyboard.keymap(rules: 'evdev', model: 'pc104', layout: 'de', variant: 'nodeadkeys')
  keyboard = Uinput::Keyboard.new(keymap)

  sleep 1

  keyboard.type('date')
  keyboard.tap(:Return)

  #keyboard.type('Ѣ')
  #('a'..'z').each{ |char| keyboard.tap(char) }
  #keyboard.tap(:UndefinedKeySym)
ensure
  keyboard.destroy if keyboard
end