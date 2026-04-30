class AriaflowServer < Formula
  desc "Sequential aria2 queue driver with adaptive bandwidth control"
  homepage "https://github.com/bonomani/ariaflow-server"
  url "https://github.com/bonomani/ariaflow-server/archive/refs/tags/v0.1.233.tar.gz"
  sha256 "211ca9e0662df8a5d0604bfa963efe21e2ad0ba11a1487fa63f177657db46cc4"
  version "0.1.233"
  license "MIT"
  depends_on "node"
  depends_on "aria2"
  depends_on "pnpm" => :build
  head "https://github.com/bonomani/ariaflow-server.git", branch: "main"

  def install
    system "pnpm", "install", "--frozen-lockfile=false"
    system "pnpm", "build"
    system "pnpm", "--filter", "@ariaflow/cli", "deploy", "--prod",
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
