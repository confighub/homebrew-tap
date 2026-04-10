# typed: false
# frozen_string_literal: true

class CubScan < Formula
  desc "Scan Kubernetes and GitOps configuration for risk"
  homepage "https://confighub.com"
  version "0.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.6.0/confighub-scan-darwin-arm64.tar.gz"
      sha256 "6eebda85b68cb461ea9a7c2b76d1b59aad6d62fb5d6d640114c92eb99a61c1b6"
    else
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.6.0/confighub-scan-darwin-amd64.tar.gz"
      sha256 "680168543c97a23eb10df14ddb7413f632b06100300ca8c7f346317a4da45707"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.6.0/confighub-scan-linux-arm64.tar.gz"
      sha256 "1ecfef94eee8783f1cdb7f014487d1f244df2b4022320fba21973b0f2fc8719c"
    else
      url "https://github.com/confighub/homebrew-tap/releases/download/cub-scan-v0.6.0/confighub-scan-linux-amd64.tar.gz"
      sha256 "99bbce1d80ea4fa390b58bf41c13473a7af5a2f40672aeada1fed15def50849b"
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
    assert_match "cub-scan --capabilities", output
  end
end
