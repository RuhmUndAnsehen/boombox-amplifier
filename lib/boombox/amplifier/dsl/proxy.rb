# frozen_string_literal: true

#    Financial instrument library for Boombox
#    Copyright (C) 2022 RuhmUndAnsehen
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

require 'observer'

require 'boombox/amplifier/version'

module Boombox
  module DSL
    ##
    # Proxy class to redirect DSL calls.
    class Proxy < BasicObject
      ##
      # Internal helper class used to define methods on Proxy.
      class Helper < BasicObject
        attr_accessor :proxy

        def initialize(proxy)
          self.proxy = proxy
        end

        def define(method, prc)
          proxy.define_method(method) { prc.call }
        end
      end

      def call = yield(self)
    end
  end
end
