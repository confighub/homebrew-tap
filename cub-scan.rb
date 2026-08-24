# typed: false
# frozen_string_literal: true

class CubScan < Formula
  desc "Scan Kubernetes and GitOps configuration for risk"
  homepage "https://confighub.com"
  version "0.7.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.7.1/confighub-scan-darwin-arm64.tar.gz"
      sha256 "491866a7e210bed7cd87264d28f749d9fc5a5011b9835cefff2454214e560fd5"
    else
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.7.1/confighub-scan-darwin-amd64.tar.gz"
      sha256 "2623ba0451862c089bdc1792b0daa1abebc2a8e52f77a53e17a46a17bbf28978"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.7.1/confighub-scan-linux-arm64.tar.gz"
      sha256 "acf1467dab2c937e42076c13972cfd32068cf7947ccc7c26aadb1cf533a84618"
    else
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.7.1/confighub-scan-linux-amd64.tar.gz"
      sha256 "8108c128db993b17f9b92337022a9a6da9cc5faef8e506b8356b30230aa61735"
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
