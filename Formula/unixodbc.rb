class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "http://www.unixodbc.org/"
  url "http://www.unixodbc.org/unixODBC-2.3.9.tar.gz"
  sha256 "52833eac3d681c8b0c9a5a65f2ebd745b3a964f208fc748f977e44015a31b207"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "http://www.unixodbc.org/download.html"
    regex(/href=.*?unixODBC[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "66e4b186a19526e02782557afe6926d2cfb9f372e94cbcc387f531b122f510e0"
    sha256 big_sur:       "7e85c6cae69a18bc572ac63a624d44f5e1f71b84693cdf6acf165449b35f90b7"
    sha256 catalina:      "bd9ae8319552747572047c19a24ff3d55e3c59a51635ab799fd0959655d07459"
    sha256 mojave:        "e3b8eeab0c16a66f1aae4784e5248f46c1476460982113803d62840379116f07"
  end

  depends_on "libtool"

  conflicts_with "libiodbc", because: "both install `odbcinst.h`"
  conflicts_with "virtuoso", because: "both install `isql` binaries"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-static",
                          "--enable-gui=no"
    system "make", "install"
  end

  test do
    system bin/"odbcinst", "-j"
  end
end
