class TerminalGroove < Formula
  desc "Terminal groovebox for creating music in the terminal"
  homepage "https://github.com/dud0/terminal-groove"
  url "https://github.com/dud0/terminal-groove/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "07fa7a43f17b2b4e25918600d186ba47f7cd5eccef4928a5201cd6e844f22fb8"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "terminal-groove", shell_output("#{bin}/terminal-groove --help")
  end
end
