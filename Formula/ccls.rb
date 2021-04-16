class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  url "https://github.com/MaskRay/ccls/archive/0.20210330.tar.gz"
  sha256 "28c228f49dfc0f23cb5d581b7de35792648f32c39f4ca35f68ff8c9cb5ce56c2"
  license "Apache-2.0"
  head "https://github.com/MaskRay/ccls.git"
  revision 1 unless OS.mac?

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c84af931d520cc92941a4be9c34fdb8d5d7134cc19ca199307070dfb471c787e"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"
  depends_on macos: :high_sierra # C++ 17 is required

  depends_on "gcc" unless OS.mac? # C++17 is required

  fails_with gcc: "5"

  def install
    # https://github.com/Homebrew/brew/issues/6070
    ENV.remove %w[LDFLAGS LIBRARY_PATH HOMEBREW_LIBRARY_PATHS], "#{HOMEBREW_PREFIX}/lib" unless OS.mac?

    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"ccls", "-index=#{testpath}"
  end
end
