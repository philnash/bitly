# frozen_string_literal: true

RSpec.describe Bitly::API::Bitlink do
  let(:client) { instance_double(Bitly::API::Client) }
  let(:qrcode_id) { "the_qrcode_id" }
  let(:qrcode_data) {
    {
      "qrcode_id" => qrcode_id,
      "group_guid" => "the_group_guid",
      "title" => "The title",
      "render_customizations" => {
        "background_color" => "#ffffff",
        "dot_pattern_color" => "#000000",
        "dot_pattern_type" => "block",
        "corners" => {
          "corner_1" => {
            "inner_color" => "#000000",
            "outer_color" => "#000000",
            "shape" => "slightly_round"
          },
          "corner_2" => {
            "inner_color" => "#000000",
            "outer_color" => "#000000",
            "shape" => "slightly_round"
          },
          "corner_3" => {
            "inner_color" => "#000000",
            "outer_color" => "#000000",
            "shape" => "slightly_round"
          }
        },
        "frame" => {
          "id" => "border_only",
          "colors" => {
            "primary" => "#000000",
            "secondary" => "",
            "background" => "#ffffff"
          },
          "text" => {},
          "frame_svg" => "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 240 240\" width=\"240\" height=\"240\"></svg>",
          "immutable" => false,
          "thumbnail" => ""
        },
        "logo" => {
          "crop" => {"w" => 0, "h" => 0, "x" => 0, "y" => 0},
          "crop_type" => "",
          "image_guid" => "abcd"
        },
        "branding" => {
          "bitly_brand" => true
        },
        "spec_settings" => {
          "version" => 0,
          "error_correction" => 0,
          "mask" => 0
        }
      },
      "qr_code_type" => "bitlink",
      "bitlink_id" => "bit.ly/abc1234",
      "long_urls" => [
        "https://www.example.org"
      ],
      "serialized_content" => "https://bit.ly/abc1234?r=qr",
      "archived" => false,
      "created" => "2025-01-15T12:56:28+0000",
      "updated" => "2025-01-15T12:56:39+0000"
    }
  }

  describe "fetching a QR code" do
    let(:response) {
      Bitly::HTTP::Response.new(
        status: "200",
        body: qrcode_data.to_json,
        headers: {}
      )
    }

    it "can fetch a QR code" do
      expect(client).to receive(:request)
        .with(path: "/qr-codes/#{qrcode_id}")
        .and_return(response)

      qrcode = Bitly::API::Qrcode.fetch(client: client, qrcode_id: qrcode_id)
      expect(qrcode.serialized_content).to eq("https://bit.ly/abc1234?r=qr")
      expect(qrcode.long_urls.first).to eq("https://www.example.org")
    end
  end

  describe "#scans_summary" do
    it "can fetch the scans summary" do
      qrcode = Bitly::API::Qrcode.new(client: client, data: qrcode_data)

      scans_summary = instance_double(Bitly::API::Qrcode::ScansSummary)
      expect(Bitly::API::Qrcode::ScansSummary).to receive(:fetch)
        .with(client: client, qrcode_id: qrcode_id, unit: nil, units: nil, unit_reference: nil)
        .and_return(scans_summary)
      expect(qrcode.scans_summary).to eq(scans_summary)
    end
  end

  describe "#image" do
    let(:response) {
      Bitly::HTTP::Response.new(
        status: "200",
        body: {
          "qr_code_image": "data:image/svg+xml;base64,..."
        }.to_json,
        headers: {}
      )
    }

    it "retrieves a PNG of the QR code" do
      expect(client).to receive(:request)
        .with(path: "/qr-codes/A1B2C3/image", params: {format: "png"})
        .and_return(response)

      qrcode = Bitly::API::Qrcode.new(data: {"qrcode_id" => "A1B2C3"}, client: client)
      expect(qrcode.image(format: "png")).to eq("data:image/svg+xml;base64,...")
    end
  end
end
