# typed: false
# frozen_string_literal: true

class CubScan < Formula
  desc "Scan Kubernetes and GitOps configuration for risk"
  homepage "https://confighub.com"
  version "0.5.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.5.0/confighub-scan-darwin-arm64.tar.gz"
      sha256 "4c6086140b6628b9149d31fa18e77762958a7ca5b534f08fa9f03d3a24ccfc2e"
    else
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.5.0/confighub-scan-darwin-amd64.tar.gz"
      sha256 "d6e5acd6bb51d6c3d3e2b2b32b901cda60a388d0d414942b42a62eec5505ba49"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.5.0/confighub-scan-linux-arm64.tar.gz"
      sha256 "66ec1f8c4dab37fcd7262a5240883dd9f343538f3582c57674f656ce79ef94e1"
    else
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.5.0/confighub-scan-linux-amd64.tar.gz"
      sha256 "b8217ccdf28a0f80256d46f296b91bd4a2aa92ee67c2ef7942175a9aebdc999d"
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
