# Corpusbuilder::Ruby

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/corpusbuilder/ruby`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'corpusbuilder-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install corpusbuilder-ruby

## Usage
Mount the Gem's routes in the host application:
* mount Corpusbuilder::Ruby::Engine, at: "/corpusbuilder"

Add some information to a configuration file (after application is initialized):
### Note that for setting the api_ul, trailing slashes are not valid ("http://yourwebsite.com/")
* Corpusbuilder::Ruby::Api.config.api_url = "http://yourwebsite.com"
* Corpusbuilder::Ruby::Api.config.api_version = 1
* Corpusbuilder::Ruby::Api.config.app_id = "your app id"
* Corpusbuilder::Ruby::Api.config.token = "your token"

Create a Corpusbuilder::Ruby::Api instance
* $ api = Corpusbuilder::Ruby::Api.new

* api.send_image(params) = Makes request to /api/images
  where params = {file: file, name: string} 
* api.create_editor(params) = Makes request to /api/editor
  where params = {email: string, first_name: string, last_name: string}

* api.create_document(params) = Makes request to /api/documents
  where params = {images: [{id: UUID string},{id: UUID string}], metadata: {title: string, author: string, date: date, editor: string, license: string, notes: string, publisher: string}, editor_email: string}
* api.get_document_status(document_id) = Makes request to /api/documents/:id/status
* api.get_document_branches(document_id) = Makes request to /api/documents/:id/branches
* api.get_document(document_id) = Makes request to /api/documents
* api.get_documents = Makes request to /api/documents

* api.create_document_branch(document_id, editor_id, {"revision":"your_current_branch", "name":"your_new_branch"}) = Makes request to /api/documents/:id/branches 
* api.merge_document_branches(document_id, current_branch_name, {"other_branch":"your_other_branch"}) = Makes request to /api/documents/:id/:branch/merge
* api.get_document_revision_tree(document_id, revision_id or branch name, optional params)
  where optional_params = {surface_number: int, area: {ulx: int, uly: int, lrx: int, lry: int}}
* api.get_document_revision_diff(document_id, revision_id, optional params)
  where optional_params = {other_revision: string}}
* api.update_document_revision(document_id, revision_id, optional params)
  where optional_params = { graphemes: [ id: string,
                                value: string,
                       surface_number: int,
                               delete: boolean,
                                 area: { ulx: string,
                                         uly: string,
                                         lrx: string,
                                         lry: string
                                       }
                                 ]
                          } 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/berkmancenter/corpusbuilder-ruby-client.

## License

CorpusBuilder is licensed under the GNU AGPL 3.0 License.

## Copyright

2019 President and Fellows of Harvard College.
