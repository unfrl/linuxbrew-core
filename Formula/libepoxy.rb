class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.7.tar.xz"
  sha256 "9479cc0146ffb395fdecf9bd2a5930834fd0bce490cbcc4681ffd716bb3a0763"
  license "MIT"

  # We use a common regex because libepoxy doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libepoxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "a6ceb2c71ddc503492f9992a236e82282108968708c59c115b2070ccc090b9fa"
    sha256 cellar: :any,                 big_sur:       "db75486d4407ac6ad7555b4aa0ce475b7c6308514142df8345a27e1e6a0095e0"
    sha256 cellar: :any,                 catalina:      "bbd5b5e7a51dc98b8309500469e1ba56c0bbfb9804eb8c041d2f994a93830346"
    sha256 cellar: :any,                 mojave:        "1e6e1e73f88f5a4e3ffc7b2667994cffdb29a27c2d1ce9014dbb42e61e617d89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d528c6f9ad22a31bc63369f2255315c674f1892f914226bf1c2787178d93ca4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

  depends_on "freeglut" unless OS.mac?

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS

      #include <epoxy/gl.h>
      #ifdef OS_MAC
      #include <OpenGL/CGLContext.h>
      #include <OpenGL/CGLTypes.h>
      #include <OpenGL/OpenGL.h>
      #endif
      int main()
      {
          #ifdef OS_MAC
          CGLPixelFormatAttribute attribs[] = {0};
          CGLPixelFormatObj pix;
          int npix;
          CGLContextObj ctx;

          CGLChoosePixelFormat( attribs, &pix, &npix );
          CGLCreateContext(pix, (void*)0, &ctx);
          #endif

          glClear(GL_COLOR_BUFFER_BIT);
          #ifdef OS_MAC
          CGLReleasePixelFormat(pix);
          CGLReleaseContext(pix);
          #endif
          return 0;
      }
    EOS
    args = %w[-lepoxy]
    args += %w[-framework OpenGL -DOS_MAC] if OS.mac?
    args += %w[-o test]
    system ENV.cc, "test.c", *args
    system "ls", "-lh", "test"
    system "file", "test"
    system "./test"
  end
end
