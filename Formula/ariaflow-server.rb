class AriaflowServer < Formula
  desc "Sequential aria2 queue driver with adaptive bandwidth control"
  homepage "https://github.com/bonomani/ariaflow-server"
  url "https://github.com/bonomani/ariaflow-server/archive/refs/tags/v0.1.232.tar.gz"
  sha256 "52fa5b2aca60c618364471f5f291d80d8368bc2da269e53acfd6ab7fd178f89d"
  version "0.1.232"
  license "MIT"
  depends_on "node"
  depends_on "aria2"
  depends_on "pnpm" => :build
  head "https://github.com/bonomani/ariaflow-server.git", branch: "main"

  def install
    system "pnpm", "install", "--frozen-lockfile=false"
    system "pnpm", "build"
    system "pnpm", "--filter", "@ariaflow/cli", "deploy", "--prod", "--legacy",
           "#{libexec}/cli"
    libexec.install "openapi.yaml"

    (bin/"ariaflow").write <<~EOS
      #!/bin/bash
      exec "${HOMEBREW_PREFIX}/bin/node" "#{libexec}/cli/dist/index.js" "$@"
    EOS
    chmod 0755, bin/"ariaflow"

    # Back-compat shim: pre-TS users scripted against `ariaflow-server`.
    (bin/"ariaflow-server").write <<~EOS
      #!/bin/bash
      exec "${HOMEBREW_PREFIX}/bin/ariaflow" "$@"
    EOS
    chmod 0755, bin/"ariaflow-server"
  end

  service do
    run [
      opt_bin/"ariaflow", "serve",
      "--host", "127.0.0.1",
      "--port", "8000",
      "--scheduler",
      "--openapi-yaml", "#{opt_libexec}/openapi.yaml"
    ]
    keep_alive true
    working_dir var
    log_path var/"log/ariaflow-server.log"
    error_log_path var/"log/ariaflow-server.err.log"
  end

  test do
    assert_match "ariaflow", shell_output("#{bin}/ariaflow --version")
    system bin/"ariaflow", "doctor", "--pretty"
  end
end
