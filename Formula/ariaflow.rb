class Ariaflow < Formula
  desc "Install ariaflow server and dashboard together"
  homepage "https://github.com/bonomani/ariaflow-server"
  url "https://github.com/bonomani/ariaflow-server/archive/refs/tags/v0.1.188.tar.gz"
  sha256 "a3d1b1a39dcc66aa9b320427ad0d51facd5359f3a58d546b689d572fce19da7a"
  version "0.1.188"
  license "MIT"

  depends_on "ariaflow-server"
  depends_on "ariaflow-dashboard"

  def install
    ohai "ariaflow-server and ariaflow-dashboard are now installed"
  end

  def caveats
    <<~EOS
      Start both services:
        brew services start ariaflow-server
        brew services start ariaflow-dashboard
    EOS
  end

  test do
    system "#{HOMEBREW_PREFIX}/bin/ariaflow-server", "--help"
    system "#{HOMEBREW_PREFIX}/bin/ariaflow-dashboard", "--version"
  end
end
