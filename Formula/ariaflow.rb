class Ariaflow < Formula
  desc "Sequential aria2 queue driver with adaptive bandwidth control"
  homepage "https://github.com/bonomani/ariaflow"
  url "https://github.com/bonomani/ariaflow/archive/refs/tags/v0.1.62.tar.gz"
  sha256 "1ddc840a83ff6ec4d24daf42b3233cbb3ee633f186e27bde5ba5006af4f3a45a"
  version "0.1.62"
  license "MIT"
  depends_on "python"
  depends_on "aria2"
  head "https://github.com/bonomani/ariaflow.git", branch: "main"

  def install
    libexec.install "src"

    (bin/"ariaflow").write <<~EOS
      #!/bin/bash
      exec env PYTHONPATH="#{libexec}/src:${PYTHONPATH}" python3 -m aria_queue "$@"
    EOS
    chmod 0755, bin/"ariaflow"
  end

  service do
    run [opt_bin/"ariaflow", "serve", "--host", "127.0.0.1", "--port", "8000"]
    keep_alive true
    working_dir var
    log_path var/"log/ariaflow.log"
    error_log_path var/"log/ariaflow.err.log"
  end

  test do
    system bin/"ariaflow", "--help"
  end
end
