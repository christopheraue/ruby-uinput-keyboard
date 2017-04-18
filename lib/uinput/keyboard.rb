require 'uinput/device'
require 'xkbcommon'

module Uinput
  class Keyboard < Device
    require_relative "keyboard/version"
    require_relative 'keyboard/initializer'

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
      symbols.flat_map do |symbol|
        symbol(symbol).keys.map do |key|
          send_event(:EV_KEY, key.scan_code, 1)
          key.code
        end.tap do
          send_event(:EV_SYN, :SYN_REPORT)
        end
      end
    end

    def release(*symbols)
      symbols.flat_map do |symbol|
        symbol(symbol).keys.map do |key|
          send_event(:EV_KEY, key.scan_code, 0)
          key.code
        end.tap do
          send_event(:EV_SYN, :SYN_REPORT)
        end
      end
    end

    def tap(*symbols)
      press(*symbols)
      release(*symbols)
    end

    def type(string)
      # prevent dropped key events (b/c of evdev buffer overflow?) by sending
      # out the event chain in chunks rather than in one piece
      keycodes = []
      string_to_symbols(string).each_slice(8) do |symbols|
        keycodes += symbols.map{ |symbol| tap(symbol) }
        sleep 0.01 # time to breath
      end
      keycodes
    end

    def symbols_to_keycodes(*names)
      names.map{ |name| symbol(name).keys.map(&:code) }
    end

    def string_to_symbols(string)
      string.chars.map{ |char| char_to_symbol(char).name }
    end

    private

    def symbol(name)
      @keymap.symbols[name.to_sym] or raise Device::Error.new("no keysym '#{name}' in keymap")
    end

    def char_to_symbol(char)
      @keymap.characters[char] or raise Device::Error.new("no character '#{char}' in keymap")
    end
  end
end
