# stdlib
require "fiddle/import"

# modules
require "glpk/problem"
require "glpk/version"

module Glpk
  class Error < StandardError; end

  class << self
    attr_accessor :ffi_lib
  end
  
  # I can't figure out how to get around this!
  if ENV["HEROKU_APP_NAME"]
    lib_directory = "/app/.apt/usr/lib/x86_64-linux-gnu"
    Fiddle.dlopen("#{lib_directory}/libsuitesparseconfig.so.5")
    Fiddle.dlopen("#{lib_directory}/libcolamd.so.2")
    Fiddle.dlopen("#{lib_directory}/libamd.so.2")
    Fiddle.dlopen("#{lib_directory}/libglpk.so.40")
  end

  lib_name =
    if Gem.win_platform?
      # TODO test
      ["glpk.dll"]
    elsif RbConfig::CONFIG["host_os"] =~ /darwin/i
      ["libglpk.dylib"]
    else
      ["libglpk.so", "libglpk.so.40"]
    end
  self.ffi_lib = lib_name
  
  # friendlier error message
  autoload :FFI, "glpk/ffi"

  def self.lib_version
    FFI.glp_version.to_s
  end

  def self.read_lp(filename)
    problem = Problem.new
    problem.read_lp(filename)
    problem
  end

  def self.read_mps(filename)
    problem = Problem.new
    problem.read_mps(filename)
    problem
  end

  def self.load_problem(**options)
    problem = Problem.new
    problem.load_problem(**options)
    problem
  end
end
