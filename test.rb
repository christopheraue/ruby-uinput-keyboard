require_relative 'lib/uinput/keyboard'

begin
  keymap = Uinput::Keyboard.keymap(rules: 'evdev', model: 'pc104', layout: 'de', variant: 'nodeadkeys')
  keyboard = Uinput::Keyboard.new(keymap)

  puts keyboard.sys_path
  puts keyboard.dev_path

  symbols = keyboard.string_to_symbols('DaTe!')
  puts symbols.inspect
  puts keyboard.symbols_to_keycodes(*symbols).inspect

  sleep 0.1 # the window manager needs some time to register the new keyboard

  keyboard.type('date')
  keyboard.tap(:Return)

  #keyboard.type('Ѣ')
  #('a'..'z').each{ |char| keyboard.tap(char) }
  #keyboard.tap(:UndefinedKeySym)
ensure
  keyboard.destroy if keyboard
end