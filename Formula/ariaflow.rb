class Ariaflow < Formula
  desc "Install ariaflow server and dashboard together"
  homepage "https://github.com/bonomani/ariaflow-server"
  url "https://github.com/bonomani/ariaflow-server/archive/refs/tags/v0.1.212.tar.gz"
  sha256 "8e67468f8dbee44c95798a759c49a612e0559ae73ec5f5e020d5e1b63878b9c8"
  version "0.1.212"
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
