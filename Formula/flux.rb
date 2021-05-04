class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.114.0",
      revision: "61acefb23267036a023ecaaf688b7c06e9a0b673"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3e804300e4100f94a9717b9274cfac112401499095e863842bc5845358152f9f"
    sha256 cellar: :any,                 big_sur:       "ca9188977d8826d13bac9bafea43c5391b1eacfa587455e05dafac9682a7d088"
    sha256 cellar: :any,                 catalina:      "2b2389f62ee0a653daadb4ad9c22aae1ec4f88022adbf5f5825b2a59756f6d48"
    sha256 cellar: :any,                 mojave:        "5322e65485fe326186e79989d319a8c6d85fc2a595613172298e650729643c60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7fe6d1a2830a37ec4fed00b91da837491b7848cb7dd8ab93e469022b77f33e7"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
    depends_on "pkg-config" => :build
    depends_on "ragel" => :build
  end

  def install
    system "make", "build"
    system "go", "build", "./cmd/flux"
    bin.install %w[flux]
    include.install "libflux/include/influxdata"
    lib.install Dir["libflux/target/*/release/libflux.{dylib,a,so}"]
  end

  test do
    assert_equal "8\n", shell_output("flux execute \"5.0 + 3.0\"")
  end
end
