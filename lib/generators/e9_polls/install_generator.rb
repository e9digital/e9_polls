require 'rails/generators'
require 'rails/generators/migration'

module E9Polls
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      def self.source_root
        File.join(File.dirname(__FILE__), 'templates')
      end
       
      def self.next_migration_number(dirname) #:nodoc:
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end

      def create_migration
        migration_template 'migration.rb', 'db/migrate/create_e9_polls.rb'
      end

      def copy_over_files
        copy_file 'initializer.rb', 'config/initializers/e9_polls.rb'
        copy_file 'javascript.js',  'public/javascripts/e9_polls.js'
        copy_file 'stylesheet.css', 'public/stylesheets/e9_polls.css'
      end
    end
  end
end
