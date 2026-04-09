class AriaflowDashboard < Formula
  desc "Local dashboard frontend for ariaflow"
  homepage "https://github.com/bonomani/ariaflow-dashboard"
  url "https://github.com/bonomani/ariaflow-dashboard/archive/refs/tags/v0.1.244.tar.gz"
  sha256 "453fa7ac9c76e458fbc8b6b24321abe807860a68bf94e429fe7073be31db4cd4"
  version "0.1.244"
  license "MIT"
  depends_on "python"
  head "https://github.com/bonomani/ariaflow-dashboard.git", branch: "main"

  def install
    libexec.install "src"

    (bin/"ariaflow-dashboard").write <<~EOS
      #!/bin/bash
      exec env PYTHONPATH="#{libexec}/src:${PYTHONPATH}" python3 -m ariaflow_web.cli "$@"
    EOS
    chmod 0755, bin/"ariaflow-dashboard"
  end

  service do
    environment_variables ARIAFLOW_API_URL: "http://127.0.0.1:8000"
    run [opt_bin/"ariaflow-dashboard", "--host", "127.0.0.1", "--port", "8001"]
    keep_alive true
    working_dir var
    log_path var/"log/ariaflow-dashboard.log"
    error_log_path var/"log/ariaflow-dashboard.err.log"
  end

  def caveats
    <<~EOS
      ariaflow-dashboard can connect to a remote ariaflow-server instance via ARIAFLOW_API_URL.
      To run both locally:
        brew install ariaflow
        brew services start ariaflow-server
        brew services start ariaflow-dashboard
    EOS
  end

  test do
    system bin/"ariaflow-dashboard", "--version"
  end
end
