require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-2.0.5.tgz"
  sha256 "c832bf2feb852bda70d5df0e806acf91ac34fd61eae41d4a3bb76c3c94fcf3c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cc28541d094868a6e34de6141158cfa4f0fa05aa7d133ccbdf570a3aae186859"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end
