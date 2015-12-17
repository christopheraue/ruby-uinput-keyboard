$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'uinput/keyboard'

begin
  keymap = Uinput::Keyboard.keymap(rules: 'evdev', model: 'pc104', layout: 'de', variant: 'nodeadkeys')
  keyboard = Uinput::Keyboard.new(keymap)

  sleep 1

  puts keyboard.sys_path
  puts keyboard.dev_path

  keyboard.type('date')
  keyboard.tap(:Return)

  #keyboard.type('Ѣ')
  #('a'..'z').each{ |char| keyboard.tap(char) }
  #keyboard.tap(:UndefinedKeySym)
ensure
  keyboard.destroy if keyboard
end