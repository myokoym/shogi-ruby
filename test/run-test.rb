#!/usr/bin/env ruby

require "test-unit"
require "test/unit/notify"
require "test/unit/rr"

base_dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))
$LOAD_PATH.unshift(File.join(base_dir, "lib"))
$LOAD_PATH.unshift(File.join(base_dir, "test"))

exit Test::Unit::AutoRunner.run(true)
