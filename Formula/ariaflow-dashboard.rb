class AriaflowDashboard < Formula
  desc "Local dashboard frontend for ariaflow"
  homepage "https://github.com/bonomani/ariaflow-dashboard"
  url "https://github.com/bonomani/ariaflow-dashboard/archive/refs/tags/v0.1.422.tar.gz"
  sha256 "8534d37a8ff7f583b4bcd3cec27fa229158e49c74141afe16ddec087fd5c89ba"
  version "0.1.422"
  license "MIT"
  depends_on "python"
  head "https://github.com/bonomani/ariaflow-dashboard.git", branch: "main"

  def install
    libexec.install "src"

    (bin/"ariaflow-dashboard").write <<~EOS
      #!/bin/bash
      exec env PYTHONPATH="#{libexec}/src:${PYTHONPATH}" python3 -m ariaflow_dashboard.cli "$@"
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

  test do
    system bin/"ariaflow-dashboard", "--version"
  end
end
