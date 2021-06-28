class Calabash < Formula
  desc "XProc (XML Pipeline Language) implementation"
  homepage "https://xmlcalabash.com/"
  url "https://github.com/ndw/xmlcalabash1/releases/download/1.3.1-100/xmlcalabash-1.3.1-100.zip"
  sha256 "dba453614011bb45b1b85b875d8da9642e7c9ed6d42f78e9963aee5485f3ff8d"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7706b55f501121dab8d831b4ea05cb8b48202d712896938076634c8bd4e99bd4"
  end

  depends_on "openjdk"
  depends_on "saxon"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"xmlcalabash-#{version}.jar", "calabash", "-Xmx1024m"
  end

  test do
    # This small XML pipeline (*.xpl) that comes with Calabash
    # is basically its equivalent "Hello World" program.
    system "#{bin}/calabash", "#{libexec}/xpl/pipe.xpl"
  end
end
