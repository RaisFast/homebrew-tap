class Raisfast < Formula
  desc "The fastest CMS, easiest to deploy. Rust-powered high-performance BaaS and headless CMS with built-in blog, ecommerce, wallet, payment and 4 plugin engines."
  homepage "https://github.com/raisfast/raisfast"
  version "0.3.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.13/raisfast-aarch64-apple-darwin.tar.xz"
      sha256 "a8bf5e0cf2d5acb1231e4a2915cc61b82405e2f8da1f02d00afe813c351a6991"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.13/raisfast-x86_64-apple-darwin.tar.xz"
      sha256 "a1a0a101b317130167077e66619b1c6f68edfeffd95b5d691796c3d5839605ff"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.13/raisfast-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ec8c6865e3b3199dff0a3e86397677e4436f08416ca05c9ebb9a7efb4932eb0c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.13/raisfast-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "11123fc04ce24ab729b2608fbdc8ee4e7fdefa712cc4723af143938098b64b59"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "raisfast"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "raisfast"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "raisfast"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "raisfast"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
