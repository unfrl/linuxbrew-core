require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-2.1.0.tgz"
  sha256 "febda707750e32c829578ffa35626ec03c32f5b65a106f81c3799d14766790e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c4e01092595503908e7a76942ef9ace0e803bbb6a2228814a8ea817209a7bd1f"
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
