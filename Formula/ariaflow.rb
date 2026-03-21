class Ariaflow < Formula
  desc "Sequential aria2 queue driver with adaptive bandwidth control"
  homepage "https://github.com/bonomani/ariaflow"
  url "https://github.com/bonomani/ariaflow/archive/refs/tags/v0.1.1-alpha.6.tar.gz"
  sha256 "8937db6904518800c626c60798f967ce0530685752e26a254b46af9c7e876843"
  version "0.1.1-alpha.6"
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
