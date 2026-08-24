# typed: false
# frozen_string_literal: true

class CubScan < Formula
  desc "Scan Kubernetes and GitOps configuration for risk"
  homepage "https://confighub.com"
  version "0.7.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.7.3/confighub-scan-darwin-arm64.tar.gz"
      sha256 "a629b90463be0c0cbf7c97087b81d8b0707e9a7138203d1d22b5fb2379ff6c6f"
    else
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.7.3/confighub-scan-darwin-amd64.tar.gz"
      sha256 "5bcb73ccfeb3aa5d812a07f499674796e5a3fb48d0aed357e4d43620b59eda93"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.7.3/confighub-scan-linux-arm64.tar.gz"
      sha256 "dcdee1a9722e484183fb0a1f43ccc5264d7213e1412607352c8a6028e08bf4f1"
    else
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.7.3/confighub-scan-linux-amd64.tar.gz"
      sha256 "0cd0d284975b43689b11cb7f3222f7be81bb75924fe28dae68e0fa94e5f1ce90"
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

    %w[
      bundle-manifest-v1.json
      risk-catalog-v1.json
      risk-function-links-v1.json
      cross-tool-mapping-v1.json
      helm-pattern-database-v1.json
    ].each do |asset|
      path = Dir["**/#{asset}"].first
      odie "missing #{asset} in release archive" if path.nil?

      (share/"confighub-scan").install path => asset
    end
  end

  test do
    output = shell_output("#{bin}/cub-scan -h 2>&1")
    assert_match "cub-scan --capabilities", output

    capabilities = shell_output("#{bin}/cub-scan --capabilities")
    assert_match '"resolved": true', capabilities
  end
end
