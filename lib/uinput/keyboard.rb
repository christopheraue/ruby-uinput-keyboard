require 'bundler/setup'
require 'uinput/device'
require 'xkbcommon'
require "uinput/keyboard/version"
require 'uinput/keyboard/system_initializer'

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
      symbols_to_keys(*symbols).each do |key|
        send_event(:EV_KEY, key.scan_code, 1)
      end
      send_event(:EV_SYN, :SYN_REPORT)
    end

    def release(*symbols)
      symbols_to_keys(*symbols).each do |key|
        send_event(:EV_KEY, key.scan_code, 0)
      end
      send_event(:EV_SYN, :SYN_REPORT)
    end

    def tap(*symbols)
      press(*symbols)
      release(*symbols)
    end

    def type(string)
      # prevent dropped key events (b/c of evdev buffer overflow?) by sending
      # out the event chain in chunks rather than in one piece
      string_to_symbols(string).each_slice(8) do |symbols|
        symbols.each{ |symbol| tap(symbol) }
        sleep 0.01 # time to breath
      end
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
