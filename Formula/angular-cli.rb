require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.0.1.tgz"
  sha256 "50f58bbcb2529cef4e9ef730c9f31e089196e5249e3a333be5de5cc646565cb9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "908104e3153a2ee1dacad4bb24316607d613c8ba67ed8190a8747d8b6bfc621b"
    sha256 cellar: :any_skip_relocation, big_sur:       "0070a5c62876e35196730218584579c1797f76109711de55d90bf2fc5167dabe"
    sha256 cellar: :any_skip_relocation, catalina:      "0070a5c62876e35196730218584579c1797f76109711de55d90bf2fc5167dabe"
    sha256 cellar: :any_skip_relocation, mojave:        "0070a5c62876e35196730218584579c1797f76109711de55d90bf2fc5167dabe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad3a6b1d4ccc6f56b5caa0602a869c92ad157c6ec1fdc8db96a2bd9f2e3d6736"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
