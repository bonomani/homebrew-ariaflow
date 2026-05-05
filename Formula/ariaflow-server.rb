class AriaflowServer < Formula
  desc "Sequential aria2 queue driver with adaptive bandwidth control"
  homepage "https://github.com/bonomani/ariaflow-server"
  url "https://github.com/bonomani/ariaflow-server/archive/refs/tags/v0.1.259.tar.gz"
  sha256 "1a42710fb079589a0db09f7f8eca447c26dccedc8dba7b015933c1114d0cacc1"
  version "0.1.259"
  license "MIT"
  depends_on "node"
  depends_on "aria2"
  depends_on "pnpm" => :build
  head "https://github.com/bonomani/ariaflow-server.git", branch: "main"

  def install
    # Stamp the formula version into the CLI package.json so
    # `ariaflow --version` and /api/version report the real release.
    # The git source tarball ships 0.0.0; only release-npm.yml's
    # publish path patches this normally.
    inreplace "packages/cli/package.json", /"version": "[^"]*"/,
              "\"version\": \"#{version}\""

    system "pnpm", "install", "--frozen-lockfile=false"
    system "pnpm", "build"
    system "pnpm", "--filter", "@ariaflow/cli", "deploy", "--prod",
           "#{libexec}/cli"
    libexec.install "openapi.yaml"

    # Hardcode the node + script paths via Ruby interpolation —
    # launchd doesn't set HOMEBREW_PREFIX, so $-expansion at shell
    # time would fail (exit 126: command not executable).
    (bin/"ariaflow").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/cli/dist/index.js" "$@"
    EOS
    chmod 0755, bin/"ariaflow"

    # Back-compat shim: pre-TS users scripted against `ariaflow-server`.
    (bin/"ariaflow-server").write <<~EOS
      #!/bin/bash
      exec "#{opt_bin}/ariaflow" "$@"
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
