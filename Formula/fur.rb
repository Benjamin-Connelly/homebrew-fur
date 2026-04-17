class Fur < Formula
  desc "Dual-mode markdown navigator with TUI and web interfaces"
  homepage "https://github.com/Benjamin-Connelly/fur"
  url "https://github.com/Benjamin-Connelly/fur.git",
      tag:      "v1.0.1",
      revision: "18d22cea179e5e279262fc4725f80705b6c44b60"
  license "MIT"
  head "https://github.com/Benjamin-Connelly/fur.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.strftime("%Y-%m-%dT%H:%M:%SZ")}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/fur"

    generate_completions_from_executable(bin/"fur", "completion")

    man1.install Dir["man/man1/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fur version")

    (testpath/"test.md").write("# Hello\n\nWorld\n")
    assert_match "Hello", shell_output("#{bin}/fur cat #{testpath}/test.md")
  end
end
