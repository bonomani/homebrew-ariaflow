class Ariaflow < Formula
  desc "Install ariaflow server and dashboard together"
  homepage "https://github.com/bonomani/ariaflow-server"
  url "https://github.com/bonomani/ariaflow-server/archive/refs/tags/v0.1.190.tar.gz"
  sha256 "9ee7c4334ff1e909bc1729c2ad5b78a5b5afc0cb07575144a11f989f34f4cdc5"
  version "0.1.190"
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
