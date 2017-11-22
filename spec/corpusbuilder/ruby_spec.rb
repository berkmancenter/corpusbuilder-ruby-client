require "spec_helper"
require "active_support/all"
require "rest-client"
require "airborne"

RSpec.describe Corpusbuilder::Ruby do
  it "has a version number" do
    expect(Corpusbuilder::Ruby::VERSION).not_to be nil
  end
end

RSpec.describe Corpusbuilder::Ruby::Api, type: :request do

  before(:each)  do
    Corpusbuilder::Ruby::Api.config.api_url = "https://api.some.corpusbuilder.com"
    Corpusbuilder::Ruby::Api.config.api_version = 1
    Corpusbuilder::Ruby::Api.config.app_id= 100
    Corpusbuilder::Ruby::Api.config.token = "a"
  end

  let(:headers) do
    {
      "Accept" => "application/vnd.corpus-builder-v1+json",
      "X-App-ID" => 100,
      "X-Token" => "a"
    }
  end

  let(:data_minimal_correct) do
    {
      images: [ { id: 1 }, { id: 2 } ],
      metadata: { title: "Fancy Book" }.to_json
    }
  end

  let(:api) {Corpusbuilder::Ruby::Api.new}

  let(:resp) {double(body: {id: 1, name: 'file.tiff'}.to_json)}

  let(:document_id) {"f1d7c6c3-2560-4a09-88af-48308ec51acd"}

  let(:editor_id) { "702faf22-12e3-4bfa-8b35-a911e42f0a1b" }

  let(:revision_id) { "fa8aae14-6dcd-4860-979a-ccafa97b3881" }

  ### IMAGES ### 
  context "POST /api/images" do 
   
    let(:url) { "/api/images" }

    let(:file) {double('file', :size => 0.5.megabytes, :content_type => 'png', :original_filename => 'rails')}
    
    it "returns expected result format for an image post request" do
      allow(RestClient).to receive(:post) { resp }
      expect(api.send_image(file: file, name: 'file.tiff')).to eq({ "id" => 1, "name" => 'file.tiff' })
    end

    it "passes the intended headers for image creation" do
      expect(RestClient).to receive(:post).with(anything, { file: file, name: "test.pdf"}, headers).and_return resp
      api.send_image(file: file, name: "test.pdf")
    end

    it "makes request to the intended URL for image creation" do
      expect(RestClient).to receive(:post).with(Corpusbuilder::Ruby::Api.config.api_url + url, anything, anything).and_return resp
      api.send_image(file: file, name: "test.pdf")
    end

    it "prevents request to Corpusbuilder if the required param for image creation is missing" do
      expect(Rails.logger).to receive(:error).with("Error: You are missing the required param for creating an image, call send_image(file: your_file, name: string (optional))")
      expect(RestClient).to_not receive(:post).with(anything, anything)
      api.send_image(name: "test.pdf")
    end
  end

  ### DOCUMENTS ###
  context "GET /api/documents/" do 
    let(:url) { "/api/documents/" }

    it "requests intended URL for retrieving a document" do
      expect(RestClient).to receive(:get).with(Corpusbuilder::Ruby::Api.config.api_url + url, anything).and_return resp
      api.get_documents
    end

    it "passes the intended headers for retreiving documents" do
      expect(RestClient).to receive(:get).with(anything, headers).and_return resp
      api.get_documents
    end
  end

  context "GET /api/documents/:id" do 
    let(:url) { "/api/documents/#{document_id}" }

    it "requests intended URL for retrieving a document" do
      expect(RestClient).to receive(:get).with(Corpusbuilder::Ruby::Api.config.api_url + url, anything).and_return resp
      api.get_document(document_id)
    end

    it "passes the intended headers for retreiving a document" do
      expect(RestClient).to receive(:get).with(anything, headers).and_return resp
      api.get_document(document_id)
    end

    it "prevents requesting a document if the document id was not passed in intended format" do
      expect(Rails.logger).to receive(:error).with("Error: Did you pass get_document a document id as a UUID String?")
      expect(RestClient).to_not receive(:get).with(anything, anything)
      api.get_document(1)
    end
  end

  context "GET /api/documents/:id/status" do 
    let(:url) { "/api/documents/#{document_id}/status" }

    it "requests intended URL for retrieving document status" do
      expect(RestClient).to receive(:get).with(Corpusbuilder::Ruby::Api.config.api_url + url, anything).and_return resp
      api.get_document_status(document_id)
    end

    it "passes the intended headers for retreiving a document's status" do
      expect(RestClient).to receive(:get).with(anything, headers).and_return resp
      api.get_document_status(document_id)
    end

    it "prevents request to get document status if document id is not passed" do
      expect(Rails.logger).to receive(:error).with("Error: Did you pass get_document_status a document id as a UUID String?")
      expect(RestClient).to_not receive(:get).with(anything, anything)
      api.get_document_status(1)
    end
  end

  context "GET /api/documents/:id/branches" do 
    let(:url) { "/api/documents/#{document_id}/branches" }

    it "requests intended URL and passes document id for retrieving document branches" do
      expect(RestClient).to receive(:get).with(Corpusbuilder::Ruby::Api.config.api_url + url, anything).and_return resp
      api.get_document_branches(document_id)
    end

    it "passes the intended headers for retreiving a document's branches" do
      expect(RestClient).to receive(:get).with(anything, headers).and_return resp
      api.get_document_branches(document_id)
    end

    it "prevents request to get document branches if document id is not passed" do
      expect(Rails.logger).to receive(:error).with("Error: Did you pass get_document_branches a document id as a UUID String?")
      expect(RestClient).to_not receive(:get).with(anything, anything)
      api.get_document_branches(1)
    end
  end

  context "POST /api/documents" do 
   
    let(:url) { "/api/documents" }
  
    let(:full_document_params) do
      {
        images: [ { id: "1" }, { id: "2" } ],
        metadata: { title: "Fancy Book",
                    author: "Steve Stephens",
                    date: "2017-10-20",
                    editor: "Dave Davids",
                    license: "License A",
                    notes: "This is a note.",
                    publisher: "Will Williams"
                  }.to_json,
        editor_email: "some_editor@editors.com"
      }
    end

    it "passes the intended headers for document creation" do
      expect(RestClient).to receive(:post).with(anything, anything, headers).and_return resp
      api.create_document(full_document_params)
    end

    it "sends the required and optional params for document creation" do
      expect(RestClient).to receive(:post).with(anything, full_document_params, anything).and_return resp
      api.create_document(full_document_params)
    end

    it "requests the intended URL for document creation" do
      expect(RestClient).to receive(:post).with(Corpusbuilder::Ruby::Api.config.api_url + url, anything, anything).and_return resp
      api.create_document(full_document_params)
    end

    it "prevents requesting to create a document if the min. required params are missing" do
      expect(Rails.logger).to receive(:error).with("Error: You are missing the required param(s) for creating a document, call create_document({images: [{id: UUID string},{id: UUID string...}], metadata: {title: string, author: string (optional), date: date (optional), editor: string (optional), license: string (optional), notes: string (optional), publisher: string (optional)}, editor_email: string})")
      expect(RestClient).to_not receive(:post).with(anything, anything, anything)
      api.create_document(data_minimal_correct)
    end
  end

  context "POST /api/documents/:id/branches" do 
    let(:url) { "/api/documents/#{document_id}/branches" }
    let(:headers) do
      {
        "Accept" => "application/vnd.corpus-builder-v1+json",
        "X-App-ID" => 100,
        "X-Token" => "a",
        "X-Editor-Id" => "702faf22-12e3-4bfa-8b35-a911e42f0a1b"
      }
    end

    let(:params) do 
      { revision: "master",
        name: "development"
      }
    end


    it "posts to the intended URL and passes document id for creating document branches" do
      expect(RestClient).to receive(:post).with(Corpusbuilder::Ruby::Api.config.api_url + url, anything, anything).and_return resp
      api.create_document_branch(document_id, editor_id, params)
    end

    it "sends the required params for document branch creation" do
      expect(RestClient).to receive(:post).with(anything, params, anything).and_return resp
      api.create_document_branch(document_id, editor_id, params)
    end

    it "passes the intended headers for creating a document branch" do
      expect(RestClient).to receive(:post).with(anything, anything, headers).and_return resp
      api.create_document_branch(document_id, editor_id, params)
    end

    it "prevents making a request to create a document branch unless the required params are sent" do
      expect(Rails.logger).to receive(:error).with("Error: You are missing the required param(s) to create a document branch, call create_document_branch(document_id, editor_id, revision: string, name: string)")
      expect(RestClient).to_not receive(:post).with(anything, anything, anything)
      api.create_document_branch(document_id, editor_id, name: "test.pdf")
    end
  end

  context "PUT /api/documents/:id/:branch/merge" do
    let(:branch) {"master"}
    let(:url) { "/api/documents/#{document_id}/#{branch}/merge" }
    let(:params) do
      { other_branch: "development"}
    end

    it "puts to the intended URL and passes a document id for merging a document's branches" do
      expect(RestClient).to receive(:put).with(Corpusbuilder::Ruby::Api.config.api_url + url, anything, anything).and_return resp
      api.merge_document_branches(document_id, branch, params)
    end

    it "sends the required params for merging branches" do
      expect(RestClient).to receive(:put).with(anything, params, anything).and_return resp
      api.merge_document_branches(document_id, branch, params)
    end

    it "passes the intended headers for merging branches" do
      expect(RestClient).to receive(:put).with(anything, anything, headers).and_return resp
      api.merge_document_branches(document_id, branch, params)
    end

    it "prevents request to Corpusbuilder if the required param(s) for merging a document's branch are missing" do
      expect(Rails.logger).to receive(:error).with("Error: You are missing the required param to merge a document branch, call merge_document_branch(document_id, branch (string), other_branch: string)")
      expect(RestClient).to_not receive(:put).with(anything, anything, anything)
      api.merge_document_branches(document_id, branch, 1)
    end
  end

  context "Get /api/documents/:id/:revision/tree" do
    let(:url) { "/api/documents/#{document_id}/#{revision_id}/tree" }
    let(:optional_params) do
      {
        surface_number: 1,
        area: { ulx: 2,
                uly: 3,
                lrx: 4,
                lry: 5
              }
      }
    end

    it "requests the intended URL to get a revision tree" do
      expect(RestClient).to receive(:get).with(Corpusbuilder::Ruby::Api.config.api_url + url, anything).and_return resp
      api.get_document_revision_tree(document_id, revision_id)
    end

    #Merging the params into the headers is related to a RestClient bug, see RestClient issue 397
    it "sends the optional params to get a revision tree" do
      expect(RestClient).to receive(:get).with(anything, headers.merge!(:params => optional_params)).and_return resp
      api.get_document_revision_tree(document_id, revision_id, optional_params)
    end

    #Merging the params into the headers is related to a RestClient bug, see RestClient issue 397
    it "passes the intended headers to get a revision tree" do
      expect(RestClient).to receive(:get).with(anything, headers.merge!(:params => {})).and_return resp
      api.get_document_revision_tree(document_id, revision_id)
    end
  end

  context "Get /api/documents/:id/:revision/diff" do
    let(:url) { "/api/documents/#{document_id}/#{revision_id}/diff" }
    let(:optional_param) do
      { other_revision: "version_two"}
    end

    it "requests the intended URL to get a revision diff" do
      expect(RestClient).to receive(:get).with(Corpusbuilder::Ruby::Api.config.api_url + url, anything).and_return resp
      api.get_document_revision_diff(document_id, revision_id)
    end

    #Merging the params into the headers is related to a RestClient bug, see RestClient issue 397
    it "sends the optional params to get a revision diff" do
      expect(RestClient).to receive(:get).with(anything, headers.merge!(:params => optional_param)).and_return resp
      api.get_document_revision_diff(document_id, revision_id, optional_param)
    end

    #Merging the params into the headers is related to a RestClient bug, see RestClient issue 397
    it "passes the intended headers to get a revision diff" do
      expect(RestClient).to receive(:get).with(anything, headers.merge!(:params => {})).and_return resp
      api.get_document_revision_diff(document_id, revision_id)
    end
  end

  context "PUT /api/documents/:id/:revision/tree" do
    let(:url) { "/api/documents/#{document_id}/#{revision_id}/tree" }
    let(:params) do
      { graphemes: [ id: "zxcxzc",
                  value: "qwewqe",
         surface_number: 1,
                 delete: false,
                   area: { ulx: "abc",
                           uly: "def",
                           lrx: "ghi",
                           lry: "jkl"
                         }
                   ]
      }
    end

    it "requests the intended URL to add corrections to a given revision" do
      expect(RestClient).to receive(:put).with(Corpusbuilder::Ruby::Api.config.api_url + url,
                                               anything,
                                               anything).and_return resp
      api.update_document_revision(document_id, revision_id, params)
    end

    it "passess the required optional params to add corrections to a given revision" do
      expect(RestClient).to receive(:put).with(anything, params, anything).and_return resp
      api.update_document_revision(document_id, revision_id, params)
    end

    it "passes the intended headers to add corrections to a given revision" do
      expect(RestClient).to receive(:put).with(anything, anything, headers).and_return resp
      api.update_document_revision(document_id, revision_id, params)
    end

    it "prevents requests to Corpusbuilder if the required param(s) for updating a document's revision are missing" do
      expect(Rails.logger).to receive(:error).with("Error: You are missing the required param(s) to add a correction to a given revision, call update_document_revision(document_id, revision_id (string), graphemes: [id: string (optional), value: string (optional), surface_number: int (optional), delete: bool (optional), area (optional): {ulx: string, uly: string, lrx: string, lry: string}])")
      expect(RestClient).to_not receive(:put).with(anything, anything, anything)
      api.update_document_revision(document_id, revision_id, 1)
    end

  end
  ### EDITORS ### 
  context "POST /api/editors" do 
   
    let(:url) { "/api/editors" }

    let(:full_editor_params) do
      {
        email: "editor@test.com",
        first_name: "Steve",
        last_name: "Stephenson"
      }
    end

    it "passes the intended headers for editor creation" do
      expect(RestClient).to receive(:post).with(anything, anything, headers).and_return resp
      api.create_editor(full_editor_params)
    end

    it "sends the required and optional params for editor creation" do
      expect(RestClient).to receive(:post).with(anything, full_editor_params, anything).and_return resp
      api.create_editor(full_editor_params)
    end

    it "requests the intended URL for editor creation" do
      expect(RestClient).to receive(:post).with(Corpusbuilder::Ruby::Api.config.api_url + url, anything, anything).and_return resp
      api.create_editor(full_editor_params)
    end

    it "prevetns requests to Corpusbuilder for editor creation if the required param is not passed" do
      expect(Rails.logger).to receive(:error).with("Error: You are missing the required param to create an editor, call create_editor(email: string, first_name: string (optional), last_name: string (optional))")
      expect(RestClient).to_not receive(:post).with(anything, anything)
      api.create_editor("This is does not send a required param")
    end
  end
end
