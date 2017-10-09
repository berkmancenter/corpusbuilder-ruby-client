# Pseudo-code

Some pseudo-code of how the API might look like in use

## Configuration

Reference project: an API wrapper for TSheets:
https://github.com/tsheets/api_ruby

The classes/models should use the info about the instance of CorpusBuilder
and the authentication in the background. This info should be specified in
some initializer like so:
```ruby
CorpusBuilder.config do |config|
  config.api_url = "https://api.some.corpusbuilder.com/"
  config.api_version = 1
  config.app_id = ENV["CORPUSBUILDER_APP_ID"]
  config.token = ENV["CORPUSBUILDER_TOKEN"]
end
```
Just for the record: the authentication takes place through the HTTP headers.
The API version is being specified by letting the `Accept` header the value
of e. g. `application/vnd.corpus-builder-v1+json`. The v1 in that string value
selects the version 1 of the API.

The App ID is specified with the `X-App-Id` header and the token with `X-Token`.

## Creating editors

How about having an ActiveRecord-like interface with pseudo-models
living inside the CorpusBuilder namespace / module.
```ruby
api.editors.insert(
  CorpusBuilder::Editor.new email: "test@endpoint.com",
    first_name: "Testy",
    last_name: "Tester"
)
```
The pseudo-models would include the `ActiveModel` goodies. This would
mean that we'd use features like validations and dirty-tracking.

We don't have all actions to back the full CRUD situation for all the
models. We're not sure we ought to have all of them.

## Storing images
```ruby
api.images.insert(
  CorpusBuilder::Image.new file: some_file_object,
    name: "myscan.png"
)
```
Those actions could end up with an error so a developer friendly error
should be thrown:
```ruby
begin
  api.images.insert(
    CorpusBuilder::Image.new file: some_file_object,
      name: "myscan.png"
  )
rescue CorpusBuilder::PersistanceError => e
  Rails.logger.error e.message
end
```
## Creating documents

```ruby
api.documents.insert(
  CorpusBuilder::Document.new title: "Testy document",
    images: [ image1.id, iamge2.id ]
    editor_email: "test@endpoint.com"
)
    ```
## Fetching the status of the document

```ruby
api.documents[some_id].status

# then memoize this and to get a refreshed one:

api.documents[some_id].status.reload
```

## Fetching the document tree

```ruby
# this is just a silly example but this could work this way
# here: printing the document to the console
api.documents[some_id].tree.each do |surface|
  # to pass other options to tree: tree(surface_number: 2) etc
  puts "----\nPage #{surface.number}"
  last_y = 0
  last_x = 0
  surface.graphemes.each do |grapheme|
    if grapheme.area.uly != last_y
      print "\n"
      last_y = grapheme.area.uly
    end
    print grapheme.value
    if grapheme.area.ulx - last_x > 20
      print " "
    end
    last_x = grapheme.area.ulx
  end
end
```

## Fetching the list of branches

```ruby
api.documents[some_id].branches.each do |branch|
  # enumerating branching creates an API http call
  puts branch.name
end
```

## Creating a new branch

```ruby
api.documents[some_id].branches.insert(
  CorpusBuilder::Branch.new revision: revision.id,
    editor_id: someeditor.id,
    name: "topic-branch"
)
```

## Adding corrections to the tree of the specific revision

```ruby
api.documents.correct(
  document_id: document.id
  graphemes: corrections
)
```

## Fetching the diff between two revisions

```ruby
api.documents[some_id].revisions[rev1_id].diff(other_revision: rev2.id).each do |diff_item|
  puts diff_item.value
end
```

## Merging one branch into another

```ruby
api.documents[some_id].branches['master'].merge!(other_branch: 'development')
```

