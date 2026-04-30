class Ariaflow < Formula
  desc "Install ariaflow server and dashboard together"
  homepage "https://github.com/bonomani/ariaflow-server"
  url "https://github.com/bonomani/ariaflow-server/archive/refs/tags/v0.1.222.tar.gz"
  sha256 "e370ce00687ea9c910bed4d443fd62b82f86b3fd9891c6ee4a9f8c782921599d"
  version "0.1.222"
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
