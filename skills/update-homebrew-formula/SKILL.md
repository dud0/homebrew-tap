---
name: update-homebrew-formula
description: Update an existing Homebrew tap formula to a specified upstream release, including source URL and tag verification, archive SHA-256 regeneration with the brew-contrib alias, source installation, formula testing, strict audit, and final diff review. Use when Codex is asked to bump a formula version in a tap repository or prepare a formula release update; stop before committing unless the user explicitly requests a commit.
---

# Update Homebrew Formula

Update an existing formula in a tap to a user-specified upstream release. Treat the archive checksum as the SHA-256 of the downloaded source archive, not as the Git commit hash.

## Workflow

### 1. Inspect the tap and preserve existing work

Identify the formula and tap name from the repository rather than guessing:

```bash
pwd
rg --files Formula
git status --short --branch
sed -n '1,200p' Formula/<formula>.rb
git remote -v
```

Record any pre-existing modifications. Do not overwrite unrelated changes or reset the worktree.

Use the existing formula's `homepage`, source repository, URL pattern, dependencies, and test as the starting point. Do not change dependencies or tests unless the new release requires it.

### 2. Verify the upstream release

Extract the source repository and requested version from the formula and verify the tag before editing:

```bash
git ls-remote --tags <source-repository> \
  "refs/tags/<version>" "refs/tags/<version>^{}"
```

Use the exact tag returned by upstream. A release version such as `1.1.0` may have a tag spelling that differs from the version, or the source repository may have changed. If the expected tag is missing or the repository is ambiguous, investigate upstream and ask the user before creating a checksum.

When the release is in a different repository than the current URL, update the URL to the actual release repository. Keep `homepage` aligned with the project's canonical page.

### 3. Update the source URL

Edit only the formula fields required for the release. For a GitHub archive, use the verified tag, for example:

```ruby
url "https://github.com/<owner>/<repo>/archive/refs/tags/v1.1.0.tar.gz"
```

Do not retain the old archive URL or its checksum. Use `apply_patch` for the edit.

### 4. Regenerate the archive checksum

Use the contributor-only Homebrew alias. In non-interactive tool shells, invoke the alias through an interactive Bash shell so the alias from `~/.bashrc` is loaded:

```bash
bash -ic 'brew-contrib fetch --force --formula ./Formula/<formula>.rb'
```

If the sandbox blocks Homebrew's cache or lock directory, request the necessary permission and rerun the same command. Homebrew normally reports the downloaded archive's SHA-256 when the old checksum does not match. Replace the formula's `sha256` with that value.

Never use the upstream commit SHA as the formula checksum. Confirm that the checksum belongs to the exact archive URL and tag now in the formula.

### 5. Build from source

Install the local formula from source with the same alias:

```bash
bash -ic 'brew-contrib install --build-from-source ./Formula/<formula>.rb'
```

Allow Homebrew to fetch or upgrade build dependencies as needed. If compilation fails, determine whether the release changed its Rust version, system-library requirements, binary name, or install layout before changing the formula.

### 6. Run the formula test

Run the test using the tap-qualified formula name, which avoids relying on path support:

```bash
bash -ic 'brew-contrib test <tap>/<formula>'
```

Treat a nonzero result as unresolved. Confirm that the test exercises the installed binary and that the expected executable name still matches the formula.

### 7. Audit the formula

Run the strict online audit by formula name, not by file path:

```bash
bash -ic 'brew-contrib audit --strict --online <tap>/<formula>'
```

An informational warning about an optional missing Homebrew analysis gem does not fail the audit when the command exits successfully; report it. Fix actual audit errors before proceeding.

### 8. Review and hand off

Run the final whitespace check and inspect the complete diff:

```bash
git diff --check
git diff -- Formula/<formula>.rb
git status --short --branch
```

Confirm that the diff contains only the intended release URL, checksum, and any release-required changes. Report the verified tag, archive checksum, build result, test result, audit result, and remaining worktree state.

Do not stage or commit unless the user explicitly asks. If asked to commit afterward, recheck the diff, use a concise message such as `<formula> <version>`, and then commit.

## Failure handling

- Stop before editing if the requested upstream tag does not exist.
- Stop before changing the checksum if the archive URL returns 404 or resolves to an unexpected project.
- Do not guess a checksum, commit hash, tag spelling, binary name, or dependency change.
- Preserve user changes already present in the worktree.
- If network, cache permissions, or Homebrew setup blocks verification, report the exact failing command and request only the required permission or user decision.
