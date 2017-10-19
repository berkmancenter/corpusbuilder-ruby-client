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

  context "POST /api/documents" do 
    before(:each)  do
      Corpusbuilder::Ruby::Api.config.api_url = "https://api.some.corpusbuilder.com"
      Corpusbuilder::Ruby::Api.config.api_version = 1
      Corpusbuilder::Ruby::Api.config.app_id= 100
      Corpusbuilder::Ruby::Api.config.token = "a"
    end
    
    let(:url) { "/api/documents" }
  
    let(:data_minimal_correct) do
      {
        images: [ { id: 1 }, { id: 2 } ],
        metadata: { title: "Fancy Book" }.to_json
      }
    end

    let(:api) {Corpusbuilder::Ruby::Api.new}

    let(:file) {double('file', :size => 0.5.megabytes, :content_type => 'png', :original_filename => 'rails')}

    let(:resp) {double(body: {id: 1, name: 'file.tiff'}.to_json)}

    it "returns expected result format for a request" do
      allow(RestClient).to receive(:post) { resp }
      expect(api.send_image(file: file, name: 'file.tiff')).to eq({ "id" => 1, "name" => 'file.tiff' })
    end

    it "passes the intended headers" do
      expect(RestClient).to receive(:post).with(anything, { file: file, name: "test.pdf"}, headers).and_return resp
      api.send_image(file: file, name: "test.pdf")
    end

    it "makes request to the intended URL" do
      expect(RestClient).to receive(:post).with(Corpusbuilder::Ruby::Api.config.api_url + "/api/images", anything, anything).and_return resp
      api.send_image(file: file, name: "test.pdf")
    end
  end
end
