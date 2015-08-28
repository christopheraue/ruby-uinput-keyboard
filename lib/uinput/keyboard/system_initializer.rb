module Uinput
  class Keyboard < Device
    class SystemInitializer < Device::SystemInitializer
      def initialize(keyboard, &block)
        @keyboard = keyboard
        super(keyboard, &block)
        add_event(:EV_KEY)
        add_event(:EV_SYN)
        add_all_keys
      end

      def add_all_keys
        @keyboard.keymap.keys.map(&:scan_code).each{ |key| add_key(key) }
      end
    end
  end
end