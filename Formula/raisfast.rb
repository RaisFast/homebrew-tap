class Raisfast < Formula
  desc "The fastest CMS, easiest to deploy. Rust-powered high-performance BaaS and headless CMS with built-in blog, ecommerce, wallet, payment and 4 plugin engines."
  homepage "https://github.com/raisfast/raisfast"
  version "0.2.24"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.24/raisfast-aarch64-apple-darwin.tar.xz"
      sha256 "28f384d372bd57b0fe28ba1cc28ff438885d575d773373a1ab51db2507890177"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.24/raisfast-x86_64-apple-darwin.tar.xz"
      sha256 "093037c4c9a9a7bd0c3e744cf0e9e2107edcd6d9fc801dc9e16b047a2983ed5f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.24/raisfast-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f4f330b8aa094ffa4bfe8d256c45110e20105f32cc09fc79f52a4c9042547a47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.24/raisfast-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3bd86bfffce8d5b01731c460130446c1543710c39463961f9edd043465f5e3bd"
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
    bin.install "raisfast" if OS.mac? && Hardware::CPU.arm?
    bin.install "raisfast" if OS.mac? && Hardware::CPU.intel?
    bin.install "raisfast" if OS.linux? && Hardware::CPU.arm?
    bin.install "raisfast" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
