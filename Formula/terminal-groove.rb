class TerminalGroove < Formula
  desc "Terminal groovebox for creating music in the terminal"
  homepage "https://github.com/dud0/terminal-groove"
  url "https://github.com/dud0/terminal-groove/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "d8f821b49f6637cbb9e84d4b10117ba294f15b02a41cea921a37872f7c523b27"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "terminal-groove", shell_output("#{bin}/terminal-groove --help")
  end
end
