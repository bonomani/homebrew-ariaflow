class Ariaflow < Formula
  desc "Sequential aria2 queue driver with adaptive bandwidth control"
  homepage "https://github.com/bonomani/ariaflow"
  url "https://github.com/bonomani/ariaflow/archive/refs/tags/v0.1.1-alpha.43.tar.gz"
  sha256 "72823ae200a79f175283baeb3952b2e55cb9a51b35a825d05dcc6ad28636a22c"
  version "0.1.1-alpha.43"
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

    (bin/"ariaflow-api").write <<~EOS
      #!/bin/bash
      exec env PYTHONPATH="#{libexec}/src:${PYTHONPATH}" python3 -c "from aria_queue.webapp import serve; server = serve(host='127.0.0.1', port=8000); print('Serving API on http://127.0.0.1:8000'); server.serve_forever()"
    EOS
    chmod 0755, bin/"ariaflow-api"
  end

  service do
    run [opt_bin/"ariaflow-api"]
    keep_alive true
    working_dir var
    log_path var/"log/ariaflow.log"
    error_log_path var/"log/ariaflow.err.log"
  end

  test do
    system bin/"ariaflow", "--help"
  end
end
