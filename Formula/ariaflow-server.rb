class AriaflowServer < Formula
  desc "Sequential aria2 queue driver with adaptive bandwidth control"
  homepage "https://github.com/bonomani/ariaflow-server"
  url "https://github.com/bonomani/ariaflow-server/archive/refs/tags/v0.1.231.tar.gz"
  sha256 "5cfa2453b521a919d0586cf1e934bc3586d702b7f1625ee7f68fff010187fa5d"
  version "0.1.231"
  license "MIT"
  depends_on "node"
  depends_on "aria2"
  depends_on "corepack" => :build
  head "https://github.com/bonomani/ariaflow-server.git", branch: "main"

  def install
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"
    system "corepack", "enable"
    system "corepack", "prepare", "pnpm@9", "--activate"
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
