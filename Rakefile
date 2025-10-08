# frozen_string_literal: true

require "hanami/rake_tasks"

namespace :tailwind do
  desc "Compile your Tailwind CSS"
  task :compile do
    system "bin/tailwind"
  end

  desc "Watch and compile your Tailwind CSS on file changes"
  task :watch do
    system "bin/tailwind --watch"
  end
end
