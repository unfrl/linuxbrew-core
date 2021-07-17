class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.49.0.tar.gz"
  sha256 "520f1e6552b5343127c87f1d0e90636ffb3973b05fedc116e48260703aa54ded"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e3808fb2d74c726a6c3fae356156c5a906ad1c110ead2b19883b43a5a6c28b6b"
    sha256 cellar: :any_skip_relocation, big_sur:       "9ad3c2cb03f0e8d3c39af1831f7751fb7a1504150925eefcff9beb856666d2f0"
    sha256 cellar: :any_skip_relocation, catalina:      "79b004fe2f9d5693a5de6807363df336d1dd89040c205ed175c10699d53ef064"
    sha256 cellar: :any_skip_relocation, mojave:        "995a0e236f0d2855e7322fcf677f3225c2d7a127d0fc620eb2a113e8ebd17650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e76d68347d5f6e80c079b99b960dbf94abde163b503364a4cc8e76d92f40489b" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "target/bin/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~EOS
      ---
      logger:
        level: ERROR
      input:
        type: file
        file:
          path: ./sample.txt
      pipeline:
        threads: 1
        processors:
         - type: decode
           decode:
             scheme: base64
      output:
        type: stdout
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
