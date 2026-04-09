# typed: false
# frozen_string_literal: true

class CubScan < Formula
  desc "Scan Kubernetes and GitOps configuration for risk"
  homepage "https://confighub.com"
  version "0.5.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.5.1/confighub-scan-darwin-arm64.tar.gz"
      sha256 "ec55e72d94fe16c02db1e4d5a27e2fe4915f7cd5dd667ed5c276612279f2149a"
    else
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.5.1/confighub-scan-darwin-amd64.tar.gz"
      sha256 "d088f0313d3ad5e38980015c9681257a6583f2b746fe35dde1857b21c9a66ecf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.5.1/confighub-scan-linux-arm64.tar.gz"
      sha256 "a96d621898b1af939cb5e9eff5f96e08fba76e13be2ca1f8b15f9470e1669dff"
    else
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.5.1/confighub-scan-linux-amd64.tar.gz"
      sha256 "16e8664c2c67cc188ce4bab73053595105ed18a6671eeb2d762679e32fa0fb1f"
    end
  end

  def install
    %w[
      cub-scan
      compare-adapter-findings
      stage3-review-packet
      validate-risk-quality
      benchmark-scorecard
    ].each do |tool|
      path = Dir["**/#{tool}"].first
      odie "missing #{tool} in release archive" if path.nil?

      bin.install path => tool
    end
  end

  test do
    output = shell_output("#{bin}/cub-scan -h 2>&1")
    assert_match "Path to normalized risk catalog", output
  end
end
