class QrGenerator < ApplicationService
  require "rqrcode"

  attr_reader :val

  def initialize(val)
    @val = val
  end

  def call 
    qrcode = RQRCode::QRCode.new(val)

    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 20,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 1024
    )

    image_name = SecureRandom.hex

    IO.binwrite("tmp/#{image_name}.png", png.to_s)

    # Blob
    ActiveStorage::Blob.create_and_upload!(
      io: File.open("tmp/#{image_name}.png"),
      filename: image_name,
      content_type: 'png'
    )
  end
end 