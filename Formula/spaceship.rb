class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://denysdovhan.com/spaceship-prompt"
  url "https://github.com/denysdovhan/spaceship-prompt/archive/v3.12.6.tar.gz"
  sha256 "251e6bd72326ea4eb1e51632df8ab4bef6fc541849b870014459515280c60be5"
  license "MIT"
  head "https://github.com/denysdovhan/spaceship-prompt.git"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b9f6c1574bd56c2beb60ce157ec3297594ae22ff5f1b691b3f2de9db7946df1f"
  end

  depends_on "zsh" => :test

  def install
    libexec.install "spaceship.zsh", "lib", "sections"
    zsh_function.install_symlink libexec/"spaceship.zsh" => "prompt_spaceship_setup"
  end

  test do
    ENV["SPACESHIP_CHAR_SYMBOL"] = "🍺"
    prompt = "setopt prompt_subst; autoload -U promptinit; promptinit && prompt -p spaceship"
    assert_match ENV["SPACESHIP_CHAR_SYMBOL"], shell_output("zsh -c '#{prompt}'")
  end
end
