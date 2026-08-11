class Raisfast < Formula
  desc "The fastest CMS, easiest to deploy. Rust-powered high-performance BaaS and headless CMS with built-in blog, ecommerce, wallet, payment and 4 plugin engines."
  homepage "https://github.com/raisfast/raisfast"
  version "0.3.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.7/raisfast-aarch64-apple-darwin.tar.xz"
      sha256 "501305d4aa47f3f39fa8a52b6ea56d8c0b8ef328b5e43abf475aa9a5865f4e91"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.7/raisfast-x86_64-apple-darwin.tar.xz"
      sha256 "e69e8fdb3616dd34239b1860edaa024ed03702599a56c26e618e72cff33d0c3b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.7/raisfast-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eb96245620adba6b9cf321732b4914f83b096f5fbc84cb0456b7c4789ecdd400"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.7/raisfast-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "15a0b92c15ec27e863e70fbd85288d1366c3d96f703cc972bdf4cf44c2b2a285"
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
