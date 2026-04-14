# typed: false
# frozen_string_literal: true

class CubScout < Formula
  desc "Explore and map GitOps in your clusters"
  homepage "https://confighub.com"
  url "https://github.com/confighub/cub-scout/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "7bae1fc7ff9d33f1488470e3003937a4dbf3a8b035c9d1592be0ed155f50049d"
  license "MIT"
  head "https://github.com/confighub/cub-scout.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.BuildTag=v#{version} -X main.BuildDate=homebrew"
    system "go", "build", *std_go_args(output: bin/"cub-scout", ldflags: ldflags), "./cmd/cub-scout"
    system "go", "build", *std_go_args(output: bin/"kubectl-cub_scout", ldflags: ldflags), "./cmd/cub-scout"
  end

  test do
    output = shell_output("#{bin}/cub-scout version")
    assert_match "cub-scout", output
    plugin_output = shell_output("#{bin}/kubectl-cub_scout version")
    assert_match "cub-scout", plugin_output
  end
end
