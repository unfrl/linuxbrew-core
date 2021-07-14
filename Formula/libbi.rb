class Libbi < Formula
  desc "Bayesian state-space modelling on parallel computer hardware"
  homepage "https://libbi.org/"
  url "https://github.com/lawmurray/LibBi/archive/1.4.5.tar.gz"
  sha256 "af2b6d30e1502f99a3950d63ceaf7d7275a236f4d81eff337121c24fbb802fbe"
  license "GPL-2.0-only"
  revision 4
  head "https://github.com/lawmurray/LibBi.git"

  resource "Class::Inspector" do
    url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/Class-Inspector-1.32.tar.gz"
    sha256 "cefadc8b5338e43e570bc43f583e7c98d535c17b196bcf9084bb41d561cc0535"
  end

  resource "File::ShareDir" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/File-ShareDir-1.104.tar.gz"
    sha256 "07b628efcdf902d6a32e6a8e084497e8593d125c03ad12ef5cc03c87c7841caf"
  end

  resource "Template" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABW/Template-Toolkit-2.27.tar.gz"
    sha256 "1311a403264d0134c585af0309ff2a9d5074b8ece23ece5660d31ec96bf2c6dc"
  end

  resource "Graph" do
    url "https://cpan.metacpan.org/authors/id/J/JH/JHI/Graph-0.9704.tar.gz"
    sha256 "325e8eb07be2d09a909e450c13d3a42dcb2a2e96cc3ac780fe4572a0d80b2a25"
  end

  resource "thrust" do
    url "https://github.com/thrust/thrust/archive/1.8.2.tar.gz"
    sha256 "83bc9e7b769daa04324c986eeaf48fcb53c2dda26bcc77cb3c07f4b1c359feb8"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        next if r.name == "thrust"

        # need to set TT_ACCEPT=y for Template library for non-interactive install
        perl_flags = "TT_ACCEPT=y" if r.name == "Template"
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", perl_flags
        system "make"
        system "make", "install"
      end
    end

    resource("thrust").stage { (include/"thrust").install Dir["thrust/*"] }

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "INSTALLSITESCRIPT=#{bin}"

    # Disable dynamic selection of perl which may cause segfault when an
    # incompatible perl is picked up.
    # See, e.g., https://github.com/Homebrew/homebrew-core/issues/4936
    inreplace "script/libbi", "#!/usr/bin/env perl", "#!/usr/bin/perl"

    system "make"
    system "make", "install"

    pkgshare.install "Test.bi", "test.conf"
    bin.env_script_all_files(libexec+"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    cp Dir[pkgshare/"Test.bi", pkgshare/"test.conf"], testpath
    system "#{bin}/libbi", "sample", "@test.conf"
    assert_predicate testpath/"test.nc", :exist?
  end
end
