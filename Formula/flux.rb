class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.114.1",
      revision: "f10042ff23fd575fac8055f5041eecf1db80afa4"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bd91c49404174c1ba144c7a0e38d7adcfc4544bfa32e9c3a3db2146f2d6dc2fd"
    sha256 cellar: :any,                 big_sur:       "da4f31757fb58d9187f063c72c11146521af858459f9f0c821c6bc366ed262f8"
    sha256 cellar: :any,                 catalina:      "68b8c13a44ca0d0ec04e3a2dd5bcb4988226335e693a62ccda0d17dcda46577b"
    sha256 cellar: :any,                 mojave:        "e7065e47c8f418e010fad574a7458752934d36cb68683254eb3d4cf2b77e8ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f889f5c796a0b2f02e724aca4f982d6e1df0fbcd7395a81935a2abf8ca42e2c"
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
