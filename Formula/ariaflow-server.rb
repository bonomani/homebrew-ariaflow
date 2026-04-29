class AriaflowServer < Formula
  desc "Sequential aria2 queue driver with adaptive bandwidth control"
  homepage "https://github.com/bonomani/ariaflow-server"
  url "https://github.com/bonomani/ariaflow-server/archive/refs/tags/v0.1.186.tar.gz"
  sha256 "21c9c036cf84cb82cdf6e1428b093f8c48bc73504791c78babf60931f7a9bf75"
  version "0.1.186"
  license "MIT"
  depends_on "python"
  depends_on "aria2"
  head "https://github.com/bonomani/ariaflow-server.git", branch: "main"

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/source/p/portalocker/portalocker-3.2.0.tar.gz"
    sha256 "1f3002956a54a8c3730586c5c77bf18fae4149e07eaf1c29fc3faf4d5a3f89ac"
  end

  def install
    python3 = "python3"
    venv = libexec/"venv"
    system python3, "-m", "venv", venv
    venv_pip = venv/"bin/pip"
    resource("portalocker").stage { system venv_pip, "install", "." }

    libexec.install "src"

    (bin/"ariaflow-server").write <<~EOS
      #!/bin/bash
      VENV="#{libexec}/venv"
      SITE=$(find "$VENV/lib" -maxdepth 1 -name 'python3.*' -print -quit)/site-packages
      exec env PYTHONPATH="#{libexec}/src:$SITE:${PYTHONPATH}" "$VENV/bin/python3" -m ariaflow_server "$@"
    EOS
    chmod 0755, bin/"ariaflow-server"
  end

  service do
    run [opt_bin/"ariaflow-server", "serve", "--host", "127.0.0.1", "--port", "8000"]
    keep_alive true
    working_dir var
    log_path var/"log/ariaflow-server.log"
    error_log_path var/"log/ariaflow-server.err.log"
  end

  test do
    system bin/"ariaflow-server", "--help"
  end
end
