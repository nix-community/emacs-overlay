from packaging.version import Version, InvalidVersion
import subprocess
import json

# (Ab)use Python's PEP-440 version parsing for sorting Emacs versions.
# Emacs versions aren't exactly PEP-440, but `git ls-remote`'s sort function does not support -rc
# suffixes and neither does GNU sort.
# Meaning that older -rc releases may be prefered to a later stable release.

TAG_PREAMBLE = "refs/tags/emacs-"


def main():
    proc = subprocess.run(
        [
            "git",
            "ls-remote",
            "--tags",
            "--refs",
            "https://git.savannah.gnu.org/git/emacs.git",
            "emacs-[1-9]*",
        ],
        stdout=subprocess.PIPE,
        check=True,
    )

    tags: list[str] = []
    for line in proc.stdout.decode().splitlines():
        _commit, ref = line.split("\t")
        if not ref.startswith(TAG_PREAMBLE):
            continue

        tag = ref[len(TAG_PREAMBLE) :]

        # Skip unparseable versions
        try:
            Version(tag)
        except InvalidVersion:
            pass
        else:
            tags.append(tag)

    latest_version = sorted(tags, key=lambda tag: Version(tag))[-1]
    latest_tag = f"emacs-{latest_version}"

    proc = subprocess.run(
        [
            "nix-prefetch-git",
            "--rev",
            f"refs/tags/{latest_tag}",
            "git://git.savannah.gnu.org/emacs.git",
        ],
        stdout=subprocess.PIPE,
        check=True,
    )
    digest = json.loads(proc.stdout.decode().strip())

    with open("./emacs-unstable.json", "w") as fp:
        json.dump(
            {
                "type": "savannah",
                "url": "git://git.savannah.gnu.org/emacs.git",
                "rev": latest_tag,
                "sha256": digest['sha256'],
                "version": latest_version,
            },
            fp,
        )
        fp.write("\n")


if __name__ == "__main__":
    main()
