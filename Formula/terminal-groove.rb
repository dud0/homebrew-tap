class TerminalGroove < Formula
  desc "Terminal groovebox for creating music in the terminal"
  homepage "https://github.com/dud0/terminal-groove"
  url "https://github.com/dud0/terminal-groove/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "5160c7f08f16fc15f654c3fd2fb794f38b568e14b70e8a54a16c2448980b3c38"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "terminal-groove", shell_output("#{bin}/terminal-groove --help")
  end
end
