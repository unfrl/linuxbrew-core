require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-2.1.1.tgz"
  sha256 "8812a33e236a35f7d48829c3e3ccfa42c765beec67c07af42e7febe66ebeb09b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fff8e250f38e19e5dc4439d4f8dd0aa695148b13a94904b36ce48d64a77a855e"
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
