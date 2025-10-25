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
    
    download "local/path/to/file" => "https://example.net/remote/path/to/file"
    FILES = FileList["fileA", "fileB", "fileC"]
    files FILES
    cargo "my_gem"

Development
-----------

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Contributing
------------

Bug reports and pull requests are welcome on GitHub at https://gitlab.com/KitaitiMakoto/kar. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://gitlab.com/KitaitiMakoto/kar/blob/main/CODE_OF_CONDUCT.md).

Code of Conduct
---------------

Everyone interacting in the Kar project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://gitlab.com/KitaitiMakoto/kar/blob/main/CODE_OF_CONDUCT.md).
