require "spec_helper"

feature "Add migrations to the project" do
  scenario "when users table does not exist" do
    create_clearance_project
    install_dependencies
    generate_clearance
  end

  scenario "when users table without clearance fields exists" do
    create_clearance_project
    install_dependencies
    And I create a simple user model
    And I add an existing user
    generate_clearance
  end

  scenario "when users table with clearance fields exists" do
    create_clearance_project
    install_dependencies
    And I create a migration with clearance fields
    And I successfully run `bundle exec rake db:migrate`
    generate_clearance
  end


  def create_clearance_project
    Dir.chdir(tmp_path) do
      Bundler.with_clean_env do
        ENV['TESTING'] = '1'
        %x(bundle exec rails new testapp --skip-bundle --skip-javascript --skip-sprockets)
      end
    end
  end

  def install_dependencies
    Dir.chdir(tmp_path) do
      Bundler.with_clean_env do
        ENV['TESTING'] = '1'
        %x(bundle install --local)
      end
    end
  end

  def generate_clearance
    Dir.chdir(tmp_path) do
      Bundler.with_clean_env do
        ENV['TESTING'] = '1'
        %x(bundle exec rails generate clearance:install)
      end
    end
  end

  def tmp_path
    @tmp_path ||= Pathname.new("#{root_path}/tmp")
  end
end
