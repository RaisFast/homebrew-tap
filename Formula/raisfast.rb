class Raisfast < Formula
  desc "The last backend you'll ever need. Rust-powered headless CMS with built-in blog, ecommerce, wallet, payment and 4 plugin engines."
  homepage "https://github.com/raisfast/raisfast"
  version "0.2.18"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.18/raisfast-aarch64-apple-darwin.tar.xz"
      sha256 "4addb6ca72bccc0dcd3eac18658b3827ec977245761fa5669a1c46c26c8ec542"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.18/raisfast-x86_64-apple-darwin.tar.xz"
      sha256 "27c16d614946a0ac488c7724776106cc551dca0d859d35e580f78cc6b7880bb2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.18/raisfast-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fe5f0475a07f899076fd051878f5ca5177c93a45be544e532f11ddfcf69b1d9a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.18/raisfast-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1b71519eb610cdd78a7ef484e140434fcfe5687d59269280ffab681b42ec93c5"
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
