class AriaflowWeb < Formula
  desc "Local dashboard frontend for ariaflow"
  homepage "https://github.com/bonomani/ariaflow-web"
  url "https://github.com/bonomani/ariaflow-web/archive/refs/tags/v0.1.38.tar.gz"
  sha256 "88f3eba316dfa6370ab8f50bca719ddf5c46ca0efb92de15e4d34b40edb18875"
  version "0.1.38"
  license "MIT"
  depends_on "python"
  depends_on "ariaflow"
  head "https://github.com/bonomani/ariaflow-web.git", branch: "main"

  def install
    libexec.install "src"

    (bin/"ariaflow-web").write <<~EOS
      #!/bin/bash
      exec env PYTHONPATH="#{libexec}/src:${PYTHONPATH}" python3 -m ariaflow_web.cli "$@"
    EOS
    chmod 0755, bin/"ariaflow-web"
  end

  service do
    environment_variables ARIAFLOW_API_URL: "http://127.0.0.1:8000"
    run [opt_bin/"ariaflow-web", "--host", "127.0.0.1", "--port", "8001"]
    keep_alive true
    working_dir var
    log_path var/"log/ariaflow-web.log"
    error_log_path var/"log/ariaflow-web.err.log"
  end

  test do
    system bin/"ariaflow-web", "--version"
  end
end
