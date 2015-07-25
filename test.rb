$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'bundler/setup'
require 'uinput/keyboard'

begin
  keyboard = Uinput::Keyboard.create
  sleep 1
  ('a'..'z').each{ |char| keyboard.tap(char) }
ensure
  keyboard.destroy if keyboard
end