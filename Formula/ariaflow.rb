class Ariaflow < Formula
  desc "Sequential aria2 queue driver with adaptive bandwidth control"
  homepage "https://github.com/bonomani/ariaflow"
  url "https://github.com/bonomani/ariaflow/releases/download/v0.1.1-alpha.25/ariaflow-v0.1.1-alpha.25.tar.gz"
  sha256 "15dd68fbbfc34ef1d4391a9db7b1e8831ecc8ddc32eab652f4b6ca42352e9d10"
  version "0.1.1-alpha.25"
  license "MIT"
  head "https://github.com/bonomani/ariaflow.git", branch: "master"

  def install
    libexec.install "src"

    (bin/"ariaflow").write <<~EOS
      #!/bin/bash
      exec env PYTHONPATH="#{libexec}/src:${PYTHONPATH}" python3 -m aria_queue "$@"
    EOS
    chmod 0755, bin/"ariaflow"
  end

  test do
    system bin/"ariaflow", "--help"
  end
end
