class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.8.0.tar.gz"
  sha256 "706b55667de221b651b0d938dfbb468112b322ed41a634d3ca5c8bd861b19e8a"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "64386f472b24cb0b9a9745e2f996fa4790a89b527759d2b55cdef5ec1f95a20a"
    sha256 cellar: :any_skip_relocation, big_sur:       "13b26ed70659fb85343a33f4682ac73d192b0812f7679c70bf2435ab3e9656c2"
    sha256 cellar: :any_skip_relocation, catalina:      "5d8bbb2986eab7cf6e4aec5e3adea4f4b4e10e9a665f48ebe0e52c459ad200b7"
    sha256 cellar: :any_skip_relocation, mojave:        "e0be42b120f1e395c5a0de8666db9b7d33edc027c00b78948ab98baef4ddf0a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aee300c875f0450261a50e329e7a5dbd869f151761adff2a342bfc002d861a9"
  end

  depends_on "rust" => :build
  depends_on "llvm" => :build unless OS.mac?

  uses_from_macos "zlib"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "etc/completion/completion.bash" => "delta"
    zsh_completion.install "etc/completion/completion.zsh" => "_delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
