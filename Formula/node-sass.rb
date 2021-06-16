class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.35.1.tgz"
  sha256 "8a5be8c73f75899711efb38f52e796142d9f15de1d79beb43931364ff1332d85"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7a1c2c6d718b79a9b8a3f7a947fff15a2e273a2bda9967763827debc4eaa2edb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
