class Ariaflow < Formula
  desc "Install ariaflow server and dashboard together"
  homepage "https://github.com/bonomani/ariaflow-server"
  url "https://github.com/bonomani/ariaflow-server/archive/refs/tags/v0.1.217.tar.gz"
  sha256 "74b25ae711671ae449300c34ccf2e130bda52ab5361a3826453cff3b2163e0b1"
  version "0.1.217"
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
