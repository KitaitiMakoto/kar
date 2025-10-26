Kar
===

Useful Rake tasks.

Installation
------------

Install the gem and add to the application's Gemfile by executing:

    $ bundle add kar

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install kar

Usage
-----

    # Rakefile
    require "kar/dsl"

### Download task ###

It downloads a file and declares file task.
    
    download "local/path/to/file" => "https://example.net/remote/path/to/file"

### Multiple files task ###

It declares multiple file tasks at a time.

    # Rakefile
    FILES = FileList["fileA", "fileB", "fileC"]
    files FILES

### Cargo task ###

It declares a cargo task which builds extensions in Rust.

    # Rakefile
    cargo "my_gem"

Run the task:

    % rake cargo

And cargo:check task which checks Rust source files and is useful for dependency of build task.

    # Rakefile
    task build: "cargo:check"

Run the task:

    % rake build # invokes cargo:checks

Development
-----------

To install this gem onto your local machine, run `rake install`. To release a new version, update the version number in `kar.gemspec`, and then run `rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Contributing
------------

Bug reports and pull requests are welcome on GitHub at https://gitlab.com/KitaitiMakoto/kar. This project is intended to be a safe, welcoming space for collaboration.
