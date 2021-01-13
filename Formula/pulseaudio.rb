class Pulseaudio < Formula
  desc "Sound system for POSIX OSes"
  homepage "https://wiki.freedesktop.org/www/Software/PulseAudio/"
  url "https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-14.1.tar.xz"
  sha256 "b0bcca2a45e4fe1f73c7709dcf75a17dd5235688d5d150069e765dda4884b837"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "BSD-3-Clause"]

  # The regex here avoids x.99 releases, as they're pre-release versions.
  livecheck do
    url :stable
    regex(/href=["']?pulseaudio[._-]v?((?!\d+\.9\d+)\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "78e3fae17b2d33cb1606b1f3072fa833229833dfe8f0e8d1ce1a014fce3bba58" => :big_sur
    sha256 "6289c0626c739e546b659d127400d636929da4a3249442b3906607e6a56406b9" => :arm64_big_sur
    sha256 "ba20f1bc46b0f7134c2e1407f59d2bfc35b3217d5b2e85a8146ce2ececd30f69" => :catalina
    sha256 "e488038f6b789bb06fc581ef485ed8fc5d7da72727631923d1bdd639a7c1dad2" => :mojave
    sha256 "0f9fbeb9f3329922fccc7d7c783501aa8f64f5f4574b27a93e1178ebb1b33915" => :x86_64_linux
  end

  head do
    url "https://gitlab.freedesktop.org/pulseaudio/pulseaudio.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "intltool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libtool"
  depends_on "openssl@1.1"
  depends_on "speexdsp"
  unless OS.mac?
    depends_on "dbus"
    depends_on "glib"
    depends_on "libcap"
  end

  uses_from_macos "perl" => :build
  uses_from_macos "expat"
  uses_from_macos "m4"

  unless OS.mac?
    # Depends on XML::Parser
    # Using the host's Perl interpreter to install XML::Parser fails when using brew's glibc.
    # Use brew's Perl interpreter instead.
    # See Linuxbrew/homebrew-core#8148
    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
      sha256 "1ae9d07ee9c35326b3d9aad56eae71a6730a73a116b9fe9e8a4758b7cc033216"
    end
  end

  def install
    unless OS.mac?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resources.each do |res|
        res.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}", *("CC=#{ENV.cc}" unless OS.mac?)
          system "make", "install"
        end
      end
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-neon-opt
      --disable-nls
      --disable-x11
    ]

    if OS.mac?
      args << "--with-mac-sysroot=#{MacOS.sdk_path})"
      args << "--with-mac-version-min=#{MacOS.version}"
    end

    unless OS.mac?
      # Perl depends on gdbm.
      # If the dependency of pulseaudio on perl is build-time only,
      # pulseaudio detects and links gdbm at build-time, but cannot locate it at run-time.
      # Thus, we have to
      #  - specify not to use gdbm, or
      #  - add a dependency on gdbm if gdbm is wanted (not implemented).
      # See Linuxbrew/homebrew-core#8148
      args << "--with-database=simple"

      # Tell pulseaudio to use the brewed udev rules dir instead of the system one,
      # which it does not have permission to modify
      args << "--with-udev-rules-dir=#{lib}/udev/rules.d"
    end

    if build.head?
      # autogen.sh runs bootstrap.sh then ./configure
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"

    # https://stackoverflow.com/questions/56309056/is-gschemas-compiled-architecture-specific-can-i-ship-it-with-my-python-library
    rm "#{share}/glib-2.0/schemas/gschemas.compiled" unless OS.mac?
  end

  plist_options manual: "pulseaudio"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/pulseaudio</string>
          <string>--exit-idle-time=-1</string>
          <string>--verbose</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/#{name}.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/#{name}.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_match "module-sine", shell_output("#{bin}/pulseaudio --dump-modules")
  end
end
