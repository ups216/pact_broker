describe "Update a pacticipant" do

  let(:request_body) { {'repositoryUrl' => 'http://foo'} }
  let(:path) { "/pacticipants/Some%20Consumer" }
  let(:response_body_hash) { JSON.parse(subject.body, symbolize_names: true) }

  context "with a PUT" do
    let(:request_body_hash) do
      {
        repositoryUrl: "http://foo",
        repositoryName: "name",
        repositoryOrganization: "org",
        mainDevelopmentBranches: ["main"]
      }
    end

    subject { put(path, request_body_hash.to_json, {'CONTENT_TYPE' => 'application/json' }) }

    context "when the pacticipant exists" do
      before do
        td.create_pacticipant("Some Consumer")
      end

      it { is_expected.to be_a_hal_json_success_response }

      it "updates the properties" do
        expect(response_body_hash).to include(request_body_hash)
      end

      context "with only some of the properties set" do
        let(:request_body_hash) do
          {
            repositoryUrl: "http://foo",
          }
        end

        it "blanks out the missing ones" do
          expect(response_body_hash[:repositoryName]).to be nil
        end
      end
    end

    context "when the pacticipant does not exist" do
      it { is_expected.to be_a_404_response }
    end
  end

  context "with a PATCH" do
    subject { patch(path, request_body.to_json, {'CONTENT_TYPE' => 'application/json' })  }

    context "when the pacticipant exists" do
      before do
        td.create_pacticipant("Some Consumer")
      end

      it "returns a 200 OK" do
        puts subject.body unless subject.status == 200
        expect(subject.status).to be 200
      end

      it "returns a json body with the updated pacticipant" do
        expect(subject.headers['Content-Type']).to eq "application/hal+json;charset=utf-8"
      end
    end
  end
end
