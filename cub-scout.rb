# typed: false
# frozen_string_literal: true

class CubScout < Formula
  desc "Explore and map GitOps in your clusters"
  homepage "https://confighub.com"
  url "https://github.com/confighub/cub-scout/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "2f1938540f5350a54c21f5eb205eb83f89a7340061338feaba4845ac37785008"
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
