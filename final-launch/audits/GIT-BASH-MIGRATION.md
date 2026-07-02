# Git Bash Migration Instructions

Run these commands from the root of the local `LaborCoin` repository after downloading and extracting the audit package.

```bash
git pull --ff-only

mkdir -p final-launch/audits/evidence

# Preserve Git history while correcting the old misspelled filename.
git mv 'final-launch/Provenanance-&-Security-Audit.md' \
  'final-launch/audits/provenance-security-audit.md'

# Replace the moved draft and add the rest of the generated audit package.
# Change the source path below to the folder where this package was extracted.
cp -f /c/Users/YOUR_WINDOWS_USERNAME/Downloads/LaborCoin-audit-package/final-launch/audits/provenance-security-audit.md \
  final-launch/audits/provenance-security-audit.md

cp -f /c/Users/YOUR_WINDOWS_USERNAME/Downloads/LaborCoin-audit-package/final-launch/audits/README.md \
  final-launch/audits/README.md

cp -f /c/Users/YOUR_WINDOWS_USERNAME/Downloads/LaborCoin-audit-package/final-launch/audits/aragon-permission-audit.md \
  final-launch/audits/aragon-permission-audit.md

cp -f /c/Users/YOUR_WINDOWS_USERNAME/Downloads/LaborCoin-audit-package/final-launch/audits/deployment-provenance-inventory.md \
  final-launch/audits/deployment-provenance-inventory.md

cp -f /c/Users/YOUR_WINDOWS_USERNAME/Downloads/LaborCoin-audit-package/final-launch/audits/exchange-retirement-audit.md \
  final-launch/audits/exchange-retirement-audit.md

cp -f /c/Users/YOUR_WINDOWS_USERNAME/Downloads/LaborCoin-audit-package/final-launch/audits/revocation-plan.csv \
  final-launch/audits/revocation-plan.csv

cp -f /c/Users/YOUR_WINDOWS_USERNAME/Downloads/LaborCoin-audit-package/final-launch/audits/deployment-provenance-inventory.csv \
  final-launch/audits/deployment-provenance-inventory.csv

cp -f /c/Users/YOUR_WINDOWS_USERNAME/Downloads/LaborCoin-audit-package/final-launch/audits/evidence/* \
  final-launch/audits/evidence/

# Find and update any stale repository links.
git grep -n 'Provenanance-&-Security-Audit.md' || true
git grep -n 'Provenanance' || true
```

Replace every stale link found above with:

```text
audits/provenance-security-audit.md
```

Add this line to `final-launch/README.md` in the appropriate documentation list:

```markdown
- [Provenance and Security Audit](audits/provenance-security-audit.md)
```

Then review and commit:

```bash
git add final-launch/audits final-launch/README.md
git status
git diff --cached --stat
git diff --cached

git commit -m "Add launch provenance and security audit package"
git push origin main
```

After pushing, confirm that this path opens correctly:

```text
final-launch/audits/provenance-security-audit.md
```
