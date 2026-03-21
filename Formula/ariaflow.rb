class Ariaflow < Formula
  desc "Sequential aria2 queue driver with adaptive bandwidth control"
  homepage "https://github.com/bonomani/ariaflow"
  url "https://github.com/bonomani/ariaflow/releases/download/v0.1.1-alpha.18/ariaflow-v0.1.1-alpha.18.tar.gz"
  sha256 "cf6543eb477a5ab2eed6941d3f49c0a20a34bdccf14851b2bd2b8b7f30b18372"
  version "0.1.1-alpha.18"
  license "MIT"
  head "https://github.com/bonomani/ariaflow.git", branch: "master"

  depends_on "python3"

  def install
    libexec.install "src"

    (bin/"ariaflow").write <<~EOS
      #!/bin/bash
      export PYTHONPATH="#{libexec}/src:${PYTHONPATH}"
      exec "#{Formula["python3"].opt_bin}/python3" -m aria_queue "$@"
    EOS
    chmod 0755, bin/"ariaflow"
  end

  test do
    system bin/"ariaflow", "--help"
  end
end
