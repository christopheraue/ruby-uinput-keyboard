require 'uinput/device'
require "uinput/keyboard/version"
require 'uinput/keyboard/factory'

module Uinput
  class Keyboard < Device
    def press(keys)
      keys.split('+').each{ |key| send_key_event(key, state: 1) }
      send_syn_event
    end

    def release(keys)
      keys.split('+').each{ |key| send_key_event(key, state: 0) }
      send_syn_event
    end

    def tap(keys)
      press(keys)
      release(keys)
    end

    def type(text)
      text.chars.each do |char|
        keys_to_produce(char)
      end
    end

    def send_key_event(key, state: 1)
      send_event(EV_KEY, key_code(key), state)
    end

    def keymap
      # Todo: get the currently active keymap, not system's default
      @keymap ||= Xkbcommon::Context.new.default_keymap
    end

    private

    ALIASES = {
      ctrl: :leftctrl,
      shift: :leftshift,
      alt: :leftalt
    }

    def alias_for(key)
      ALIASES[key.downcase.to_sym] || key
    end

    def key_code(key)
      Uinput.const_get("KEY_#{alias_for(key).upcase}")
    end
  end
end
