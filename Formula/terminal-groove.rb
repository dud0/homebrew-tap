class TerminalGroove < Formula
  desc "Terminal groovebox for creating music in the terminal"
  homepage "https://github.com/dud0/terminal-groove"
  url "https://github.com/dud0/terminal-groove/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "6a457bf8315a8c81bc4f2aec06facb8f32dddf4beabf11b4f255954577036fcc"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "terminal-groove", shell_output("#{bin}/terminal-groove --help")
  end
end
