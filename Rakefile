# frozen_string_literal: true

require "hanami/rake_tasks"

# Add your custom rake tasks to the lib/tasks directory
Rake.add_rakelib "lib/tasks"

namespace :tailwind do
  desc "Compile your Tailwind CSS"
  task :compile do
    system(
      "npx",
      "tailwindcss",
      "--input", "app/assets/css/tailwind.css",
      "--output", "app/assets/builds/tailwind.css",
      "--minify"
    )
  end

  desc "Watch and compile your Tailwind CSS on file changes"
  task :watch do
    system(
      "npx",
      "tailwindcss",
      "--input", "app/assets/css/tailwind.css",
      "--output", "app/assets/builds/tailwind.css",
      "--minify",
      "--watch"
    )
  end
end
