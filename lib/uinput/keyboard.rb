require 'uinput/device'
require 'xkbcommon'
require "uinput/keyboard/version"
require 'uinput/keyboard/factory'

module Uinput
  class Keyboard < Device
    class << self
      def keymap(names)
        Xkbcommon::Context.new.keymap_from_names(names)
      end
    end

    def initialize(keymap, &block)
      @keymap = keymap
      super(&block)
    end

    attr_accessor :keymap

    def press(*symbols)
      symbols_to_keys(*symbols).each{ |key| send_key_event(key.scan_code, state: 1) }
      send_syn_event
    end

    def release(*symbols)
      symbols_to_keys(*symbols).each{ |key| send_key_event(key.scan_code, state: 0) }
      send_syn_event
    end

    def tap(*symbols)
      press(*symbols)
      release(*symbols)
    end

    def type(string)
      string_to_symbols(string).each{ |symbols| tap(*symbols) }
    end

    def send_key_event(scan_code, state: 1)
      send_event(EV_KEY, scan_code, state)
    end

    private

    def symbols_to_keys(*names)
      [*names].flat_map{ |name| symbol(name).keys }
    end

    def string_to_symbols(string)
      string.chars.map{ |char| char_to_symbol(char).name }
    end

    def symbol(name)
      @keymap.symbols[name.to_sym] or raise Device::Error.new("no keysym '#{name}' in keymap")
    end

    def char_to_symbol(char)
      @keymap.characters[char] or raise Device::Error.new("no character '#{char}' in keymap")
    end
  end
end
