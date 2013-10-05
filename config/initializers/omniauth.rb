
Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, 673516309334129, "4aa23b9123aff6bc8fffa0ca4e748d81"
    provider :twitter, "DhBU6S3F2fx5ewpP5wzA", "MwOGmC1NQNjJ2VguzIpMOdbF3p3Gq443I2C0YCBTFk"
end
