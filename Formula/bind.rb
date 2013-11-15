require 'formula'

class Bind < Formula
  homepage 'http://www.isc.org/software/bind/'
  url 'http://ftp.isc.org/isc/bind9/9.9.4-P1/bind-9.9.4-P1.tar.gz'
  version '9.9.4-P1'
  sha1 '35dd28de21626fd6327230c38d0f164dd2263bed'

  option 'with-brewed-openssl', 'Build with Homebrew OpenSSL instead of the system version'

  depends_on "openssl" if MacOS.version <= :leopard or build.with?('brewed-openssl')

  def install
    ENV.libxml2
    # libxml2 appends one inc dir to CPPFLAGS but bind ignores CPPFLAGS
    ENV.append 'CFLAGS', ENV.cppflags

    ENV['STD_CDEFINES'] = '-DDIG_SIGCHASE=1'

    args = [
      "--prefix=#{prefix}",
      "--enable-threads",
      "--enable-ipv6",
    ]

    if build.with? 'brewed-openssl'
      args << "--with-ssl-dir=#{Formula.factory('openssl').opt_prefix}"
    elsif MacOS.version > :leopard
      # For Xcode-only systems we help a bit to find openssl.
      # If CLT.installed?, it evaluates to "/usr", which works.
      args << "--with-openssl=#{MacOS.sdk_path}/usr"
    end

    system "./configure", *args

    # From the bind9 README: "Do not use a parallel 'make'."
    ENV.deparallelize
    system "make"
    system "make install"
  end
end
