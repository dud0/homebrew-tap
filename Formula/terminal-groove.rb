class TerminalGroove < Formula
  desc "Terminal groovebox for creating music in the terminal"
  homepage "https://github.com/dud0/terminal-groove"
  url "https://github.com/dud0/terminal-groovebox/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "d093e1ba3ef0e31b0ec3deaa682ce5c24d2b211ecac2e4d66e7284784c00f8ff"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "terminal-groove", shell_output("#{bin}/terminal-groove --help")
  end
end
