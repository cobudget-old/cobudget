module Playhouse
  class Loader
    class CalledOutsideOFModuleException < Exception; end

    def self.check_module caller
      if caller.class.name == 'Object'
        raise CalledOutsideOFModuleException
      end
    end

    def self.require_files caller, folder, file_names
      file_names.each do |file_name|
        require "#{caller.name.downcase}/#{folder}/#{file_name}"
      end
    end
  end
end

def entities *params
  Playhouse::Loader.check_module self
  Playhouse::Loader.require_files self, 'entities', params
end

def roles *params
  Playhouse::Loader::check_module self
  Playhouse::Loader.require_files self, 'roles', params
end

def composers *params
  Playhouse::Loader::check_module self
  Playhouse::Loader.require_files self, 'composers', params
end

def role role_name
  roles role_name
end

def entity entity_name
  entities entity_name
end

def composer composer_name
  composers composer_name
end
