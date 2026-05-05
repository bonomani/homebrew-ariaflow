class AriaflowDashboard < Formula
  desc "Local dashboard frontend for ariaflow"
  homepage "https://github.com/bonomani/ariaflow-dashboard"
  url "https://github.com/bonomani/ariaflow-dashboard/archive/refs/tags/v0.1.411.tar.gz"
  sha256 "aed55eba5572cf07712585e9e2bb44393441fe1de05a11e121934a0e4ddaeb64"
  version "0.1.411"
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
