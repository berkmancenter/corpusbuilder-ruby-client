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

  let(:headers) do
    {
      "Accept" => "application/vnd.corpus-builder-v1+json",
      "X-App-Id" => 100,
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

  before(:each)  do
    Corpusbuilder::Ruby::Api.config.api_url = "https://api.some.corpusbuilder.com"
    Corpusbuilder::Ruby::Api.config.api_version = 1
    Corpusbuilder::Ruby::Api.config.app_id= 100
    Corpusbuilder::Ruby::Api.config.token = "a"
  end

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
  end

  ### DOCUMENTS ###
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
                  }.to_json
      }
    end

    it "passes the intended headers for document creation" do
      expect(RestClient).to receive(:post).with(anything, anything, headers).and_return resp
      api.send_document(data_minimal_correct)
    end

    it "sends the required and optional params for document creation" do
      expect(RestClient).to receive(:post).with(anything, full_document_params, anything).and_return resp
      api.send_document(full_document_params)
    end

    it "requests the intended URL for document creation" do
      expect(RestClient).to receive(:post).with(Corpusbuilder::Ruby::Api.config.api_url + url, anything, anything).and_return resp
      api.send_document(data_minimal_correct)
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
      api.send_editor(full_editor_params)
    end

    it "sends the required and optional params for editor creation" do
      expect(RestClient).to receive(:post).with(anything, full_editor_params, anything).and_return resp
      api.send_editor(full_editor_params)
    end
    it "requests the intended URL for editor creation" do
      expect(RestClient).to receive(:post).with(Corpusbuilder::Ruby::Api.config.api_url + url, anything, anything).and_return resp
      api.send_editor(full_editor_params)
    end
  end
end
