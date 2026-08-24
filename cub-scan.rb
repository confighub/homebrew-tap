# typed: false
# frozen_string_literal: true

class CubScan < Formula
  desc "Scan Kubernetes and GitOps configuration for risk"
  homepage "https://confighub.com"
  version "0.7.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.7.0/confighub-scan-darwin-arm64.tar.gz"
      sha256 "ff6f8c5fd74b08245e6d135dd9cf67ef126264ef005b9c36741e503156661120"
    else
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.7.0/confighub-scan-darwin-amd64.tar.gz"
      sha256 "444faff662c7b6751ea9537ce5fd3f0afc5a16e8797ad30f2ecc35e093f17692"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.7.0/confighub-scan-linux-arm64.tar.gz"
      sha256 "c5418bd5b41a043c3ad08a6825cc075c8a1bd7e41b48e5518f982e0f0e11bd4c"
    else
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.7.0/confighub-scan-linux-amd64.tar.gz"
      sha256 "944caab7610ee306f50ca4142a5d5bede25ca02fb83bb73f8526654678a728db"
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
