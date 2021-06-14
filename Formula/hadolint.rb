class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v2.5.0.tar.gz"
  sha256 "0de36f1fa8f86183d51722cda142dd41039aab557b4e8d0bfc6f5fe265bf9fa1"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6732ebe9206eed36aa2fa84e80edb52d2977c4fda5d8948311f808f475fecf76"
    sha256 cellar: :any_skip_relocation, big_sur:       "2b6d81982fd1903ff791a11fac8248e53be31dd1b8c1e6c7ea8465e29dac16d7"
    sha256 cellar: :any_skip_relocation, catalina:      "8ffd44ca3e4a2d25e58c99fb19192db8bf16f52a13379cee0a51ba94194fb6e8"
    sha256 cellar: :any_skip_relocation, mojave:        "dd210590b03eb1ae282c02c388c024fec2855ce1d1451df61fa0cb16cde92244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "796d62ef07ada13c5157eafe36f32100c2b95a18eeca4795b31783f6bead27af"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "xz"

  on_linux do
    depends_on "gmp"
  end

  def install
    unless OS.mac?
      gmp = Formula["gmp"]
      ENV.prepend_path "LD_LIBRARY_PATH", gmp.lib
      ENV.prepend_path "LIBRARY_PATH", gmp.lib
    end

    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    ghc_args = [
      "--system-ghc",
      "--no-install-ghc",
      "--skip-ghc-check",
    ]

    system "stack", "-j#{jobs}", "build", *ghc_args
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install", *ghc_args
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
