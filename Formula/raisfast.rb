class Raisfast < Formula
  desc "The last backend you'll ever need. Rust-powered headless CMS with built-in blog, ecommerce, wallet, payment and 4 plugin engines."
  homepage "https://github.com/raisfast/raisfast"
  version "0.2.22"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.22/raisfast-aarch64-apple-darwin.tar.xz"
      sha256 "89047a2d9deed8afe5141445eb7aaa59635b7951f2abfd597918bd5b05cefabd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.22/raisfast-x86_64-apple-darwin.tar.xz"
      sha256 "880f5922a2eeb7491d9a8213480155987ee3820217c6a8b9b081c59d7382dc84"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.22/raisfast-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2cb3d4c7c86fdfb6a35b80f0711aa073553bd896d7fddbdd8a9a96ebb094fb35"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.22/raisfast-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "28a65166ab07fa2cbf5e796e062d6d207b431a79b7ab75559227918b4487b867"
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
