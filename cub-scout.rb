# typed: false
# frozen_string_literal: true

class CubScout < Formula
  desc "Explore and map GitOps in your clusters"
  homepage "https://confighub.com"
  url "https://github.com/confighub/cub-scout/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "83950302ae9da9f1d49c9163ff4fafa38c065988e2c58d0c43d7e7656b105bc0"
  license "MIT"
  head "https://github.com/confighub/cub-scout.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.BuildTag=v#{version} -X main.BuildDate=homebrew"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cub-scout"
  end

  test do
    output = shell_output("#{bin}/cub-scout version")
    assert_match "cub-scout", output
  end
end
