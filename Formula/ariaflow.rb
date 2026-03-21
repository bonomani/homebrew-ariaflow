class Ariaflow < Formula
  desc "Sequential aria2 queue driver with adaptive bandwidth control"
  homepage "https://github.com/bonomani/ariaflow"
  url "https://github.com/bonomani/ariaflow/releases/download/v0.1.1-alpha.17/ariaflow-v0.1.1-alpha.17.tar.gz"
  sha256 "7c4bf8f9bfa2f49d98d4e24bcd349c284dbda1b80f13214821d53d5412b7b40b"
  version "0.1.1-alpha.17"
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
