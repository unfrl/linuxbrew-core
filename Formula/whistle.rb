require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.6.15.tgz"
  sha256 "aaf456cde97aa93b2aec9fa94df84c23d2fd3b69976d5cd4795055cc89de5705"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ad6b1e69d9c53ee297dc3854f46f1323830adf02b4f0b559801a1d7168176a40"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
