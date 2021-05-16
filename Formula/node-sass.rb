class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.32.13.tgz"
  sha256 "a322dfba655f7e79b0cfb435ad8daaea02c12eec929e89f429354b9f6fa81443"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "726eda5ec2911f15e99d44fc46000e0ac8200575b84efc834115089b6174a43c"
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
