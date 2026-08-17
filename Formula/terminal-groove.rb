class TerminalGroove < Formula
  desc "Terminal groovebox for creating music in the terminal"
  homepage "https://github.com/dud0/terminal-groove"
  url "https://github.com/dud0/terminal-groove/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "ea49161f0f3f60a5513cbea687393a06c8248f08830e18371c1dda19d3cabf92"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "terminal-groove", shell_output("#{bin}/terminal-groove --help")
  end
end
